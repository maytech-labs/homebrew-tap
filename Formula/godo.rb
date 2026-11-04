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
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.0/godo-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "4c0b7d2b2234e0c3a082f70db5ede6963cfeb62717589ad735310ea0d3048712"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.0/godo-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "480f3ae3bd36e81ee4499fe9210dd8ab4f9ee89d592a6e11ce7ff027f7b1e858"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.0/godo-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "02043a82bad7a4f6e1df9176f8d0253d53445907d9c7d4e75e25866be58f4f4d"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/godo-v0.1.0/godo-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d12307170993bb1eb6c0befec18fafaa1d25d218d1f8109ea85d4ee9bb8235b3"
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
