class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.1/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "b8e1a61fa82e902059017e540c6143251a8d689e8361c6f7b784dfe73e8e1a3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.1/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "42529b2e2c5338a80a185d17724ef942b2f158789914ff93347c7fa888e5d142"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.1/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38042ec54a247c02ede1a6e4df8794e65d4a43fb2d57d8c7f5baeb801d9013ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.1/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eccb1c85083dc9a5db4b2d4b1e5165890c5a1c41b5093f8d03de4c9cc671b0cd"
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
