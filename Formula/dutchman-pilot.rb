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
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-pilot-0.1.0-beta.9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6054fb1cebf3c10f2179c30aec47a0a502d0107bf75ef69a4c24881ad7f7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a6054fb1cebf3c10f2179c30aec47a0a502d0107bf75ef69a4c24881ad7f7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64fd90b107ba70672bc6e34b48052617901beedd06f18d58a6f58ac61bd34359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf4a58e143ef3daca605357dd4db769e350812dab21c29b46f0c327c6061bae"
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.9/pilot-0.1.0-beta.9-aarch64-macos.tar.gz"
      sha256 "d9b1c57c7932aeb0af67eba9fc62f397c9fd09ede98973ebb40a05671d9f757b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.9/pilot-0.1.0-beta.9-aarch64-linux.tar.gz"
      sha256 "121852bca354000d950a5c5094f4601f3265b1f3085266054243616ca0e0436a"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.9/pilot-0.1.0-beta.9-x86_64-linux.tar.gz"
      sha256 "c62cf428a9ea2afa8761be5555f7528272e1e594bfe1452ee903fe6d2aa34b4b"
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
