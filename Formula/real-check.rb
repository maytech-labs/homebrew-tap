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
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.1/real-check-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "e8668248da3877672c67aaa3dc2a91cc1501b931c5dab5d88606899c74ce42f4"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.1/real-check-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "339452485b5dddcfd49616f07ca88a043c0d5ecb9bff006f2925680a01b5eb31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.1/real-check-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "44d543ccc47b2191c94db3543aa05475f4a38c3f31a3d841faa897825d901b82"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.1/real-check-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "19f03e8d2c25883066216f9574c461e80d21808edf7bb5d54fbc15b7cd8c2223"
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
