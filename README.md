# sift

> A service that ingests scanner output from a CI pipeline, normalizes and dedupes it,
> and tells you what to actually fix first — deployed by a pipeline that scans itself
> and feeds its own findings back in.

**Status:** 🚧 early build — see [Project Plan](docs/PROJECT_PLAN.md)

## Demo

_(coming in Phase 6 — public read-only instance link goes here)_

## What this is

Sift ingests SARIF and native tool output (Trivy, Semgrep, CodeQL, Checkov, ZAP) from a
CI/CD pipeline, deduplicates findings across tools and scans, enriches them with EPSS and
CISA KEV data, and produces an SSVC-style remediation decision (Track / Track* / Attend / Act) —
not just a raw CVSS score.

## Scope

**In scope:** ingest, normalize, dedupe, risk-decide, triage state, query API, minimal UI.

**Explicitly out of scope (for now):** multi-tenancy, RBAC beyond two roles, ticketing
integration, running the scanners itself, notifications.

## Architecture

_(Mermaid diagram — added Phase 4)_

## Pipeline

_(gate policy table — added Phase 6)_

## Local development

```bash
docker compose up
```

_(placeholder — verify this works on a clean clone before calling it done)_

## Docs

- [Project Plan](docs/PROJECT_PLAN.md)
- Dedupe design — `docs/dedupe.md` (Phase 2)
- Risk model — `docs/risk-model.md` (Phase 3)
- Threat model — `docs/threat-model.md` (Phase 6)

## What I'd do differently at scale

_(written honestly in Phase 6 — this section is not filler)_

## License

MIT — see [LICENSE](LICENSE)
