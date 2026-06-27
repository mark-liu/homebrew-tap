class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.3/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "f04c2d7c01d210ec46a9fc1e372b15fb4672f36da2af6f51ebb06e293e4e135c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.3/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "1b47179c6092ef36c3d0237d299921701dd10859ea4613b3b2561a2f1c43c354"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.3/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5034f17b5a1d6b27ace252fa027a170cc31a2c8170636e0886e89323748ac8b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.3/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1ef4a81e50953832893287f2368ccd100a93020e5af70e0254e4850ee8df85a7"
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
