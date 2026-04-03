class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.2/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "770700af0a35cdefe2fd2e8c2b5fa203eea89972fc675cfdbf345b558aa94581"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.2/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "8a104b3e18ba7f853392d9a7ca0f78b62d7a33646a1154bd6e5c497b6943c778"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.2/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3e33cc28dfc0fa92df57caeb63118a80a4c7798b84bcc1ca4c571e9c981656e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.2/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea67ef4e040df6ced1e75edef4ec00a2ac847bc4c49fa228d6406319ef6e9ad1"
    end
  end
  license "MIT"

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
    bin.install "webguard" if OS.mac? && Hardware::CPU.arm?
    bin.install "webguard" if OS.mac? && Hardware::CPU.intel?
    bin.install "webguard" if OS.linux? && Hardware::CPU.arm?
    bin.install "webguard" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
