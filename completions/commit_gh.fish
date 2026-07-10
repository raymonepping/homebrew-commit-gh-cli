# fish completions for commit_gh
# Install: cp commit_gh.fish ~/.config/fish/completions/

# Disable file completion by default
complete -c commit_gh -f

# General
complete -c commit_gh -s h -l help          -d 'Show help and exit'
complete -c commit_gh      -l version       -d 'Show script version'
complete -c commit_gh -s q -l quiet         -d 'Suppress most output'
complete -c commit_gh      -l dry-run       -d 'Show what would happen without making changes'

# Setup
complete -c commit_gh -l init-repo          -d 'Initialize a git repo in the current directory'
complete -c commit_gh -l init-remote        -d 'Create origin remote via gh CLI'
complete -c commit_gh -l public             -d 'Make remote repo public (with --init-remote)'
complete -c commit_gh -l private            -d 'Make remote repo private — default (with --init-remote)'

# Security
complete -c commit_gh -l harden             -d 'Install missing security guardrails (idempotent)'
complete -c commit_gh -l audit              -d 'Report which guardrails are present or missing'
complete -c commit_gh -l scan               -d 'Run gitleaks on full working tree and exit'
complete -c commit_gh -l no-scan            -d 'Skip automatic gitleaks staged scan before commit'
complete -c commit_gh -l no-hook            -d 'Skip pre-commit hook installation'
complete -c commit_gh -l secret-scanning    -d 'Enable GitHub secret scanning and push protection'

# Release
complete -c commit_gh -l release            -d 'Bump version, commit, tag, push, GitHub release' \
  -r -a 'patch minor major'
complete -c commit_gh -l force              -d 'Overwrite existing tag and GitHub release'
complete -c commit_gh -l no-release         -d 'Tag and push only — skip GitHub release creation'
complete -c commit_gh -l generate-notes     -d 'Auto-generate release notes from pull requests'
complete -c commit_gh -l read-version-only  -d 'Print version inventory and exit'
complete -c commit_gh -l version-file       -d 'Version file for --release (default: VERSION)' \
  -r -a '(__fish_complete_path)'

# Commit
complete -c commit_gh -l branch             -d 'Branch for commit and push' \
  -r -a '(git branch --format="%(refname:short)" 2>/dev/null)'
complete -c commit_gh -l message            -d 'Override the default commit message' -r
complete -c commit_gh -l tree               -d 'Regenerate folder tree before committing' \
  -r -a 'true false'

# Utilities
complete -c commit_gh -l protect            -d 'Set branch protection on remote (1 review required, no force-push)'
complete -c commit_gh -l doctor             -d 'Check developer environment — bash, git, gitleaks, gh, SSH'
complete -c commit_gh -l bump               -d 'Create a new git tag from the latest tag' \
  -r -a 'patch minor major'
complete -c commit_gh -l preview            -d 'Preview next --bump tag without creating it'
complete -c commit_gh -l verify             -d 'Run verification checks (clean tree, branch, version)'
