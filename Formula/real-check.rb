# SPDX-License-Identifier: LicenseRef-REAL-1.0
# real-check, from https://github.com/maytech-labs/real-check.
# A release installs the prebuilt binary; --HEAD builds main with Rust.
# real-check's release workflow updates the urls and sha256s.
class RealCheck < Formula
  desc "Check a repository and its dependencies for REAL 1.0 license compatibility"
  homepage "https://github.com/maytech-labs/real-check"
  # REAL 1.0, which has no SPDX identifier.
  license :cannot_represent

  head do
    url "https://github.com/maytech-labs/real-check.git", branch: "main"
    depends_on "rust" => :build
  end

  # Generates the SBOM for `real-check deps` and `real-check check`.
  depends_on "syft"

  on_macos do
    on_arm do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.2/real-check-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "b458994237c9db3397fff5d8b06dcb6885f54495b226d00839c852cb36d6f368"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.2/real-check-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "29f098c9e1721e77d2da696c4aeacb586bb8e6b3a0d5fd12c714df05e6f81330"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.2/real-check-v0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e62ef407e842d9c6c1ed78f9757adfc8a515bfc55f0cd114e9769c3ed17620be"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.2/real-check-v0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ff91b8787f40f9f7e6af371bfc11accae584572a06725a23588a773a54e7af49"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "real-check"
    end
  end

  test do
    assert_match "real-check", shell_output("#{bin}/real-check --version")

    (testpath/"LICENSE").write "MIT License\n\nCopyright (c) 2026 Example\n"
    output = shell_output("#{bin}/real-check repo #{testpath} --no-headers", 1)
    assert_match "license-not-real", output

    assert_match "deny", shell_output("#{bin}/real-check classify GPL-3.0-only", 1)
  end
end
