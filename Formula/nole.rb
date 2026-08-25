class Nole < Formula
  desc "An Agent-driven terminal knowledge management system"
  homepage "https://github.com/FrostMiKu/NoleBase"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.1.0/nole-aarch64-apple-darwin.tar.xz"
    sha256 "c7cd6bc9999130a0e5f1e981e4b5202a77c8663df5464c735b9e63db47676ec5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.1.0/nole-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b3e381a033a808e2644157c6d8ce80f7c76afed08ab48bf653a18a9daf0ebfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.1.0/nole-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a13612e2258e8afff1c2a6c736795c9ec09e4c43791c0655f60637f5da519124"
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
