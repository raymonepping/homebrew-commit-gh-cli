class CommitGhCli < Formula
  desc "CLI toolkit for visualizing folder structures with markdown reports"
  homepage "https://github.com/raymonepping/commit_gh_cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "61b6e843671b32dd3249eba5257e931d1b3088c2c7d39fe0b7657095c77dffae"
  license "MIT"
  version "2.0.13"

  depends_on "bash"

  def install
    bin.install "bin/commit_gh" => "commit_gh"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      To get started, run:
        commit_gh --help

      This CLI helps manage Git commits, tags, and semantic versioning.
      It uses a .version file for tracking current state.

      Example usage:
        commit_gh --bump patch --verify
    EOS
  end

  test do
    assert_match "commit_gh", shell_output("#{bin}/commit_gh --help")
  end
end