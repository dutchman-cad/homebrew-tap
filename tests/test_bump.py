"""Offline regression checks for release selection and archive integrity."""

import contextlib
import hashlib
import importlib.util
import io
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError

spec = importlib.util.spec_from_file_location("bump", Path(__file__).parents[1] / "scripts/bump.py")
bump = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bump)


def release(tag, prerelease=True, **kwargs):
    return dict(tag_name=tag, prerelease=prerelease, draft=False, published_at="2026-01-01", **kwargs)


class BumpTests(unittest.TestCase):
    def test_convert_uses_latest_only(self):
        expected = release("v0.1.6", False)
        with patch.object(bump, "api", return_value=expected) as api:
            self.assertEqual(bump.resolve("dutchman"), expected)
            api.assert_called_once_with("/repos/dutchman-cad/dutchman/releases/latest")

    def test_convert_never_falls_back_to_nightly(self):
        with patch.object(bump, "api", return_value=release("nightly")):
            with self.assertRaisesRegex(ValueError, "stable"):
                bump.resolve("dutchman")

    def test_pilot_semver_and_pagination(self):
        missing = HTTPError("url", 404, "missing", {}, None)
        first = [release("nightly")] * 99 + [release("v0.1.0-beta.2")]
        last = [release("v0.1.0-beta.10"), release("v0.1.0-alpha.99")]
        with patch.object(bump, "api", side_effect=[missing, first, last]):
            self.assertEqual(bump.resolve("pilot")["tag_name"], "v0.1.0-beta.10")

    def test_pilot_prefers_stable(self):
        expected = release("v0.1.0", False)
        with patch.object(bump, "api", return_value=expected) as api:
            self.assertEqual(bump.resolve("pilot"), expected)
            self.assertEqual(api.call_count, 1)

    def test_missing_asset_fails_clearly(self):
        with patch.object(bump, "resolve", return_value=release("v1.0.0", assets=[])):
            with self.assertRaisesRegex(ValueError, "missing expected assets: pilot-1.0.0-aarch64-macos"):
                bump.update("dutchman-pilot", *bump.TARGETS["dutchman-pilot"])

    def test_digest_is_computed_and_sidecar_verified(self):
        content = b"archive contents"
        sha = hashlib.sha256(content).hexdigest()
        asset = dict(name="test.tar.gz", browser_download_url="https://example.org/archive", size=len(content))
        sidecar = dict(browser_download_url="https://example.org/sha")
        with patch.object(bump, "request", side_effect=[io.BytesIO(content), io.BytesIO(f"{sha}  test.tar.gz\n".encode())]):
            self.assertEqual(bump.checksum(asset, sidecar), sha)
        with patch.object(bump, "request", side_effect=[io.BytesIO(content), io.BytesIO(b"0" * 64)]):
            with self.assertRaisesRegex(ValueError, "does not match"):
                bump.checksum(asset, sidecar)
        with patch.object(bump, "request", return_value=io.BytesIO(content)):
            self.assertEqual(bump.checksum(asset, None), sha)

    def test_truncated_download_rejected(self):
        asset = dict(name="test.tar.gz", browser_download_url="https://example.org/archive", size=99)
        with patch.object(bump, "request", return_value=io.BytesIO(b"short")):
            with self.assertRaisesRegex(ValueError, "expected 99 bytes"):
                bump.checksum(asset, None)

    def test_rewrite_preserves_format_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Formula").mkdir()
            name = "dutchman-pilot"
            path = root / "Formula" / f"{name}.rb"
            original = (bump.ROOT / "Formula" / f"{name}.rb").read_text()
            path.write_text(original)
            repo, targets = bump.TARGETS[name]
            assets = [dict(name=f"pilot-1.2.3-beta.10-{t}.tar.gz",
                           browser_download_url=f"https://github.com/dutchman-cad/pilot/releases/download/v1.2.3-beta.10/pilot-1.2.3-beta.10-{t}.tar.gz") for t in targets]
            selected = release("v1.2.3-beta.10", assets=assets)
            with patch.object(bump, "ROOT", root), patch.object(bump, "resolve", return_value=selected), patch.object(bump, "checksum", return_value="a" * 64), contextlib.redirect_stdout(io.StringIO()):
                _, _, updated, version = bump.update(name, repo, targets)
                self.assertEqual(version, "1.2.3-beta.10")
                self.assertEqual(updated.count('sha256 "' + 'a' * 64), 3)
                self.assertEqual(updated[updated.index("  def install"):], original[original.index("  def install"):])
                self.assertEqual(path.read_text(), original)  # Planning never writes.
                path.write_text(updated)
                self.assertEqual(bump.update(name, repo, targets)[2], updated)
                path.write_text(updated.replace('      sha256 "', '      # sha256 "', 1))
                with self.assertRaisesRegex(ValueError, "exactly one"):
                    bump.update(name, repo, targets)

    def test_check_and_no_partial_updates(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "formula.rb"
            original = '  url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0/pilot-0.1.0-x86_64-linux.tar.gz"\n'
            updated = '  url "https://github.com/dutchman-cad/pilot/releases/download/v0.2.0/pilot-0.2.0-x86_64-linux.tar.gz"\n'
            path.write_text(original)
            plan = (path, original, updated, "0.2.0")
            with patch.object(bump, "update", return_value=plan), patch("sys.argv", ["bump.py", "--check"]), contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(bump.main(), 0)
                self.assertEqual(path.read_text(), original)
            with patch.object(bump, "update", side_effect=[plan, ValueError("bad checksum")]), patch("sys.argv", ["bump.py"]):
                with self.assertRaisesRegex(ValueError, "bad checksum"):
                    bump.main()
                self.assertEqual(path.read_text(), original)


if __name__ == "__main__":
    unittest.main()
