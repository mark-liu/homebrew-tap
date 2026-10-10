class Webguard < Formula
  desc "Secure MCP server — scans web content for prompt injection before it enters LLM context"
  homepage "https://github.com/mark-liu/webguard"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.3/webguard-aarch64-apple-darwin.tar.xz"
      sha256 "5d77d4b9006d0429e0bbcfa6287f27d6d9f2d0bad18ba5860b95fc7e13c65d1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.3/webguard-x86_64-apple-darwin.tar.xz"
      sha256 "5aad8f7548cde71dc3c015527fa84e543a5b674c9db0c9f58e68dcd7ae9956ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.3/webguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29ef0a50ec9d3dd491deb37b59c34010446e492419a9672a256f6952d1fd3f36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/webguard/releases/download/v0.5.3/webguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87d067ecad3b1ff95a9b275276318d01c7bc456c2135f896e88c36bba7b6710b"
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
