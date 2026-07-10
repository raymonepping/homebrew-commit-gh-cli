#!/usr/bin/env bash
# commit_gh installer
# Usage: curl -fsSL https://raw.githubusercontent.com/raymonepping/homebrew-commit-gh-cli/main/install.sh | bash
set -euo pipefail

TAP="raymonepping/commit-gh-cli"
FORMULA="commit-gh-cli"
REPO="https://github.com/raymonepping/homebrew-commit-gh-cli"

RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
CYAN=$'\e[36m'
BOLD=$'\e[1m'
DIM=$'\e[2m'
RESET=$'\e[0m'

info()    { printf "  %s\n" "${CYAN}▸${RESET} $*"; }
ok()      { printf "  %s\n" "${GREEN}✅${RESET} $*"; }
warn()    { printf "  %s\n" "${YELLOW}⚠️${RESET}  $*"; }
die()     { printf "\n%s\n\n" "${RED}❌${RESET} $*" >&2; exit 1; }

echo ""
printf "%s\n" "  ${BOLD}${CYAN}commit_gh${RESET}  ${DIM}secure Git workflow CLI${RESET}"
printf "%s\n" "  ${DIM}${REPO}${RESET}"
echo ""
printf "%s\n" "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# ── OS check ──────────────────────────────────────────────────
case "$OSTYPE" in
  darwin*)  : ;;
  linux-gnu*) : ;;
  *) die "Unsupported OS: $OSTYPE  (macOS or Linux required)" ;;
esac

# ── Homebrew ──────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  warn "Homebrew not found — installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "Homebrew installed."
else
  ok "Homebrew $(brew --version | head -1)"
fi

# ── Tap ───────────────────────────────────────────────────────
if brew tap | grep -q "^${TAP}$"; then
  ok "Tap ${TAP} already added."
else
  info "Tapping ${TAP}..."
  brew tap "$TAP"
  ok "Tap added."
fi

# ── Install or upgrade ────────────────────────────────────────
if brew list "$FORMULA" &>/dev/null 2>&1; then
  info "Upgrading ${FORMULA}..."
  brew upgrade "$FORMULA" 2>/dev/null || true
  ok "commit_gh $(commit_gh --version 2>/dev/null || brew info --json "$FORMULA" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)"
else
  info "Installing ${FORMULA}..."
  brew install "$FORMULA"
  ok "commit_gh $(commit_gh --version 2>/dev/null || echo "installed")"
fi

# ── Optional dependencies ─────────────────────────────────────
echo ""
printf "%s\n" "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

if command -v gitleaks &>/dev/null; then
  ok "gitleaks found at $(command -v gitleaks)  ${DIM}(secret scanning enabled)${RESET}"
else
  warn "gitleaks not installed — secret scanning will be skipped."
  info "Install:  ${BOLD}brew install gitleaks${RESET}"
fi

if command -v gh &>/dev/null; then
  ok "gh CLI found at $(command -v gh)  ${DIM}(--init-remote and --secret-scanning enabled)${RESET}"
else
  warn "gh CLI not installed — GitHub remote creation will be unavailable."
  info "Install:  ${BOLD}brew install gh${RESET}"
fi

# ── Getting started ───────────────────────────────────────────
echo ""
printf "%s\n" "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
printf "%s\n" "  ${BOLD}Getting started${RESET}"
echo ""
printf "%s\n" "  ${DIM}New repository:${RESET}"
printf "%s\n" "  ${CYAN}commit_gh --init-repo --init-remote --public --secret-scanning${RESET}"
echo ""
printf "%s\n" "  ${DIM}Secure an existing repository:${RESET}"
printf "%s\n" "  ${CYAN}commit_gh --harden && commit_gh --audit${RESET}"
echo ""
printf "%s\n" "  ${DIM}Release:${RESET}"
printf "%s\n" "  ${CYAN}commit_gh --release patch${RESET}"
echo ""
printf "%s\n" "  ${DIM}Full reference:${RESET}"
printf "%s\n" "  ${CYAN}commit_gh --help${RESET}"
echo ""
printf "%s\n" "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
