class CommitGhCli < Formula
  desc "CLI toolkit for visualizing folder structures with markdown reports"
  homepage "https://github.com/raymonepping/commit_gh_cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "185989e4af2be68636ff71cbfe940341d9b19e58ac4efc3de6fcc812ce7da3a2"
  license "MIT"
  version "1.4.1"

  depends_on "bash"

  def install
    bin.install "bin/commit_gh" => "commit_gh"
    doc.install "README.md"
    pkgshare.install %w[lib tpl]
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