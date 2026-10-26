#!/usr/bin/env bash
# Audit, install and test both formulas. A formula with bottles must pour one. A formula without
# bottles is bottled here, then poured from a local copy of the bottle and tested.
# With --keep-bottles DIR, the bottles built here are copied into DIR for publishing.
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

keep=""
if [[ "${1:-}" == --keep-bottles ]]; then
  keep="$(mkdir -p "$2" && cd "$2" && pwd)"
fi

tap_dir="$(brew --repository dutchman-cad/tap)"
# In CI the checkout may already be the tap; elsewhere tap it here.
if [[ ! -d "$tap_dir" ]]; then
  brew tap dutchman-cad/tap "$PWD"
fi
# Homebrew 7 and later load formulas from other taps only once the tap is trusted.
if brew trust --help >/dev/null 2>&1; then
  brew trust --tap dutchman-cad/tap
fi
work="$(mktemp -d)"
mkdir -p "$work/candidates" "$work/built" "$work/assets"
cp Formula/*.rb "$work/candidates/"
# Local bottle blocks are written into the tap; put the candidate formulas back on exit.
trap 'cp "$work/candidates/"*.rb "$tap_dir/Formula/"; rm -rf "$work"' EXIT
cp "$work/candidates/"*.rb "$tap_dir/Formula/"

poured() {
  brew info --json=v2 "$1" | python3 -c '
import json, sys
installed = json.load(sys.stdin)["formulae"][0]["installed"]
sys.exit(0 if installed and installed[0]["poured_from_bottle"] else 1)'
}

for formula in dutchman dutchman-pilot; do
  full="dutchman-cad/tap/$formula"
  if [[ "$formula" == dutchman-pilot && "$(uname -s)" == Darwin && "$(uname -m)" == x86_64 ]]; then
    echo 'Skipping Pilot: Intel macOS is unsupported.'
    continue
  fi
  brew audit --strict --online --formula "$full"
  if brew list --formula "$full" >/dev/null 2>&1; then
    brew uninstall --formula "$full"
  fi
  if ! grep -q '^  bottle do$' "$work/candidates/$formula.rb"; then
    brew install --formula --build-bottle "$full"
    brew test "$full"
    (cd "$work/built" && brew bottle --json --no-rebuild --root-url=https://example.invalid "$full")
    brew uninstall --formula "$full"
    python3 scripts/bottle.py write "$work/built" "$work/assets" --partial \
      --formula-dir "$tap_dir/Formula" --root-url "file://$work/assets/{name}-{version}"
  fi
  brew install --formula "$full"
  if ! poured "$full"; then
    echo "$formula was not poured from a bottle." >&2
    exit 1
  fi
  brew test "$full"
done

if [[ -n "$keep" ]]; then
  shopt -s nullglob
  built=("$work/built/"*.bottle.json "$work/built/"*.bottle.tar.gz)
  if (( ${#built[@]} )); then
    cp "${built[@]}" "$keep/"
  fi
fi
