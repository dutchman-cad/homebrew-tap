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
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.1/pilot-0.1.0-beta.1-aarch64-macos.tar.gz"
      sha256 "b7a601effb33fd7eac4c87a7463974814cf6e1da6572af7532245d9d733a035a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.1/pilot-0.1.0-beta.1-aarch64-linux.tar.gz"
      sha256 "8c48ec4d83ce1320ea981b6e95cb220e1c57a6f7aa706ff88938a8407eb2d1ff"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.1/pilot-0.1.0-beta.1-x86_64-linux.tar.gz"
      sha256 "dc19a53955e9a1683b43aae078ed42216996493229fe2288cdb3706ab5573d1d"
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
