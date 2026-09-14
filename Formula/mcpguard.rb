class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.3/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "9b2bd50618ad94840a88840922680c289bef95c1e670ae63f76a578016299aee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.3/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "668bddeb318371cd269b75d0720a0881084635cfc7dc8286ef7f4ad385208032"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.3/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e2fc2f4e1257b2b0bc40c4f0f00e140b96a8cbf7a598b61f04f2580c878c908"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.3/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d886be63dffd17660dff644348483ae5a547ba50c35b9a29f45efa7318cca663"
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
