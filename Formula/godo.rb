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
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.1/godo-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "4742f4e80368b781d2a71bae97b116267dbcc511998debaeca45d39c61b1c7e0"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.1/godo-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "6e08a28e817c67911d861ca624d2f32f87553e89da9ff30d172d19e645c82db9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.1/godo-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2a48545c074d8187f02962ace8f50008497ff33a3f4339a84b24b30d7dfe4b1"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.1/godo-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "01ddc42ac094ccf6459c7dec0f5d4cb5a54d7ef2e0c88598c0d1e5036ab7e58c"
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
