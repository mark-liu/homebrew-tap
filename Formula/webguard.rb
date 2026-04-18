class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.3/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "1b46af94a4311bc09614d8f3465b65c8e80207cba6a8b41cd48e4bd6097c6c1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.3/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "45a45c6dd6d9a1ea3b9f442f268928e97197d8ef41814fbb76f18723e7446fb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.3/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c30824f99168bb1c8986e5ed4ea7bd428fabbdbc78e292aee186f7db836952bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.1.3/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6cc81be61eb6c308d6c43d4a8ee5504ae52fde77d6bedf832bae619f7c0a534"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
