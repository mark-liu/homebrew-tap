class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.7/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "c61479694fb1f3f4d44fa216380b6835a65a962000f35ea8b70db9cb0b7fb977"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.7/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "6ee108139b946066dd02fed2b86b94c180ce1679b1f5f043fc46f38418b6987b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.7/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03a7dd911796025a58e0f78d2838d216c9f68052f4c8a8aca1ca1ce4b1bffee8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.7/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "105a84feb949390d45b87d3836f3edc1803ffc3457cd98ffea0319827f105cbc"
    end
  end
  license "MIT OR GPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "webguard"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "webguard"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "webguard"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "webguard"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
