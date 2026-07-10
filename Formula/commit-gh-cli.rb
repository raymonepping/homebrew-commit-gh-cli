class CommitGhCli < Formula
  desc "CLI toolkit for visualizing folder structures with markdown reports"
  homepage "https://github.com/raymonepping/commit_gh_cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.0.14.tar.gz"
  sha256 "b5eb327cad565145a275dec5060563546940264617d33c7691c4b67926ac3640"
  license "MIT"
  version "2.0.14"

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