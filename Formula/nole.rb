class Nole < Formula
  desc "An Agent-driven terminal knowledge management system"
  homepage "https://github.com/FrostMiKu/NoleBase"
  version "0.9.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.3/nole-aarch64-apple-darwin.tar.xz"
    sha256 "c28e4404058c1d453dd6a1285ac9eb6e6d389027f11f72458681426bd872fdaa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.3/nole-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5534195d24346ff8dd3f3c715c948598c284146d2468c92f40e331f203ef2d4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FrostMiKu/NoleBase/releases/download/v0.9.3/nole-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5e3f10b4334824551a66a335b44059c11767820e0a3c2bda5961c4762772044f"
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
