"""Offline checks for turning built bottles into release assets and bottle blocks."""

import hashlib
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("bottle", Path(__file__).parents[1] / "scripts/bottle.py")
bottle = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bottle)


def built(directory, name, version, tag, content=None, cellar="any_skip_relocation"):
    """Write what `brew bottle --json` leaves behind for one formula and tag."""
    content = content or f"{name} {version} {tag}".encode()
    local = f"{name}--{version}.{tag}.bottle.tar.gz"
    (directory / local).write_bytes(content)
    entry = {
        "formula": {"name": name, "pkg_version": version},
        "bottle": {"root_url": "https://example.invalid", "cellar": cellar, "rebuild": 0,
                   "tags": {tag: {"filename": local.replace("--", "-"), "local_filename": local,
                                  "sha256": hashlib.sha256(content).hexdigest()}}},
    }
    (directory / f"{name}--{version}.{tag}.bottle.json").write_text(
        json.dumps({f"dutchman-cad/tap/{name}": entry}))
    return hashlib.sha256(content).hexdigest()


class BottleTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        (self.root / "Formula").mkdir()
        for name in bottle.PLATFORMS:
            (self.root / "Formula" / f"{name}.rb").write_text(
                (bottle.ROOT / "Formula" / f"{name}.rb").read_text())
        self.built = self.root / "built"
        self.built.mkdir()
        self.assets = self.root / "assets"
        patcher = patch.object(bottle, "ROOT", self.root)
        patcher.start()
        self.addCleanup(patcher.stop)
        self.addCleanup(self.temp.cleanup)

    def version(self, name):
        text = (self.root / "Formula" / f"{name}.rb").read_text()
        return text.split("/releases/download/v", 1)[1].split("/", 1)[0]

    def test_platform_from_tag(self):
        self.assertEqual(bottle.platform("arm64_golden_gate"), "macos-arm64")
        self.assertEqual(bottle.platform("sequoia"), "macos-x86_64")
        self.assertEqual(bottle.platform("arm64_linux"), "linux-arm64")
        self.assertEqual(bottle.platform("x86_64_linux"), "linux-x86_64")

    def test_every_platform_becomes_a_block_and_assets(self):
        version = self.version("dutchman")
        shas = {tag: built(self.built, "dutchman", version, tag)
                for tag in ("arm64_golden_gate", "sequoia", "arm64_linux", "x86_64_linux")}
        self.assertEqual(bottle.write(self.built, self.assets), {"dutchman": version})
        text = (self.root / "Formula" / "dutchman.rb").read_text()
        root_url = f"{bottle.RELEASES}/dutchman-{version}"
        expected = "\n".join([
            "  bottle do",
            f'    root_url "{root_url}"',
            f'    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "{shas["arm64_golden_gate"]}"',
            f'    sha256 cellar: :any_skip_relocation, arm64_big_sur: "{shas["arm64_golden_gate"]}"',
            f'    sha256 cellar: :any_skip_relocation, sonoma:        "{shas["sequoia"]}"',
            f'    sha256 cellar: :any_skip_relocation, big_sur:       "{shas["sequoia"]}"',
            f'    sha256 cellar: :any_skip_relocation, arm64_linux:   "{shas["arm64_linux"]}"',
            f'    sha256 cellar: :any_skip_relocation, x86_64_linux:  "{shas["x86_64_linux"]}"',
            "  end",
        ])
        # Right after livecheck, with one blank line on each side.
        self.assertIn("    strategy :github_latest\n  end\n\n" + expected + "\n\n  on_macos do\n", text)
        names = sorted(path.name for path in (self.assets / f"dutchman-{version}").iterdir())
        self.assertEqual(names, sorted(f"dutchman-{version}.{tag}.bottle.tar.gz" for tag in (
            "arm64_sonoma", "arm64_big_sur", "sonoma", "big_sur", "arm64_linux", "x86_64_linux")))
        self.assertEqual(bottle.needed(), ["dutchman-pilot"])
        # Writing again replaces the block rather than adding a second one.
        bottle.write(self.built, self.assets)
        self.assertEqual((self.root / "Formula" / "dutchman.rb").read_text(), text)

    def test_missing_platform_is_refused_unless_partial(self):
        version = self.version("dutchman-pilot")
        built(self.built, "dutchman-pilot", version, "arm64_linux")
        with self.assertRaisesRegex(ValueError, "no bottle for macos-arm64, linux-x86_64"):
            bottle.write(self.built, self.assets)
        written = bottle.write(self.built, self.assets, root_url="file:///b/{name}-{version}", partial=True)
        self.assertEqual(written, {"dutchman-pilot": version})
        text = (self.root / "Formula" / "dutchman-pilot.rb").read_text()
        self.assertIn(f'    root_url "file:///b/dutchman-pilot-{version}"\n', text)
        self.assertEqual(text.count("sha256 cellar:"), 1)

    def test_bottles_must_match_the_formula(self):
        built(self.built, "dutchman", "9.9.9", "arm64_linux")
        with self.assertRaisesRegex(ValueError, "does not install"):
            bottle.write(self.built, self.assets, partial=True)

    def test_relocated_or_altered_bottles_are_refused(self):
        version = self.version("dutchman")
        built(self.built, "dutchman", version, "arm64_linux", cellar="/home/linuxbrew/.linuxbrew/Cellar")
        with self.assertRaisesRegex(ValueError, "relocatable"):
            bottle.write(self.built, self.assets, partial=True)
        built(self.built, "dutchman", version, "arm64_linux")
        (self.built / f"dutchman--{version}.arm64_linux.bottle.tar.gz").write_bytes(b"changed")
        with self.assertRaisesRegex(ValueError, "SHA256 does not match"):
            bottle.write(self.built, self.assets, partial=True)


if __name__ == "__main__":
    unittest.main()
