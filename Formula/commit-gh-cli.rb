class CommitGhCli < Formula
  desc "CLI toolkit for visualizing folder structures with markdown reports"
  homepage "https://github.com/raymonepping/commit_gh_cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "552de6f4f9ef778906ae30e963929233da8a8efdeb5ea762dcf0fa8364e1b279"
  license "MIT"
  version "0.0.2"

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