class RusticServer < Formula
  desc "rustic server - a REST server built in rust to use with rustic and restic.
"
  homepage "https://rustic.cli.rs/"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.4/rustic_server-aarch64-apple-darwin.tar.xz"
      sha256 "0ed1dd6cdc5f223cf223c31e648ddca296609cd81a02e376627326130293f51c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.4/rustic_server-x86_64-apple-darwin.tar.xz"
      sha256 "fc4cd2449e657cee0eec2d2bd95b8faf9255cee172ac2c837289b55b570fcaaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.4/rustic_server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e74a116673d36c788d274cc52d6fbb425dd65aba8874f7694d8090ed290c4deb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustic-rs/rustic_server/releases/download/v0.4.4/rustic_server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a05188d43a3fcdc3719de8bada5f8665ac0c664e80ef1387d7690811a6829fb0"
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
