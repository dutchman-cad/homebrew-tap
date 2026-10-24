#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

brew tap dutchman-cad/tap "$PWD"
# Tapping clones committed files; copy the candidate formulas after tapping.
cp Formula/*.rb "$(brew --repository dutchman-cad/tap)/Formula/"
for formula in dutchman dutchman-pilot; do
  brew audit --strict --online --formula "dutchman-cad/tap/$formula"
  if [[ "$formula" == dutchman-pilot && "$(uname -s)" == Darwin && "$(uname -m)" == x86_64 ]]; then
    echo 'Skipping Pilot install/test: Intel macOS is unsupported.'
    continue
  fi
  brew install --formula "dutchman-cad/tap/$formula"
  brew test "dutchman-cad/tap/$formula"
done
