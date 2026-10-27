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
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-pilot-0.1.0-beta.6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc8c2c6293ee4579cb47b56952b0f0f734dd3b9e38ffa291aabe32b90dd69cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "acc8c2c6293ee4579cb47b56952b0f0f734dd3b9e38ffa291aabe32b90dd69cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8da8e054a8797c720b5bfdb21415d7c3271c5dc8cbba61b483d19062a4f61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3aaa35a238ecfb557f9ee617ec95ec6fb50598ff6c13274dbfb4143dd35396e"
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.6/pilot-0.1.0-beta.6-aarch64-macos.tar.gz"
      sha256 "a714d00a2558de2a0ac94fd16959211e5e1050b9fffdccf59c94661d59202ae4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.6/pilot-0.1.0-beta.6-aarch64-linux.tar.gz"
      sha256 "4dfa1a50407e7c6427a55a247664a932b20c048bce0d8f95de3e77141050e98e"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.6/pilot-0.1.0-beta.6-x86_64-linux.tar.gz"
      sha256 "9a33b0a9cb5e7fa2e954f7d6138d468e6f418f882c36cdab71f189b702774508"
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
