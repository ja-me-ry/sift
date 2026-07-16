# Security Policy

## Reporting a Vulnerability

This is a personal portfolio project, not production software handling real user data.
That said, if you find a security issue:

1. **Do not open a public issue.**
2. Use GitHub's [private vulnerability reporting](../../security/advisories/new) for this repo,
   or email <you@example.com>.
3. Include: what you found, how to reproduce it, and the potential impact.

I'll acknowledge reports within 5 business days and aim to have a fix or mitigation
plan within 30 days for anything valid.

## Supported Versions

Only the `main` branch / latest deployed version is supported.

## Scope

In scope: this repository's application code, Dockerfile, and Terraform in `infra/`.
Out of scope: third-party dependencies (report those upstream) and the demo instance's
seeded/synthetic data.
