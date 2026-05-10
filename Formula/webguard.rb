class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.3.0/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "9da8fb88b7d30641a1c42d8b336fc1ab04a4de0782082639dd21cf75784c178f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.3.0/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "22371ba43f9c6663c8d8a1fc7fc6a7458481f371b6826d16befbaa702a2a2ccd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.3.0/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d0192e7a3927cd0d339b6995bafee60f0f478e68420c10b42ecf9ae10d9cea2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.3.0/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a62b65ce96d974f8b32b21f10bcf7ca5b52dc23a98c8f1a163f2ebbe5f7ba67"
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
