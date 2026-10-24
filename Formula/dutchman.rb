class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.4/dutchman-0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "b944810512ec43fbce2ded3b136602b47f866b70a5faaa117905b2b60545d5a6"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.4/dutchman-0.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "f0528d0e97587b1dce3d8a85c4d48898e01a796b4204a7d75730f4a07b63be01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.4/dutchman-0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d488893558a4d35c75232488197db76d8122edc53812fe6d286541a143f44c9c"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.4/dutchman-0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a842952bc2f30770f6075f86504fa95556bf2a0fe3c0116e5483c96148c8eda"
    end
  end

  def install
    bin.install "dutchman", "dutchman-mcp", "dutchman-gui"
    prefix.install "LICENSE", "NOTICE", "README.md", "licences"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dutchman --version")
  end
end
