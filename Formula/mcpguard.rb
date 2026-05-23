class Mcpguard < Formula
  desc "Transparent MCP stdio proxy — scans tool results for prompt injection and compresses payloads before they reach the LLM"
  homepage "https://github.com/mark-liu/mcpguard"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.0/mcpguard-aarch64-apple-darwin.tar.xz"
      sha256 "1de0dc9bbf4577a16de5744295968cefc5531bf7856282f4215d14442d7fda00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.0/mcpguard-x86_64-apple-darwin.tar.xz"
      sha256 "a7e7952adec9babd4f8e2797ba1ad919ebcd5e8563d48dc7c50102dfd5faba57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.0/mcpguard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "684c1730d1c06d53fdbf726360b6c0d891d94c32777d3f27a135c62bb5951e7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mark-liu/mcpguard/releases/download/v0.2.0/mcpguard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2dfd1d64a7c7017cccf8b4f3761a158604204a953a0e5fcfe79ec44fd71a4e0e"
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
