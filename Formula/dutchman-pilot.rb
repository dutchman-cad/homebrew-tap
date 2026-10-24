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
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.3/pilot-0.1.0-beta.3-aarch64-macos.tar.gz"
      sha256 "fb6ee595091c45b0234f8cb0509131926b756e6ceaf6e5dd4ca553b25883d732"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.3/pilot-0.1.0-beta.3-aarch64-linux.tar.gz"
      sha256 "9549cad8bdb117802b9497f34c462f0bf5b84396230e6edd0ed318cbcc61f97a"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.3/pilot-0.1.0-beta.3-x86_64-linux.tar.gz"
      sha256 "202bcf45d5a52bcae62da75f842f28c266c4b2c3c7c8dd0783bbe5aa1abec8e6"
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
