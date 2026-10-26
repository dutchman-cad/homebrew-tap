#!/usr/bin/env python3
"""Turn bottles built by `brew bottle --json` into release assets and formula bottle blocks.

The formulas install prebuilt release archives, so a bottle holds the same files. Without
bottles, Homebrew treats an install as a build from source and, on macOS, refuses to continue
without current Command Line Tools even though nothing is compiled.
"""

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
RELEASES = "https://github.com/dutchman-cad/homebrew-tap/releases/download"
# The platforms each formula ships archives for.
PLATFORMS = {
    "dutchman": ("macos-arm64", "macos-x86_64", "linux-arm64", "linux-x86_64"),
    "dutchman-pilot": ("macos-arm64", "linux-arm64", "linux-x86_64"),
}
# On macOS Homebrew pours a bottle tagged for an older release, so one bottle per architecture
# covers every newer macOS. The archives run on macOS 11 and later. Sonoma is listed as well, so
# bottles still pour once Homebrew stops recognising Big Sur.
TAGS = {
    "macos-arm64": ("arm64_sonoma", "arm64_big_sur"),
    "macos-x86_64": ("sonoma", "big_sur"),
    "linux-arm64": ("arm64_linux",),
    "linux-x86_64": ("x86_64_linux",),
}
BLOCK = re.compile(r"^  bottle do\n.*?^  end\n\n?", re.MULTILINE | re.DOTALL)
LIVECHECK = re.compile(r"^  livecheck do\n.*?^  end\n", re.MULTILINE | re.DOTALL)


def formula_path(name, directory=None):
    return Path(directory or ROOT / "Formula") / f"{name}.rb"


def needed():
    """Formulas without a bottle block, which the release workflow must bottle."""
    return [name for name in PLATFORMS if not BLOCK.search(formula_path(name).read_text())]


def platform(tag):
    """The platform a tag from `brew bottle` was built on, such as arm64_tahoe -> macos-arm64."""
    if tag.endswith("_linux"):
        return "linux-" + ("arm64" if tag.startswith("arm64_") else "x86_64")
    return "macos-" + ("arm64" if tag.startswith("arm64_") else "x86_64")


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as file:
        while chunk := file.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def collect(directory):
    """Read every bottle JSON under directory into {formula: {platform: bottle}}."""
    bottles = {}
    for path in sorted(Path(directory).rglob("*.bottle.json")):
        for full_name, entry in json.loads(path.read_text()).items():
            name = entry["formula"]["name"]
            if name not in PLATFORMS:
                raise ValueError(f"{path.name}: unexpected formula {full_name}")
            bottle = entry["bottle"]
            if bottle["cellar"] != "any_skip_relocation" or bottle["rebuild"] != 0:
                raise ValueError(f"{path.name}: expected a relocatable bottle without rebuild, "
                                 f"found cellar {bottle['cellar']!r}, rebuild {bottle['rebuild']}")
            for tag, spec in bottle["tags"].items():
                archive = path.parent / spec["local_filename"]
                if sha256(archive) != spec["sha256"]:
                    raise ValueError(f"{archive.name}: SHA256 does not match {path.name}")
                found = bottles.setdefault(name, {})
                target = platform(tag)
                if target in found:
                    raise ValueError(f"{name}: more than one bottle for {target}")
                found[target] = dict(version=entry["formula"]["pkg_version"], archive=archive,
                                     sha256=spec["sha256"])
    return bottles


def block(root_url, entries):
    lines = ["  bottle do", f'    root_url "{root_url}"']
    # Homebrew's style aligns the digests.
    width = max(len(tag) for tag, _ in entries) + 1
    lines += [f'    sha256 cellar: :any_skip_relocation, {tag + ":":<{width}} "{sha}"' for tag, sha in entries]
    return "\n".join(lines + ["  end", ""]) + "\n"


def with_block(text, new):
    """Replace the formula's bottle block, or add one after livecheck."""
    text = BLOCK.sub("", text)
    match = LIVECHECK.search(text)
    if not match:
        raise ValueError("formula has no livecheck block to place the bottle block after")
    return text[:match.end()] + "\n" + new.rstrip("\n") + "\n" + text[match.end():]


def write(directory, assets, root_url=None, partial=False, formula_dir=None):
    """Write bottle blocks and copy each bottle to the asset name of every tag it serves.

    Returns {formula: version} for the formulas written.
    """
    written = {}
    assets = Path(assets)
    for name, found in collect(directory).items():
        expected = PLATFORMS[name]
        missing = [target for target in expected if target not in found]
        if missing and not partial:
            raise ValueError(f"{name}: no bottle for {', '.join(missing)}")
        versions = {bottle["version"] for bottle in found.values()}
        if len(versions) != 1:
            raise ValueError(f"{name}: bottles for different versions: {', '.join(sorted(versions))}")
        version = versions.pop()
        path = formula_path(name, formula_dir)
        text = path.read_text()
        if f"/releases/download/v{version}/" not in text:
            raise ValueError(f"{name}: bottles are for {version}, which the formula does not install")
        entries = []
        target_dir = assets / f"{name}-{version}"
        target_dir.mkdir(parents=True, exist_ok=True)
        for target in expected:
            if target not in found:
                continue
            bottle = found[target]
            for tag in TAGS[target]:
                shutil.copyfile(bottle["archive"], target_dir / f"{name}-{version}.{tag}.bottle.tar.gz")
                entries.append((tag, bottle["sha256"]))
        url = root_url or f"{RELEASES}/{name}-{version}"
        path.write_text(with_block(text, block(url.format(name=name, version=version), entries)))
        written[name] = version
    return written


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("needed", help="Print the formulas that have no bottles, one per line")
    writer = commands.add_parser("write", help="Write bottle blocks from `brew bottle --json` output")
    writer.add_argument("bottles", help="Directory holding the .bottle.json and .bottle.tar.gz files")
    writer.add_argument("assets", help="Directory to copy release assets into, one folder per release")
    writer.add_argument("--root-url", help="Bottle location instead of the tap's release, with "
                        "{name} and {version} filled in (for local tests)")
    writer.add_argument("--partial", action="store_true",
                        help="Allow bottles for only some platforms (for local tests)")
    writer.add_argument("--formula-dir", help="Formula directory to write into instead of this tap's")
    args = parser.parse_args()
    if args.command == "needed":
        print("\n".join(needed()))
    else:
        written = write(args.bottles, args.assets, args.root_url, args.partial, args.formula_dir)
        # One "name version" line per formula, read by the release workflow.
        for name, version in written.items():
            print(f"{name} {version}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError) as error:
        print(f"bottle: {error}", file=sys.stderr)
        sys.exit(1)
