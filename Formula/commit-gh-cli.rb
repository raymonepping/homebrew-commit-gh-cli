class CommitGhCli < Formula
  desc "Secure Git commits, releases, and repository security hardening"
  homepage "https://github.com/raymonepping/homebrew-commit-gh-cli"
  url "https://github.com/raymonepping/homebrew-commit-gh-cli/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "6fba83c27ea6c51df20b0f6dd9411af3217f7b65548df3e3cecb4ab55b57b72e"
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
