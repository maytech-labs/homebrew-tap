# matcha, yuzu, ube, and taro, from https://github.com/maytech-labs/mochi-donut.
# HEAD-only until its first release: brew install --HEAD mochi-donut
class MochiDonut < Formula
  desc "Tools that help AI coding agents work with evidence and in the right environment"
  homepage "https://github.com/maytech-labs/mochi-donut"
  license :cannot_represent
  head "https://github.com/maytech-labs/mochi-donut.git", branch: "main"

  depends_on "rust" => :build

  conflicts_with "matcha", because: "both install a `matcha` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/matcha")
    system "cargo", "install", *std_cargo_args(path: "crates/yuzu")
    system "cargo", "install", *std_cargo_args(path: "crates/ube")
    system "cargo", "install", *std_cargo_args(path: "crates/taro")
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
