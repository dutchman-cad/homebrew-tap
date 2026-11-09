cask "dutchman-convert" do
  version "0.2.8"
  sha256 "e56b1eab68433a399b160aa9797979cb428000672d9053ecc954ebabff9c29ff"

  url "https://github.com/dutchman-cad/dutchman/releases/download/v#{version}/dutchman-#{version}-macos-universal.dmg"
  name "Dutchman Convert"
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "Dutchman Convert.app"

  caveats <<~EOS
    Dutchman Convert is not signed with an Apple Developer ID. The first time you open it,
    click Done in the box macOS shows, then open System Settings > Privacy & Security and
    click Open Anyway. Or clear the quarantine flag once:
      xattr -dr com.apple.quarantine "#{appdir}/Dutchman Convert.app"
  EOS
end
