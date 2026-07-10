# Release checklist

## Before tagging

- [ ] All changes merged to `main`
- [ ] CHANGELOG.md updated — move items from `[Unreleased]` to a new version section
- [ ] Version bump decided (patch / minor / major)

## Tag and release

- [ ] Run `commit_gh --release <patch|minor|major>` (or `--release x.y.z` for explicit version)
- [ ] Confirm GitHub release created and release workflow passed in Actions

## After release

- [ ] Announce if applicable
- [ ] Open a fresh `[Unreleased]` section in CHANGELOG.md
