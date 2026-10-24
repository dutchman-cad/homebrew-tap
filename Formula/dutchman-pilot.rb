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

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.4/pilot-0.1.0-beta.4-aarch64-macos.tar.gz"
      sha256 "fed21151c314f417d00d45e1c44e4809694c1033f26ebb3885f811fedc131140"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.4/pilot-0.1.0-beta.4-aarch64-linux.tar.gz"
      sha256 "a1164b8690d8f377ed232d57331913b703ec78072616d2b76ba58349719a0688"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.4/pilot-0.1.0-beta.4-x86_64-linux.tar.gz"
      sha256 "d9d824a44a53b4e0ba20e2a6ffd5d8e78104e9f46b2dc38df04f26903cfa00cc"
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
