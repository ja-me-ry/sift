# Contributing

This is currently a solo portfolio project, but it's built like a team repo:

- All changes land via PR — direct pushes to `main` are blocked.
- PRs must pass: lint, tests, SAST (Semgrep + CodeQL), SCA (Trivy), secret scanning (gitleaks),
  and IaC scanning (Checkov) once `infra/` exists.
- Commit messages: [Conventional Commits](https://www.conventionalcommits.org/) style
  (`feat:`, `fix:`, `chore:`, `docs:`) — not required, but used throughout this repo's history.
- New findings surfaced by a scanner get triaged, not silenced: either fixed, or accepted
  with a documented, expiring justification (see `docs/risk-model.md`).

## Local setup

```bash
pip install pre-commit
pre-commit install
```
