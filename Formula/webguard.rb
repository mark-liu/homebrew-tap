class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.5/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "f4c43a127a6eb23101e6e50ef8988148c1477690678ba274d9ac634fdb6c030f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.5/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "bc2d0b59376577ec4dd5f3c393b75e0f77c4b5398cd388f7e0095b8a02f68197"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.5/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b53e33cb06dda65d15c39bb101492adf5d1a87ab704bfca84b66b5a2492adb14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.5/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c889b476dfbd1102ddbae150434a4689bd4f2645de2c80af4f9b429ffb417d3"
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
