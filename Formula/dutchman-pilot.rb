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
    root_url "https://github.com/dutchman-cad/homebrew-tap/releases/download/dutchman-pilot-0.1.0-beta.5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f825ee8a6829bd869e5c9849ad2328e8ecbcf428e11772c5ef815a83e7abe8e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f825ee8a6829bd869e5c9849ad2328e8ecbcf428e11772c5ef815a83e7abe8e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b31cdfd8ce923b17548105e52fd4e1b9ef452bd9762db391dbb4d6005434ae11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860f60733189d65ee936cfcb66ebd7a8db67cdd080f188a7cfb0b65819da985a"
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
