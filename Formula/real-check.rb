# real-check, from https://github.com/maytech-labs/real-check.
# A release installs the prebuilt binary; --HEAD builds main with Rust.
# real-check's release workflow updates the urls, version, and sha256s.
class RealCheck < Formula
  desc "Check a repository and its dependencies for REAL 1.0 license compatibility"
  homepage "https://github.com/maytech-labs/real-check"
  version "0.1.0"
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
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.0/real-check-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "ca5810cbb5bd22a25a0915331bfc4eaa1201f7eb8e4c9c2088531f7b76e72e15"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.0/real-check-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "6433b72ef23f1eb577ebc6b8c81f9c4fe9a11b2701648d5a2fde534987650888"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.0/real-check-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2bd8522a71b9d29c796e345aa90ce4b2b9a1441af45097e4d8544280af7fda24"
    end
    on_intel do
      url "https://github.com/maytech-labs/real-check/releases/download/v0.1.0/real-check-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1badafafbcc2583a8442dfd66746e3fe64d6ef551a96994978a6c63a1d8b06ac"
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
