class Snap < Formula
  desc "MCP stdio proxy that compresses Playwright accessibility snapshots"
  homepage "https://github.com/mark-liu/snap"
  license "MIT"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/snap/releases/download/v0.1.0/snap_darwin_arm64.tar.gz"
      sha256 "a190eef87171563273d5bfb213e1e6cd94fcc49cfcf25785d4e62ea91cdf9160"
    else
      url "https://github.com/mark-liu/snap/releases/download/v0.1.0/snap_darwin_amd64.tar.gz"
      sha256 "6b4ff251c9890e0c885eee59173a15e3f90ff47dbeff5890bdf63356d55f5606"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/snap/releases/download/v0.1.0/snap_linux_arm64.tar.gz"
      sha256 "bcc592acedc9aaf6200dcf47bc31c55824aebe66e2feeb82d4dfa71b71e27404"
    else
      url "https://github.com/mark-liu/snap/releases/download/v0.1.0/snap_linux_amd64.tar.gz"
      sha256 "cf8f3f08b3f630bbb6ecac35ee6ff919deda6352c11e8e9d2da23682b993a5dd"
    end
  end

  def install
    bin.install "snap"
  end

  test do
    assert_match "snap", shell_output("#{bin}/snap --version 2>&1")
  end
end
