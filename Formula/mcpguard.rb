class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.2/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "0410a5344bd5338ed7673979ac0e9820706428e2b123a98096bd042226aab3b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.2/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "20f1e31992ea4b467d091f8f85fd443a2d1829cc3eb0604032c5d376538e3bfe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.2/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "252941f027c972cd7bcb535a11f20c3a59157229a7d5cd245907314eee4d7647"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.2/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "756a75c426a1f66e1aaf711bfe7e6f7a99a3152ef9df8d42212e7ac49e0fc5f5"
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
