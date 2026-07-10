class CommitGhCli < Formula
  desc "CLI toolkit for visualizing folder structures with markdown reports"
  homepage "https://github.com/raymonepping/commit_gh_cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "09c290c37c41e08702e9abe66e351bcd2a2c3f2c49088c3d480e1cb8da509448"
  license "MIT"
  version "2.0.4"

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