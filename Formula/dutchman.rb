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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67c8b4f41da32b18ea0384bbfffdb03bd46403659dac5f87b3b1615a2ec44af1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67c8b4f41da32b18ea0384bbfffdb03bd46403659dac5f87b3b1615a2ec44af1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d12afd76780b2cfd8f49e75cb9446fa827515acaeab175b5a5a0ec97b5d3ec8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d12afd76780b2cfd8f49e75cb9446fa827515acaeab175b5a5a0ec97b5d3ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef899d46180b53711f60f295d1773b3742e09ddb9baae5a4ba52ba3fcfeec0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce6490913a93ab5adf0471e9c397fd7ff25de0b7df7f791a9542a5bb34027d6"
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
