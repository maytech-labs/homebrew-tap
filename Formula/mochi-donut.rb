# matcha, yuzu, ube, and taro, from https://github.com/maytech-labs/mochi-donut.
# A release installs the prebuilt binaries; --HEAD builds main with Rust.
# mochi-donut's release workflow updates the urls and sha256s.
class MochiDonut < Formula
  desc "Tools that help AI coding agents work with evidence and in the right environment"
  homepage "https://github.com/maytech-labs/mochi-donut"
  # REAL 1.0, which has no SPDX identifier.
  license :cannot_represent

  head do
    url "https://github.com/maytech-labs/mochi-donut.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.1/mochi-donut-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "16264dd0d4ae410d7f6105d99ee2194e8e725cf5895cc295454a8f031ee4e306"
    end
    on_intel do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.1/mochi-donut-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "99447401c5452565faa57a08805c756bfeea9016306ed825743c5a9973ecac8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.1/mochi-donut-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d6e95a52149f66ffec5df4ed7113dd76877bcc4f669d0378441823711f7286d"
    end
    on_intel do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.1/mochi-donut-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "610b46de2dd4e6abdb367c434b5e7d4b5e27645af63d3013c35348ac7c9982e5"
    end
  end

  conflicts_with "matcha", because: "both install a `matcha` binary"

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/matcha")
      system "cargo", "install", *std_cargo_args(path: "crates/yuzu")
      system "cargo", "install", *std_cargo_args(path: "crates/ube")
      system "cargo", "install", *std_cargo_args(path: "crates/taro")
    else
      bin.install "matcha", "yuzu", "ube", "taro"
    end
  end

  test do
    assert_match "matcha #{version}", shell_output("#{bin}/matcha --version") if build.stable?
    assert_match "When to run what", shell_output("#{bin}/matcha agent-guide")
    assert_match "When to run what", shell_output("#{bin}/yuzu agent-guide")
    assert_match "When to run what", shell_output("#{bin}/ube agent-guide")
    assert_match "When to run what", shell_output("#{bin}/taro agent-guide")

    system "git", "init", "--quiet", testpath/"repo"
    (testpath/"repo/a.rs").write "cancelled\n"
    system "git", "-C", testpath/"repo", "add", "a.rs"
    output = shell_output("#{bin}/matcha --repo #{testpath}/repo census --spelling cancel")
    assert_match "cancelled", output
  end
end
