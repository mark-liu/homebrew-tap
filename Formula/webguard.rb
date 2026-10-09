class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.1/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "46bc06b39b7c9faad7f3bd9076189c2a68a64d795025b623a9ad528073253d37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.1/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "9fd8b1bcd031e89ead6155d09182f73a5247d24e03892d05578eb7509801f804"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.1/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "460bb0bd2ac2f5bd8352b211531d28a4eef1dadca4cef6fd7c37137df883a164"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.1/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "794f843f46e8f2635268fe8d928e6fe1c512599db531a466def9b71b2111e48f"
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
