# commit_gh

> Secure git commits, releases, and repository hardening — in one CLI.

[![Version](https://img.shields.io/github/v/release/raymonepping/homebrew-commit-gh-cli?label=version&color=blue)](https://github.com/raymonepping/homebrew-commit-gh-cli/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform: macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://github.com/raymonepping/homebrew-commit-gh-cli)
[![Homebrew tap](https://img.shields.io/badge/brew-raymonepping%2Fcommit--gh--cli-orange)](https://github.com/raymonepping/homebrew-commit-gh-cli)

`commit_gh` wraps `git` and the GitHub CLI (`gh`) to give every repository a consistent, secure foundation from day one. It handles three things that every project needs but nobody wants to wire up by hand: repository security hardening, gated commits with secret scanning, and automated semantic versioning with GitHub releases.

---

## Installation

```bash
brew tap raymonepping/commit-gh-cli
brew install commit-gh-cli
```

**Dependencies** — installed automatically by Homebrew:

| Tool | Purpose |
| ---- | ------- |
| `bash` 4+ | Runtime (macOS ships with bash 3 — Homebrew upgrades it) |
| `git` | All operations |
| `gh` | GitHub remote, releases, branch protection, labels |
| `gitleaks` | Secret scanning in hooks and CI |

Verify your environment after installing:

```bash
commit_gh --doctor
```

---

## Quick start

```bash
# Brand-new project
commit_gh --init-repo --init-remote --public --secret-scanning --protect --sign --labels

# Secure an existing repo
commit_gh --harden --audit

# Day-to-day: stage everything, scan, commit, push
commit_gh

# Ship a release
commit_gh --release patch
```

---

## What commit_gh does

### Security hardening — `--harden` / `--init-repo`

Both flags are idempotent: safe to re-run at any time. Files that already exist are left untouched.

| File | Purpose |
| ---- | ------- |
| `.gitignore` | Blocks secrets, OS artefacts, editor files, build output, `*.jsonl`, `input/`, `output/` |
| `.env.example` | Credential template — commit this, never `.env` |
| `.gitleaks.toml` | Gitleaks config with a `CHANGELOG.md` allowlist |
| `.git/hooks/pre-commit` | Blocks sensitive filenames and scans staged content with Gitleaks before every commit |
| `.github/workflows/gitleaks.yml` | CI secret scan, SHA-pinned action, `permissions: read-all` |
| `.github/workflows/release.yml` | Automated GitHub release on tag push |
| `.github/dependabot.yml` | Weekly GitHub Actions dependency updates |
| `CHANGELOG.md` | Keep-a-Changelog format, with `[Unreleased]` section |
| `LICENSE` | MIT |
| `README.md` | Project readme stub |
| `CONTRIBUTING.md` | Contribution guidelines |
| `.github/ISSUE_TEMPLATE/` | Bug report + feature request templates |
| `.github/pull_request_template.md` | PR template |
| `.github/CODEOWNERS` | Owner set from `gh api user` |
| `.editorconfig` | Consistent editor settings |
| `docs/release-checklist.md` | Release checklist |

### Three-layer secret defence

```
Layer 1 — Filename blocking (pre-commit hook)
  Matches staged filenames: .env, *.pem, *.key, *.p12, id_rsa, id_ed25519, .vault.*

Layer 2 — Content scanning (Gitleaks)
  Scans staged file contents. Catches secrets inside innocuous-looking files
  (Terraform vars, JSON configs, YAML, source code).

Layer 3 — GitHub Secret Scanning
  Server-side scan on every push. Catches secrets that bypass local tooling:
  commits with --no-verify, contributors without the hook, pushes from other machines.
```

Enable all three at once:

```bash
commit_gh --harden --secret-scanning
```

---

## Flags

Flags that share a category can be combined freely. Destructive flags (`--rollback`, `--scan`, `--read-version-only`) run exclusively.

### Setup

| Flag | Description |
| ---- | ----------- |
| `--init-repo` | Initialize a git repo + full security scaffold. Creates an initial commit so `gh repo create --push` has something to push. |
| `--init-remote` | Create an `origin` remote via the GitHub CLI. |
| `--public` | Make the remote repository public (use with `--init-remote`). |
| `--private` | Make the remote repository private — **default**. |

### Security

| Flag | Description |
| ---- | ----------- |
| `--harden` | Install all missing guardrails. Idempotent. |
| `--audit` | Report which guardrails are present / missing. Exits 1 if any are missing. |
| `--scan` | Run Gitleaks against the full working tree and exit. |
| `--no-scan` | Skip the automatic staged-file scan before committing. |
| `--no-hook` | Skip pre-commit hook installation during `--init-repo` or `--harden`. |
| `--secret-scanning` | Enable GitHub Secret Scanning + push protection via the API. |
| `--protect` | Set branch protection: 1 review required, no force-push, no deletion. |
| `--sign` | Enable GPG or SSH commit signing globally + add a CI verification workflow. |

### Release

| Flag | Description |
| ---- | ----------- |
| `--release patch\|minor\|major\|x.y.z` | Bump `VERSION`, commit, tag, push, create GitHub release, populate `CHANGELOG.md`. |
| `--force` | Overwrite an existing tag and GitHub release. |
| `--no-release` | Tag and push only — skip GitHub release creation. |
| `--generate-notes` | Auto-generate release notes from merged pull requests. |
| `--read-version-only` | Print version inventory (VERSION file, script constant, latest tag) and exit. |
| `--version-file <path>` | Path to the version file updated by `--release`. Default: `VERSION`. |
| `--rollback [tag]` | Delete a GitHub release and its tag (locally + remote). Defaults to the latest tag. Reverts the release commit automatically if it is HEAD. |

### Commit

| Flag | Description |
| ---- | ----------- |
| `--branch <name>` | Branch to commit and push to. Default: current branch, falling back to `main`. |
| `--message "<text>"` | Override the auto-generated commit message. |
| `--pr` | Create a pull request after commit and push. Targets the repo's default branch. |
| `--draft` | Open the PR as a draft — use with `--pr`. |
| `--dry-run` | Print every action without making changes. Works with all flags. |
| `--quiet` / `-q` | Suppress informational output. Errors always print. |
| `--tree [true\|false]` | Regenerate the folder tree with `folder_tree` before committing. |

### Utilities

| Flag | Description |
| ---- | ----------- |
| `--labels` | Create / update the standard GitHub issue label set on the remote repo. |
| `--changelog [bump]` | Preview what the next CHANGELOG entry would look like without writing anything. Bump type defaults to `patch`. |
| `--milestone [bump]` | Create a GitHub milestone for the next version. Bump type defaults to `patch`. |
| `--contributors` | Generate or overwrite `CONTRIBUTORS.md` from `git shortlog`. Regenerated on every run. |
| `--doctor` | Check the developer environment: bash version, git config, gitleaks, gh auth, SSH agent. |
| `--bump patch\|minor\|major` | Create a new annotated git tag from the latest tag. No file changes. |
| `--preview` | Preview the tag that `--bump` would create without creating it. |
| `--verify` | Check clean working tree, correct branch, and VERSION/tag alignment. |
| `--help` / `-h` | Show help and exit. |
| `--version` | Show the script version and exit. |

---

## Release flow

When you run `commit_gh --release patch` the following happens in order:

```
1. Sync    git stash → pull --rebase → pop stash
2. Bump    VERSION file: 1.2.3 → 1.2.4
3. CHANGELOG  Move conventional commits since the last tag into [1.2.4] section
4. Commit  chore: release v1.2.4
5. Tag     git tag -a v1.2.4
6. Push    branch + tag to origin
7. Release gh release create v1.2.4
```

**CHANGELOG auto-population** reads `git log` since the last tag and maps conventional commit prefixes to sections:

| Prefix | CHANGELOG section |
| ------ | ----------------- |
| `feat:` / `feat(*):` | Added |
| `fix:` / `fix(*):` | Fixed |
| `security:` | Security |
| `chore:` / `refactor:` / `perf:` / `build:` / `ci:` / `docs:` | Changed |

Commits that don't match a conventional prefix are silently skipped.

**Rolling back a bad release:**

```bash
commit_gh --rollback v1.2.4        # delete release + tag, revert commit if HEAD
commit_gh --rollback               # same, targets the latest tag
```

---

## Combining flags

Most flags compose. Run them left-to-right in a single invocation:

```bash
# Full new-repo setup in one command
commit_gh --init-repo --init-remote --public \
          --secret-scanning --protect --sign --labels

# Commit on a feature branch and open a PR
commit_gh --branch feature/auth --message "feat: add OAuth login" --pr

# Same, but open as a draft PR first
commit_gh --branch feature/auth --message "feat: add OAuth login" --pr --draft

# Harden, verify, and set up labels
commit_gh --harden --audit --labels

# Environment check + signing + labels
commit_gh --doctor --sign --labels

# Preview a release without doing anything
commit_gh --release minor --dry-run
```

Flags that run exclusively (they exit immediately and cannot be combined):
`--rollback`, `--scan`, `--read-version-only`, `--changelog`

---

## Signing

`--sign` detects your first available key and configures signing globally:

- **GPG** (preferred): reads `gpg --list-secret-keys`, sets `commit.gpgsign=true` + `user.signingkey`
- **SSH** (fallback): reads the first key from `ssh-add -L`, sets `gpg.format=ssh`

It also writes `.github/workflows/signed-commits.yml` so CI rejects unsigned commits on `main`.

If no key is found yet:

```bash
# GPG
gpg --gen-key

# SSH (ed25519 — preferred)
ssh-keygen -t ed25519 -C "you@example.com"
```

Then re-run `commit_gh --sign`.

---

## Labels

`--labels` creates (or updates) 12 canonical GitHub issue labels using `gh label create --force`:

| Label | Colour | Use |
| ----- | ------ | --- |
| `bug` | `#d73a4a` | Something isn't working |
| `enhancement` | `#a2eeef` | New feature or request |
| `security` | `#e4e669` | Security vulnerability or hardening |
| `breaking` | `#b60205` | Breaking change — requires consumer action |
| `documentation` | `#0075ca` | Documentation improvements |
| `good first issue` | `#7057ff` | Good for newcomers |
| `help wanted` | `#008672` | Extra attention needed |
| `question` | `#d876e3` | Further information requested |
| `wontfix` | `#ffffff` | Will not be worked on |
| `duplicate` | `#cfd3d7` | Already exists |
| `dependencies` | `#0366d6` | Dependency update |
| `ci/cd` | `#f9d0c4` | CI/CD related |

---

## Environment

`--doctor` checks five things:

```
bash ≥ 4   git + user config   gitleaks   gh + auth   SSH agent
```

Run it after installing or on a new machine before your first commit.

---

## Full documentation

```bash
man commit_gh
```

---

## Source and issues

[github.com/raymonepping/homebrew-commit-gh-cli](https://github.com/raymonepping/homebrew-commit-gh-cli)

---

## License

MIT — see [LICENSE](LICENSE).
