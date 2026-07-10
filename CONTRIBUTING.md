# Contributing

Thank you for considering contributing to this project!

## Workflow

1. Fork the repository and create a feature branch from \`main\`.
2. Make your changes, following the code style of the project.
3. Commit using clear, conventional commit messages (\`feat:\`, \`fix:\`, \`chore:\`, etc.).
4. Open a pull request against \`main\` with a description of what changed and why.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

\`\`\`
feat: add new feature
fix: correct a bug
chore: update dependencies
docs: improve README
\`\`\`

## Secrets & security

- Never commit secrets, credentials, or \`.env\` files.
- The pre-commit hook will block sensitive filenames and run Gitleaks automatically.
- Report security vulnerabilities privately rather than opening a public issue.

## Code review

All pull requests require at least one approval before merging.
