class CommitGhCli < Formula
  desc "Secure Git commits, releases, and repository security hardening"
  homepage "https://github.com/raymonepping/homebrew-commit-gh-cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "0448bdc7af7d61bbc5b05e8d3a3ef1b481e47213e33e6cfd9925de89b9d13707"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "bin/commit_gh"
    doc.install "README.md"
    man1.install "man/commit_gh.1"
    zsh_completion.install "completions/_commit_gh"
    bash_completion.install "completions/commit_gh.bash"
    fish_completion.install "completions/commit_gh.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/commit_gh --version")
  end
end
