class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516ae2037c8d53fc3b4c740e82eaafa5614d4dc3995320c43e42c8a1303c42d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "516ae2037c8d53fc3b4c740e82eaafa5614d4dc3995320c43e42c8a1303c42d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a56d13c53c99d307b93e802b8245f76f2e90455f55e8cd79a6bdce5a5d2373"
    sha256 cellar: :any_skip_relocation, big_sur:       "84a56d13c53c99d307b93e802b8245f76f2e90455f55e8cd79a6bdce5a5d2373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ed60eed4bc2e3f044aaf11ef04a1b5435a595e146072920d0095208515a6284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdad64d505e0e84514c334a69fdaf95bbb7b151014bc3f96852d2e46b7069362"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "558c88dab5b0b4087781964fb12b184a9ace76415f0e412e1db68a6c3680fe00"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "83ca2402b76129ff7f6cec221bd96dc44eb4b027509da7f0b46047c35ce953a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a26d16dcc601c70d0b810853d8a8b06574253e72dd637f0328ae9ec18e50c30"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4f0f5453ae58fd508109086c12f05d3035341dc83e6f1dd99f02cc7f65ef89bf"
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
