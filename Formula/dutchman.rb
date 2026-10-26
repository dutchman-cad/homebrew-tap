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
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "558c88dab5b0b4087781964fb12b184a9ace76415f0e412e1db68a6c3680fe00"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "83ca2402b76129ff7f6cec221bd96dc44eb4b027509da7f0b46047c35ce953a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a26d16dcc601c70d0b810853d8a8b06574253e72dd637f0328ae9ec18e50c30"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.1/dutchman-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4f0f5453ae58fd508109086c12f05d3035341dc83e6f1dd99f02cc7f65ef89bf"
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
