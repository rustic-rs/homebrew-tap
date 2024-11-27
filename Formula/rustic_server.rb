class RusticServer < Formula
  desc "rustic server - a REST server built in rust to use with rustic and restic.
"
  homepage "https://rustic.cli.rs/"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.3/rustic_server-aarch64-apple-darwin.tar.xz"
      sha256 "4e6e7304e3c2b586d6d30c52f9cadefbeb26e39b4153684a23fc2280fe13b473"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.3/rustic_server-x86_64-apple-darwin.tar.xz"
      sha256 "5458e15726615a6e3b91a54d73c1e0760f8cebe414dafede27ba27f32efc891d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.3/rustic_server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e95af8a4eea3ac62ab31112db1600e2a82d1778d0c5186ab52434c1ad9cf632"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.3/rustic_server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82bbde5be80890f53677b70c4d6b64c5d7bbb8334f1443bf3a50f38ceb72fa79"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "rustic-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "rustic-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "rustic-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "rustic-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
