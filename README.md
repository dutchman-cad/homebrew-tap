# Dutchman Homebrew tap

[![Discord](https://img.shields.io/badge/Discord-Dutchman%20CAD-5865F2?logo=discord&logoColor=white)](https://discord.gg/yTcseBEdeu)

Homebrew packages for Dutchman Convert and Pilot on macOS and Linux.

```sh
brew install dutchman-cad/tap/dutchman
```

The `dutchman` command runs Dutchman Convert, including the built-in
`dutchman pilot`. The package also includes `dutchman-mcp` and `dutchman-gui`.

For Pilot alone:

```sh
brew install dutchman-cad/tap/dutchman-pilot
```

Run it as `dutchman-pilot`; the package also includes `dutchman-pilot-eval`.
Pilot supports Apple Silicon macOS and ARM64/x86-64 Linux. Convert also
supports Intel macOS.

On macOS, a Homebrew install needs no first-run Gatekeeper step: Homebrew
downloads do not carry the quarantine flag.

The formulas follow releases automatically within about an hour, after checks
pass. Convert follows stable releases. Pilot follows prereleases until its first
stable release, then follows stable releases. Update installed packages with:

```sh
brew update
brew upgrade
```

## Help

Install problems or questions: the help forums on the [Dutchman CAD Discord](https://discord.gg/yTcseBEdeu), or an issue in this repository.
