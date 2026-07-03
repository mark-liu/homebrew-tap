class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.4/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "2a77bbd86b1fe08366e1e22bf9cd7dffd52a510d75932ddd69d4266fd276b114"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.4/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "3649553b85c68533320d09ea5bb16ba9896e598f473dea3be286aca90d52533b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.4/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ecbb2fcf4afffa7b6ce05af17326e0fbc318e153d5a81234c9fab7c303b9ae1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.4.4/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b591d3cf8f5e4ab65bb134d1fc48904d1f503b953b8ce2ef663b5ec7fdcb838a"
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
