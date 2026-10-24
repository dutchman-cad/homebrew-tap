class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  version "0.1.5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.5/dutchman-0.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "95abaae1ed811c6ce670cbcabdb05199bbd708061516eb0547974ccc8f2a9b6b"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.5/dutchman-0.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "41b8a9898af93ad287a58b27bd0a8c506c752856b5c453230712eec99ee8b07f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.5/dutchman-0.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "164c6c2bef76de8db12c3c687f86ea1ae6f9449d0610d18378b50736b9845111"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.1.5/dutchman-0.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "42c04ae05b608d1ebd103cde05e0627fda84a4bcfafc87b9ae38230628dd4b6c"
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
