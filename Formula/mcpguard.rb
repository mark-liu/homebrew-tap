class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.4/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "1076d1a47e34076b7ae5e0ed5363468da61688d4bd1ce7e424394a7d59e43c26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.4/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "760f5412726a19768f181fc387dd4fafead4d982db629e929ea08bdbaac8b49e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.4/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "415f077ebb255f07bf5d0e295199fd96cda8e9df5e52447195c3d73b2b6d9766"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.4.4/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c708665cff68f92626104b71459861d15bb451294640e184712938b9a22e9494"
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
