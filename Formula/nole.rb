class Nole < Formula
  desc "An Agent-driven terminal knowledge management system"
  homepage "https://github.com/FrostMiKu/NoleBase"
  version "0.9.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.2/nole-aarch64-apple-darwin.tar.xz"
    sha256 "2b22b2740749afd9b6bd2655e4d4239f7a6feba48365d82f24c0e60043e0616b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.2/nole-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac173bedea4f9d702f145d666f5e440b6efee06dffa1b873d7499120f3e859b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.2/nole-x86_64-unknown-linux-musl.tar.xz"
      sha256 "93f2879b41ff21278e4e01cc147d66edd6a0010b74dc4b8a6ad1c6418a23a2bc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "nole"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "nole"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "nole"
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
