class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60975e5135367170a388fce4e71bbecf884083719fe65f38f694862032c5a2e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60975e5135367170a388fce4e71bbecf884083719fe65f38f694862032c5a2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5328d8d6018a32b97c40734da342542ec607dc5be99a87c777d7428eaa7fc843"
    sha256 cellar: :any_skip_relocation, big_sur:       "5328d8d6018a32b97c40734da342542ec607dc5be99a87c777d7428eaa7fc843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a0a6d3ecf373ef859639b4228460714d957db365ffcbadfff677eccf946d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e42deae12cbf286be26991aeb334d382f9597bcb89bc976841a44047001c77"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.9/dutchman-0.2.9-aarch64-apple-darwin.tar.gz"
      sha256 "c7014f29ab3a030bd90931038d7e97f3db73a70bcd9382e228cb25fdee47a4dc"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.9/dutchman-0.2.9-x86_64-apple-darwin.tar.gz"
      sha256 "ed443609bead09d25abe534fc3da46c29eb3c2f7384a6b4399ea05e433e44c4a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.9/dutchman-0.2.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7a66f2214f9bc069af5d6d2a17e4ab206ae6c789eb747a1305e5c63a46793bc5"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.9/dutchman-0.2.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "56f34583c3a966067e816bf25fff559b77add5f56a1bf25a0d8bd0e2d7dd1b2f"
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
