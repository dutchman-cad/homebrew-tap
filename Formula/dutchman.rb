class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a8ca89b0148332a8a6550994f2f5d900d533ac05a7c77e539ea999ca44d3c8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a8ca89b0148332a8a6550994f2f5d900d533ac05a7c77e539ea999ca44d3c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d50b4f8dcaae83f6efa256f93e4b317fd814cab58eee3f126dbfbbb8000bfbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d50b4f8dcaae83f6efa256f93e4b317fd814cab58eee3f126dbfbbb8000bfbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0257da88de59396b0111fb5fcd0b721a66ff9b7b9665aac73d8f96919cd1dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba48f4425fcd32035ecfc7ec4ea52e6337f44812cd0f33465e22fa65e7a737cd"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.8/dutchman-0.2.8-aarch64-apple-darwin.tar.gz"
      sha256 "9648df0aaa2f1296c3dee49f3bc35fcab580795bfb2e0e61c046e59955f7fce4"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.8/dutchman-0.2.8-x86_64-apple-darwin.tar.gz"
      sha256 "b33a5f7f79a6e22272987ea12aa6404ae1bd17733ac40b661e57ddb37c89a0f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.8/dutchman-0.2.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "866dac5f295ba9e1bcca51c4d7a3c2e10a8460dfb66cd1872f76e4bc53cbdf6f"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.8/dutchman-0.2.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dad446b6f06c06761e29366ed00a98692018cb64cc2440e8284f3855c615cb37"
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
