class CommitGhCli < Formula
  desc "Secure Git commits, releases, and repository security hardening"
  homepage "https://github.com/raymonepping/homebrew-commit-gh-cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "83d2d3ee8a5075710e15b93a73893a2578f97809f71dc9abefea89e4e8eeb377"
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
