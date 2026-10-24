#!/usr/bin/env python3
"""Resolve public releases and verify every archive before updating formulas."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
API = "https://api.github.com"
TARGETS = {
    "dutchman": (
        "dutchman",
        ("aarch64-apple-darwin", "x86_64-apple-darwin",
         "aarch64-unknown-linux-gnu", "x86_64-unknown-linux-gnu"),
    ),
    "dutchman-pilot": (
        "pilot", ("aarch64-macos", "aarch64-linux", "x86_64-linux"),
    ),
}
SEMVER = re.compile(
    r"v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
    r"(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?"
    r"(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?"
)


def request(url):
    headers = {"User-Agent": "dutchman-homebrew-bump"}
    # Only send the API credential to GitHub's API, never asset hosts.
    if urllib.parse.urlsplit(url).hostname == "api.github.com":
        headers["Accept"] = "application/vnd.github+json"
        headers["X-GitHub-Api-Version"] = "2022-11-28"
        if os.environ.get("GITHUB_TOKEN"):
            headers["Authorization"] = f"Bearer {os.environ['GITHUB_TOKEN']}"
    return urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=120)


def api(path):
    with request(API + path) as response:
        return json.load(response)


def version_key(release):
    match = SEMVER.fullmatch(release["tag_name"])
    if not match:
        raise ValueError(f"Unsupported release tag: {release['tag_name']!r}")
    major, minor, patch, pre = match.groups()
    # Numeric prerelease identifiers sort before text identifiers (SemVer 2.0).
    prerelease = tuple((0, int(p)) if p.isdigit() else (1, p)
                       for p in pre.split(".")) if pre else ()
    return (int(major), int(minor), int(patch), pre is None, prerelease,
            release.get("published_at") or "")


def resolve(repo):
    path = f"/repos/dutchman-cad/{repo}/releases"
    try:
        release = api(path + "/latest")
    except urllib.error.HTTPError as error:
        if error.code != 404 or repo != "pilot":
            raise
    else:
        if release["draft"] or release["prerelease"] or release["tag_name"] == "nightly":
            raise ValueError(f"{repo}: /latest did not return a stable release")
        version_key(release)
        return release

    # Read all pages: /releases ordering can differ from SemVer ordering.
    releases = []
    page = 1
    while True:
        batch = api(f"{path}?per_page=100&page={page}")
        releases.extend(r for r in batch if not r["draft"] and r["tag_name"] != "nightly")
        if len(batch) < 100:
            break
        page += 1
    stable = [r for r in releases if not r["prerelease"]]
    candidates = stable or releases
    if not candidates:
        raise ValueError(f"{repo}: no eligible releases")
    return max(candidates, key=version_key)


def checksum(asset, sidecar):
    digest = hashlib.sha256()
    size = 0
    with request(asset["browser_download_url"]) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
            size += len(chunk)
    if size != asset["size"]:
        raise ValueError(f"{asset['name']}: expected {asset['size']} bytes, received {size}")
    actual = digest.hexdigest()
    if sidecar:
        with request(sidecar["browser_download_url"]) as response:
            content = response.read(16385).decode("utf-8")
        # Accept bare digests, sha256sum, and BSD shasum formats.
        hashes = re.findall(r"(?<![0-9a-fA-F])[0-9a-fA-F]{64}(?![0-9a-fA-F])", content)
        if len(hashes) != 1 or hashes[0].lower() != actual:
            raise ValueError(f"{asset['name']}: .sha256 does not match downloaded archive ({actual})")
    return actual


def replace_once(pattern, replacement, text, label):
    result, count = re.subn(pattern, lambda m: replacement(m), text, flags=re.MULTILINE)
    if count != 1:
        raise ValueError(f"{label}: expected exactly one matching formula field, found {count}")
    return result


def update(name, repo, targets):
    release = resolve(repo)
    tag = release["tag_name"]
    version = tag.removeprefix("v")
    version_key(release)
    assets = {a["name"]: a for a in release["assets"]}
    expected = [f"{repo}-{version}-{target}.tar.gz" for target in targets]
    missing = [asset for asset in expected if asset not in assets]
    if missing:
        raise ValueError(f"{repo} {tag}: missing expected assets: {', '.join(missing)}")
    path = ROOT / "Formula" / f"{name}.rb"
    original = path.read_text()
    updated = replace_once(r'^(  version ")[^"]+(".*)$',
                           lambda m: m[1] + version + m[2], original, name)
    for target, filename in zip(targets, expected):
        asset = assets[filename]
        print(f"Verifying {filename}", flush=True)
        sha = checksum(asset, assets.get(filename + ".sha256"))
        # Match by repository and target, independent of the old version or tag.
        pattern = (
            r'^(\s+url ")https://github\.com/dutchman-cad/' + re.escape(repo)
            + r'/releases/download/[^/]+/[^"/]+-' + re.escape(target)
            + r'\.tar\.gz("[^\n]*\n\s+sha256 ")[0-9a-f]{64}("[^\n]*)$'
        )
        updated = replace_once(pattern,
                               lambda m: m[1] + asset["browser_download_url"] + m[2] + sha + m[3],
                               updated, f"{name}/{target}")
    updated = updated.replace(
        "  # Bootstrap values: run scripts/bump.py with GitHub access before publishing.\n", "")
    return path, original, updated, version


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Report changes without writing files")
    args = parser.parse_args()
    # Validate both products before writing either formula.
    updates = [update(name, repo, targets) for name, (repo, targets) in TARGETS.items()]
    for path, original, updated, version in updates:
        if original == updated:
            print(f"{path.stem} {version}: up to date")
        else:
            old = re.search(r'^  version "([^"]+)"', original, re.MULTILINE)[1]
            print(f"{path.stem}: {old} -> {version} (version, URLs and/or SHA256s changed)"
                  + (" [check only]" if args.check else ""))
            if not args.check:
                path.write_text(updated)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError) as error:
        print(f"bump: {error}", file=sys.stderr)
        sys.exit(1)
