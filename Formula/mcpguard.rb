class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.1/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "d4ce60a2dfbe13e476d4e69a02d9a4c9df3b99e4bd52b720cbac27afa9d08e92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.1/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "472184e4c9a5f9ecc35c2dc772b276e1be4d2d6c0b1dcfb3d72df1a63eb8b6cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.1/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "932d35aaaf669e5876a6b6342ba717928cad74c47231e21c3085de8c8e8a4944"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.1/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c04c6dbc7688cec93b929f9e3efabab8e15de7be21a2d1c2faf43a2d1d8fd936"
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
    bin.install "mcpguard" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcpguard" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcpguard" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcpguard" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
