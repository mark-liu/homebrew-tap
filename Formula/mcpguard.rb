class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.3.0/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "c025a19ad482fc0622d83f30bb9127e5e234e8fb2938f329d1aa65082c0005c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.3.0/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "eb218886e0b59d6a00195c0eeb47a1cf8cf50dabffbcc9a2817ece35517f0811"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.3.0/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e06024e74f615689d8f6bcd995c27022d291cf737f139a46b16093cc4b2703c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.3.0/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ea5950b70120daf45e36f302a22ed19a697bd513d05eba26f92c3013c6f46c1"
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
