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
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-pilot-0.1.0-beta.7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0a0be4dd0631952003296368a23ab379483a399ca0d814c326ac626d13b6fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a0a0be4dd0631952003296368a23ab379483a399ca0d814c326ac626d13b6fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e3ed9c8de3326472f67b642ff9bc3e439763783ab11e6a9e2ddc12eaf96ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4cfdaefc155d29a17d2c86827a1ee1b7974ace0499d8cbacd3497df2231599"
  end

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.7/pilot-0.1.0-beta.7-aarch64-macos.tar.gz"
      sha256 "57cda5cce2d3b4ab03475a211d0fdba06ed2b638c61e306b7dffb52c64ab09b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.7/pilot-0.1.0-beta.7-aarch64-linux.tar.gz"
      sha256 "1cfa7cf88e94f78f64101f26523674aa21353bd3870432a6b51c3c9e0871cd09"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.7/pilot-0.1.0-beta.7-x86_64-linux.tar.gz"
      sha256 "42cb272e48ce80667d36458e57a7ab765e41a5bf5934716d12b097763f346dce"
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
