# Dutchman Homebrew tap

[![Discord](https://img.shields.io/badge/Discord-Dutchman%20CAD-5865F2?logo=discord&logoColor=white)](https://discord.gg/yTcseBEdeu)

Homebrew packages for Dutchman Convert and Pilot on macOS and Linux.

```sh
brew install dutchman-cad/tap/dutchman
```

The `dutchman` command runs Dutchman Convert, including the built-in
`dutchman pilot`. The package also includes `dutchman-mcp` and `dutchman-gui`.

On macOS, the Dutchman Convert app, in Applications and Launchpad:

```sh
brew install --cask dutchman-cad/tap/dutchman-convert
```

The app is not signed with an Apple Developer ID, and Homebrew quarantines apps
it installs, so the first time you open it macOS stops it. Click **Done**, then
open **System Settings** › **Privacy & Security** and click **Open Anyway**, as
for the [disk image](https://github.com/dutchman-cad/dutchman/blob/main/docs/guide.md#opening-the-app-the-first-time).
Or clear the quarantine flag once:

```sh
xattr -dr com.apple.quarantine "/Applications/Dutchman Convert.app"
```

For Pilot alone:

```sh
brew install dutchman-cad/tap/dutchman-pilot
```

Run it as `dutchman-pilot`; the package also includes `dutchman-pilot-eval`.
Pilot supports Apple Silicon macOS and ARM64/x86-64 Linux. Convert also
supports Intel macOS.

Homebrew pours a ready-made bottle, so an install needs no Xcode or Command
Line Tools. On macOS the commands also need no first-run Gatekeeper step:
Homebrew's formula downloads do not carry the quarantine flag.

The formulas, their bottles and the app follow releases automatically within
about an hour, after checks pass on macOS and Linux. Convert follows stable
releases. Pilot follows prereleases until its first stable release, then follows
stable releases. Update installed packages with:

```sh
brew update
brew upgrade
```

## Help

Install problems or questions: the help forums on the [Dutchman CAD Discord](https://discord.gg/yTcseBEdeu), or an issue in this repository.
