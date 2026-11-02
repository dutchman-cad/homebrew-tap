class Dutchman < Formula
  desc "Converts native CAD designs into SolidCraft designs"
  homepage "https://github.com/dutchman-cad/dutchman"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-0.2.6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7fe37f05c6ff12c005e84935e00dcff7f97c0931c8a50697874f7787e5c7401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7fe37f05c6ff12c005e84935e00dcff7f97c0931c8a50697874f7787e5c7401"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce379a30f9566e742e03ed928d93cf7d0f8c1a039ea556382d7159c5d99a2da"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ce379a30f9566e742e03ed928d93cf7d0f8c1a039ea556382d7159c5d99a2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637d7c59574ed87cbdcc15985074ab9e9858312d614bd9d4fff4782f43ddce4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3ef02f5c9e9b6c9183f9ed1ef250515e96147f129f4f1f195a825ef79f0652"
  end

  on_macos do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.6/dutchman-0.2.6-aarch64-apple-darwin.tar.gz"
      sha256 "e9518b95a4157295f5408eba4897dd720c3b83d12efd6196b8efa0d16871e4a1"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.6/dutchman-0.2.6-x86_64-apple-darwin.tar.gz"
      sha256 "4782fe5b815df872614ad14e198392933c5548c45de3db804aca019ed93f60e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.6/dutchman-0.2.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d32fb7d47274e00fbba717ede1f5f313df75028b61f4ae99d3e35d7ad4d6523"
    end

    on_intel do
      url "https://github.com/dutchman-cad/dutchman/releases/download/v0.2.6/dutchman-0.2.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "552f342eea75c2bf240f8fa109784ab52e699fd298b8120ad0f6d9126c142a8a"
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
