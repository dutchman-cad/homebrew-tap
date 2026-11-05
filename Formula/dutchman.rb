class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1e6eaef8fbd21f63c306a08151e1f16de8edd0a228af6a0dd311a7d147fc06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db1e6eaef8fbd21f63c306a08151e1f16de8edd0a228af6a0dd311a7d147fc06"
    sha256 cellar: :any_skip_relocation, sonoma:        "561cd22616ba6c22d70f0fef67505172cba2e5bef6630d26c6aa84a6ef3860fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "561cd22616ba6c22d70f0fef67505172cba2e5bef6630d26c6aa84a6ef3860fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9de84fb781d8ce94d10e1b4da9c3ccc1678619702e88958487d047b21f3a75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61bc13f09dac3c632939e81da039e108bb90cc9e0f8e93199a7f8f545ddbdda"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.7/dutchman-0.2.7-aarch64-apple-darwin.tar.gz"
      sha256 "17658dd7fc6b34823f0bad603c6e7959748a5844f3756b85ab585a1b17f11556"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.7/dutchman-0.2.7-x86_64-apple-darwin.tar.gz"
      sha256 "940eabc2e94bbf34426f72879e09368787722f680b83e01d5ec3dc04e40ad8a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.7/dutchman-0.2.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2b7b002fdf54f7319aac975bdf3051f0389aabace33e009c4c1aeb9a7623b58"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.7/dutchman-0.2.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd199ffdf266945e3064b45fe11ef538a805871306436c81a39c93dc0430050a"
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
