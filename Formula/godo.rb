# SPDX-License-Identifier: LicenseRef-REAL-1.0
# godo, from https://github.com/maytech-labs/godo.
# A release installs the prebuilt binary; --HEAD builds main with Rust.
# godo's release workflow updates the urls and sha256s.
class Godo < Formula
  desc "Make, but every run is a detachable, logged, watchable job"
  homepage "https://github.com/maytech-labs/godo"
  # REAL 1.0, which has no SPDX identifier.
  license :cannot_represent

  head do
    url "https://github.com/maytech-labs/godo.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.2.0/godo-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "21c42aec8e42ee57ecd05371085ff16f19e1bb3bd262b675917869db2a54f7a8"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.2.0/godo-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "d043a74033df656ad6199c0675320450be014e5f78869b121bd80c62d4e1803c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.2.0/godo-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0cb092cb0d045e503dfb12a626d5431e2ecb5a5550ef3bfe31d37119779ad96"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.2.0/godo-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0d9f99bc6665c6c7c91e0fd7af8f16d8d79d53664fd4d2c9960832cc9f9893b5"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/godo")
    else
      bin.install "godo"
    end
  end

  test do
    assert_match "godo #{version}", shell_output("#{bin}/godo --version") if build.stable?

    (testpath/"godo.toml").write "[targets]\napp = \"app\"\n"
    (testpath/"app").mkpath
    (testpath/"app/Makefile").write "hello: ## Say hello\n\t@echo hello from godo\n"
    assert_match "Say hello", shell_output("#{bin}/godo list -n app")
    assert_match "hello from godo", shell_output("#{bin}/godo hello app")
    assert_match "no target named", shell_output("#{bin}/godo hello nope 2>&1", 1)
  end
end
