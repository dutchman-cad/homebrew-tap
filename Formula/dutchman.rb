class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4f8a21f6ae5dbafacc3db2d8f99516a46f51c9d659ff012ebe3899df535bf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee4f8a21f6ae5dbafacc3db2d8f99516a46f51c9d659ff012ebe3899df535bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6909a0c936c96570be55205362833db9008ca43b1cafa0851b16bf69f1746c9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6909a0c936c96570be55205362833db9008ca43b1cafa0851b16bf69f1746c9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97760b723dea1149e52e0cf15778d5d529b04863297f8635de06e3e31661d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c02cc25decf75392a6af6092a8294ead6fdae3dfdb3d4aba43f0962632bd8d"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.3/dutchman-0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "dfba7b7b2ad483d182e39881c597bf870a9e0801524d165f4f462ab6603b523c"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.3/dutchman-0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "34ab3f9d3ac697cf89b89f4161fd8b65b1ba46e6ee3d04c6621db319e31c5774"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.3/dutchman-0.2.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5421ee4cba6be091f97165ab31bf8425f8d40587d780dbf711bb76df8f37ac50"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.3/dutchman-0.2.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2cfcbab8817f6c10912c483ec110d6cbba5a923eaadb1d7570d62fd2bef0c0bd"
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
