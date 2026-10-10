class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.2/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "27caf743bf8aaf93fe5a74901939e7b3412e5bdf07791de82821bd0185c8d711"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.2/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "e24d9bde742753f89ceb5e0328239fad22d25fd0da61fca8ca21d71a6192621e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.2/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd22f178ae7afdf0d3eb609dea87526440c2c6e817ad20ef66c17d5d65192cb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.2/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e6e90adb714a6ad3e7d7c0726371e7b2feea6aad00f8f8c5c3fcf70f4d9f715"
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
      bin.install "mcpguard"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mcpguard"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mcpguard"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mcpguard"
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
