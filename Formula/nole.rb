class Nole < Formula
  desc "An Agent-driven terminal knowledge management system"
  homepage "https://github.com/FrostMiKu/NoleBase"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.2.0/nole-aarch64-apple-darwin.tar.xz"
    sha256 "02c0d32ea6c459ac6591aec96e904e0ceec6d20c46eb7d77b2af8aa2cc9706d2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.2.0/nole-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f70de8d48cb5baca4fd10c456ece041de6bad46bde60c12d06287758a7d03b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.2.0/nole-x86_64-unknown-linux-musl.tar.xz"
      sha256 "23bb9287b887f2e26c33e05d79cc5c156d39e35bc79fb17b0b53410e8cf3cfb6"
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
