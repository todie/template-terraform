# CLAUDE.md — Terraform/IaC Project (from todie/template-terraform)

## Template Family
This project was scaffolded from [todie/template-terraform](https://github.com/todie/template-terraform).
See also: [template-rust](https://github.com/todie/template-rust) | [template-python](https://github.com/todie/template-python) | [template-node](https://github.com/todie/template-node)

## Initialize
- `terraform init` — initialize providers and backend
- `terraform init -upgrade` — upgrade provider versions

## Plan & Apply
- `terraform plan` — preview changes
- `terraform plan -out=tfplan` — save plan to file
- `terraform apply tfplan` — apply saved plan
- `terraform apply -auto-approve` — apply without confirmation (CI only)

## Validate & Lint
- `terraform fmt -check` — check formatting
- `terraform fmt` — auto-format
- `terraform validate` — HCL syntax and provider schema validation
- `tflint` — lint with provider-specific rulesets (see .tflint.hcl)
- Pre-commit hooks: `pre-commit run --all-files`

## Security Scanning
- `checkov -d .` — CIS benchmarks and security scanning
- `trivy config .` — lightweight security scanner
- `conftest test .` — OPA policy checks (see policy/ directory)

## Testing
- `terraform test` — built-in test framework (*.tftest.hcl files in tests/)
- `terratest` (Go) — integration testing against real infrastructure

## Cost Estimation
- `infracost breakdown --path .` — estimate costs
- `infracost diff --path .` — cost diff for changes

## Structure
```
environments/     # Per-environment configs (dev/staging/prod)
modules/          # Reusable Terraform modules
policy/           # OPA/Rego policies for conftest
tests/            # terraform test files (*.tftest.hcl)
```

## CI Pipeline
CI runs on every PR: fmt → init → validate → tflint → checkov → plan.
On merge to main: apply. PR comments show plan output.

## Release
Uses release-please for automated semver via git tags. Write conventional commits:
- `feat:` → minor bump, `fix:` → patch bump, `feat!:` → major bump
- Terraform modules are versioned by git tags, not internal version files

## Commit Discipline
- One logical change per commit
- One commit stack per feature branch
- File a PR for each feature branch
- Never bundle unrelated changes
- Never push directly to main

## Architecture Notes
- Remote state with locking (configure backend in environments/*/main.tf)
- Workspaces for environment separation
- OPA policies enforce organizational constraints (tags, naming, cost limits)
- Atlantis recommended for PR-based plan/apply automation
- Drift detection via scheduled terraform plan runs
