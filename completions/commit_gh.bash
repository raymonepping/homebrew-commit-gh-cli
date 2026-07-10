_commit_gh() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  case "$prev" in
    --release|--bump)
      COMPREPLY=($(compgen -W "patch minor major" -- "$cur"))
      return
      ;;
    --tree)
      COMPREPLY=($(compgen -W "true false" -- "$cur"))
      return
      ;;
    --branch)
      COMPREPLY=($(compgen -W "$(git branch --format='%(refname:short)' 2>/dev/null)" -- "$cur"))
      return
      ;;
    --version-file)
      COMPREPLY=($(compgen -f -- "$cur"))
      return
      ;;
    --message)
      return
      ;;
  esac

  local opts="
    --help -h --version
    --quiet -q --dry-run
    --init-repo --init-remote --public --private
    --harden --audit --scan --no-scan --no-hook --secret-scanning
    --release --force --no-release --generate-notes
    --read-version-only --version-file
    --branch --message --tree
    --bump --preview --verify"

  COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

complete -F _commit_gh commit_gh
