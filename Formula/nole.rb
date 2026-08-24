class Nole < Formula
  desc "An Agent-driven terminal knowledge management system"
  homepage "https://github.com/FrostMiKu/NoleBase"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.0.0/nole-aarch64-apple-darwin.tar.xz"
    sha256 "4085bfeaf9611fd1463e0c0a75843d1190694330d590d50c2eaf425d5bfafd0b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.0.0/nole-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30a99caf3433b3059de3f953454e19c306fd58ccf159daf9e08faafb0bd1d0bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v1.0.0/nole-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4f7e21f59722247e6422a0797f4c543416ebfb55fe716f47df72b50d95aeed2e"
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
