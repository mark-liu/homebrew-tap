class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.0/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "cc06bae1cffd1c02bb44c1d8da2ce816d7bfc8854def69fd67167e08983fe5a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.0/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "7d76958685dceb1c258874fdd7b14d0807e0ead4f8f7d4f9584e4481efe0d5ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.0/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f52c09ccb0586f13957dab758482e8dd1e608f9f39706d1978c5e8facb3744ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.0/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eb92359326238535e71226d81bad69b76391ab146c739933c03dae46535f3fc0"
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
