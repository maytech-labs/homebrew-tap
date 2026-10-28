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
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.0/mochi-donut-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "9cf8476e9d269afbfebfbb30bc3f7470bfb0ab27d29a8e9f0d860ffd484482d3"
    end
    on_intel do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.0/mochi-donut-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "22e8df2668d02add19d5e9c67f8bca79d5c471b7bdbb113a08374f415b7d04af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.0/mochi-donut-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "806a9883111555663faeccb017008c018714582dfde5521297615f4882696baf"
    end
    on_intel do
      url "https://github.com/maytech-labs/mochi-donut/releases/download/v0.1.0/mochi-donut-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d6a84528ebbc0c71c3522f83170bc4959e6335c0fba61fcfae9da44a2a2891b"
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
