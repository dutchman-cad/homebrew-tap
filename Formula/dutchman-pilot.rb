class DutchmanPilot < Formula
  desc "Drives SolidCraft from plain-language requests"
  homepage "https://github.com/dutchman-cad/pilot"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?)$/i)
    strategy :github_releases do |json, regex|
      releases = json.reject { |release| release["draft"] || release["tag_name"] == "nightly" }
      stable = releases.reject { |release| release["prerelease"] }
      releases = stable unless stable.empty?
      releases.filter_map { |release| release["tag_name"]&.[](regex, 1) }
    end
  end

  bottle do
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-pilot-0.1.0-beta.8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a5c1bfeff6dd158f0ca064b25c61dc4e7cd7af20a6bf93f4be5a95a2506406"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20a5c1bfeff6dd158f0ca064b25c61dc4e7cd7af20a6bf93f4be5a95a2506406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7415f561a9ccbe6805e5af348eaef19a14e108863224874b9b7a89ac675e0d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b3485ea52f149d58b5c39d14bf8ee6764f3db537cae094cec5673a59f31f78"
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.8/pilot-0.1.0-beta.8-aarch64-macos.tar.gz"
      sha256 "d2609fdc5a748751b5e83391d7de6a5ebbc3b46c5e7fb7bfc5d97cf6ed48e3e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.8/pilot-0.1.0-beta.8-aarch64-linux.tar.gz"
      sha256 "6a55b712406f532603f9bf36767ef2fc8b184850599c9b02bf9b95a2256cae05"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.8/pilot-0.1.0-beta.8-x86_64-linux.tar.gz"
      sha256 "25415eafa03b7351b285335f391fb5df705726886b6286cbb9a74335783232b1"
    end
  end

  def install
    bin.install "dutchman-pilot", "dutchman-pilot-eval"
    prefix.install "LICENSE", "NOTICE"
  end

  def caveats
    <<~EOS
      On macOS, Pilot is built for Apple silicon only.
      `brew install dutchman-cad/tap/dutchman` adds the `dutchman` command, with `dutchman pilot`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dutchman-pilot --version")
  end
end
