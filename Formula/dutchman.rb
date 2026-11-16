class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18946dd647e4a43d7226eb26025e21550239dadc7e75060f547a8c954f1f4415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18946dd647e4a43d7226eb26025e21550239dadc7e75060f547a8c954f1f4415"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee343d78b448441776397bc3a8a7229fea16424f66b89d0a525c82fb94ddb1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ee343d78b448441776397bc3a8a7229fea16424f66b89d0a525c82fb94ddb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ce603c7a90219427a517322348f32b8cc320f6d1a916abf462f898587eb6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203dd056fea353668cf238633019912b9cc6c24b0552f4af9fe5b79d025ab21d"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.10/dutchman-0.2.10-aarch64-apple-darwin.tar.gz"
      sha256 "756c790de523b65eea34aad1317b2ed1778e80ea6cf09c26730c87c2c35f0be2"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.10/dutchman-0.2.10-x86_64-apple-darwin.tar.gz"
      sha256 "5b88e28bca89d9eae5a8e2298b9a849d3988e6815befe35cad3c12ce086e271a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.10/dutchman-0.2.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "85bf7ccad419cc4c9a6b10b5576449ce0fb61101be956094c84a8e8814386ca6"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.10/dutchman-0.2.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2278585c8f1ae12b3c35088f60aa715213d44ecb737871c8c03b1ab4e613524"
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
