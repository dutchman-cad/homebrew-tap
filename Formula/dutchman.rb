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
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.0/dutchman-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "d6dc7e35ddc962ab9d6fccb8ca01b12a8623ba8ba84fdd3791b4c063f9beb6f2"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.0/dutchman-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "9f9a8a2176d80a5813520f109407294bd5aadfd55bff559996d4b871532750ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.0/dutchman-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1439797ae498736ded156b8cb611b7bedaf9254d8a5de51c67bcfe5fa578b143"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.0/dutchman-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d90ef2880927e9cdb5ab39af4c5c18d76fdaf5ab33406069074df60710acf95"
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
