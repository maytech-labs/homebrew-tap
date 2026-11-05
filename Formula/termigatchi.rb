# SPDX-License-Identifier: LicenseRef-REAL-1.0
# termigatchi, from https://github.com/maytech-labs/godo (crates/termigatchi).
# A release installs the prebuilt binary; --HEAD builds main with Rust.
# godo's release-termigatchi workflow updates the urls and sha256s.
class Termigatchi < Formula
  desc "Tiny, always-alive pet that lives in your terminal"
  homepage "https://github.com/maytech-labs/godo/tree/main/crates/termigatchi"
  # REAL 1.0, which has no SPDX identifier.
  license :cannot_represent

  head do
    url "https://github.com/maytech-labs/godo.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/termigatchi-v0.1.0/termigatchi-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "7ec5b483c8135d92a0812b63986e683c9a303ad7285e55049270a3c9ddb127d7"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/termigatchi-v0.1.0/termigatchi-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "176da4c0cbc6e2a390b2f108408f999fff296abddea943cb879609c1313159dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/maytech-labs/godo/releases/download/termigatchi-v0.1.0/termigatchi-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb1fd24cfa1f65199b8635c663e748f44100d149e10592936e401eafa8709f0d"
    end
    on_intel do
      url "https://github.com/maytech-labs/godo/releases/download/termigatchi-v0.1.0/termigatchi-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7c1d07990d9bf449dfad22dc163ccfba2b6e02a80371502b9f8072bb8bc0fb5b"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/termigatchi")
    else
      bin.install "termigatchi"
    end
  end

  test do
    assert_match "termigatchi #{version}", shell_output("#{bin}/termigatchi --version") if build.stable?
    ENV["TERMIGATCHI_HOME"] = testpath
    assert_empty shell_output("#{bin}/termigatchi status")
    assert_match "pet yet", shell_output("#{bin}/termigatchi feed 2>&1", 1)
  end
end
