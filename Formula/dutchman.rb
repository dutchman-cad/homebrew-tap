class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595a7de1f009a6d5708ba4ef1d749a977135ee04a057e335ce7b8f32d9ef97ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "595a7de1f009a6d5708ba4ef1d749a977135ee04a057e335ce7b8f32d9ef97ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c897da3dccd736fdae47e7f01c10ed014c1162834b8f8b9573eac838de51d2b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "c897da3dccd736fdae47e7f01c10ed014c1162834b8f8b9573eac838de51d2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40241b1084fde4eb8835dbda782bda603f9f25a956cd9b2a8efcca01bb70bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a5daa7a83e3977b1356e3cf2fd438a9424326af52f49a07100f797c61b2daea"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.5/dutchman-0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "47164d136e912dfe05e49f5a21e6c087b89ef233b96cf80e295a6c976b555a34"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.5/dutchman-0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "0ad3369e45dd9d54efbb58f177a93a2286a0a9a3830a8e7d5cc48815e28ddc91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.5/dutchman-0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "22c51645421bca1ba3b72b86bddc5c88e78b54945986a123190adb77381efe7b"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.5/dutchman-0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c0dc2964c2a5dee9743f436f9174b89bee82d287a90c2d755f46fd0d544455d"
    end
  end

  def install
    bin.install "dutchman", "dutchman-mcp", "dutchman-gui"
    prefix.install "LICENSE", "NOTICE", "README.md", "licences"
  end

  def caveats
    on_macos do
      <<~EOS
        This adds the commands. For the Dutchman Convert app in Applications and Launchpad:
          brew install --cask dutchman-cad/tap/dutchman-convert
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dutchman --version")
  end
end
