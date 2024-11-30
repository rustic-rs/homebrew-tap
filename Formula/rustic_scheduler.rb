class RusticScheduler < Formula
  desc "rustic scheduler - a client/server application to schedule regular backups on
many clients to one identical repository controlled by a central scheduling
server.
"
  homepage "https://rustic.cli.rs/"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_scheduler/releases/download/v0.2.1/rustic_scheduler-aarch64-apple-darwin.tar.xz"
      sha256 "9765be158103ced7b96531478a8f397fdfe58f34dd532b19bf072d11ebc327e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_scheduler/releases/download/v0.2.1/rustic_scheduler-x86_64-apple-darwin.tar.xz"
      sha256 "c9484175bb45c3dfe65b2f579ae2c85b84b7d7ad4a35e29c2e220f3cd846aa54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_scheduler/releases/download/v0.2.1/rustic_scheduler-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1f50f8326b17618b4ba996e5a43c72ccbb02a246a93fb0efea8403aecb8851c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_scheduler/releases/download/v0.2.1/rustic_scheduler-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "affd897dc21c83c93b8da0af07d6af9ca72f6e308bc1a34e58b38eeb7f85e18a"
    end
  end
  license any_of: ["Apache-2.0", "MIT"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "i686-unknown-linux-gnu":            {},
    "x86_64-apple-darwin":               {},
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
    bin.install "rustic-scheduler" if OS.mac? && Hardware::CPU.arm?
    bin.install "rustic-scheduler" if OS.mac? && Hardware::CPU.intel?
    bin.install "rustic-scheduler" if OS.linux? && Hardware::CPU.arm?
    bin.install "rustic-scheduler" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
