class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb21f362edc1801855b4d7941563aec6fcf1ee8b4c3e4af7ccc364452add391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bb21f362edc1801855b4d7941563aec6fcf1ee8b4c3e4af7ccc364452add391"
    sha256 cellar: :any_skip_relocation, sonoma:        "c498c6477ed48828d1de125a03cb8115d4c41dcf5b865eb45361382c82d27ea7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c498c6477ed48828d1de125a03cb8115d4c41dcf5b865eb45361382c82d27ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c5b16f0861c0a6cb7b419dcbaf5eeeb163e1ba3c0187316b24f008b0c1508f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929220f16da620581ea1babf3ef7de0d5f85663649c77194239409b62a3f0f40"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.2/dutchman-0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "5b1f9dee817be8a1c69c8341c9de338a07e7f96c172f96ebf2954e86daf5e842"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.2/dutchman-0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "2f5c6f81dec060722bc4e3f7696cac4436eecad9734c462120e27fb928c09f24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.2/dutchman-0.2.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d5bee2aabdeb8d4099573bef2e53061f01d44292e65a871f42ab26ceb3c3fcf"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.2/dutchman-0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1d0a1dcf2afa14f17f19377ba7c9e6e8d5a0c60b01ce42a452a88e8f4f4ee4ae"
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
