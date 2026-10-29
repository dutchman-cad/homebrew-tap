class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62f9b9bd8bc0e61a71e5beb35d257514bc9bee1cfea5ba7590e5efbbd3aad89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c62f9b9bd8bc0e61a71e5beb35d257514bc9bee1cfea5ba7590e5efbbd3aad89"
    sha256 cellar: :any_skip_relocation, sonoma:        "801863f361b07481cd5ba7a46b67e460a93d5403e84b81b83ad65a3c990bd667"
    sha256 cellar: :any_skip_relocation, big_sur:       "801863f361b07481cd5ba7a46b67e460a93d5403e84b81b83ad65a3c990bd667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d7775daacd7d7ba823b6c9528fbafcc0f232c8f90136f2c113aa86ca066f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e50bbf5a700d0b3389d1e1c6d76027224682b739a53eaddd61432a529dc1e4"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.4/dutchman-0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "93e571cf0c6b3a2116ba78bde741ad777a31c21ec6f9a4bbaea207dbbc04f412"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.4/dutchman-0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "35ad645240b91913fe35ad29797b2d5de8aed5b9265e8665f26c3140cdfb78be"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.4/dutchman-0.2.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9a30fbc0fa67d1cb1220b112e82a1bda9ea03fd5a67ce2ff7f5fbd5a01256fe"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.4/dutchman-0.2.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "febfcb64d0a71b66c295de200d4870652ce242c02a55222e54e81ab67dbdeb8c"
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
