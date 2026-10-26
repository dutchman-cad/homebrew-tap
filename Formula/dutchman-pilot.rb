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
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.5/pilot-0.1.0-beta.5-aarch64-macos.tar.gz"
      sha256 "5d6e6dbebf6e21116b792c8f7f3901807fbc0dc225fc3afea75816373609b0d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.5/pilot-0.1.0-beta.5-aarch64-linux.tar.gz"
      sha256 "82824dddb7080732b33898f500cf39d41e1ba103e28d67cca6b85beea03d7a7b"
    end

    on_intel do
      url "https://github.com/dutchman-cad/pilot/releases/download/v0.1.0-beta.5/pilot-0.1.0-beta.5-x86_64-linux.tar.gz"
      sha256 "c1d87c26046fb9b2c5fa87688364bb0cb20adc1c8bf3a8370b4efbf277b40d3e"
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
