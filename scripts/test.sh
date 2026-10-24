#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

tap_dir="$(brew --repository dutchman-cad/tap)"
# In CI the checkout may already be the tap; elsewhere tap it here.
if [[ ! -d "$tap_dir" ]]; then
  brew tap dutchman-cad/tap "$PWD"
fi
# Tapping clones committed files; copy the candidate formulas unless the tap is this checkout.
if [[ ! "$tap_dir/Formula" -ef Formula ]]; then
  cp Formula/*.rb "$tap_dir/Formula/"
fi
for formula in dutchman dutchman-pilot; do
  brew audit --strict --online --formula "dutchman-cad/tap/$formula"
  if [[ "$formula" == dutchman-pilot && "$(uname -s)" == Darwin && "$(uname -m)" == x86_64 ]]; then
    echo 'Skipping Pilot install/test: Intel macOS is unsupported.'
    continue
  fi
  brew install --formula "dutchman-cad/tap/$formula"
  brew test "dutchman-cad/tap/$formula"
done
