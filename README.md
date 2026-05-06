<div align="center">

<!-- Replace with your own logo or remove this block -->
<img src="https://raw.githubusercontent.com/todie/template-terraform/main/.github/assets/logo.png" alt="todie terraform template" width="120" height="120" onerror="this.style.display='none'"/>

# template-terraform

**Production-ready Terraform template with batteries included.**
Multi-environment layout · OPA policies · native tests · full CI/CD pipeline

<br/>

[![CI](https://github.com/todie/template-terraform/actions/workflows/ci.yml/badge.svg)](https://github.com/todie/template-terraform/actions/workflows/ci.yml)
[![Release](https://github.com/todie/template-terraform/actions/workflows/release.yml/badge.svg)](https://github.com/todie/template-terraform/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![TFLint](https://img.shields.io/badge/linter-tflint-5C4EE5)](https://github.com/terraform-linters/tflint)
[![Checkov](https://img.shields.io/badge/security-checkov-blue)](https://www.checkov.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://pre-commit.com/)

</div>

---

## todie Template Family

This is the **Terraform/IaC** template. Part of the todie.io standardized project scaffolding.

| Template | Language | Repo |
|----------|----------|------|
| template-rust | Rust | [todie/template-rust](https://github.com/todie/template-rust) |
| template-python | Python 3.12+ | [todie/template-python](https://github.com/todie/template-python) |
| template-node | TypeScript/Node | [todie/template-node](https://github.com/todie/template-node) |
| **template-terraform** | Terraform/IaC | *you are here* |

All templates follow the [todie.io SOP](https://github.com/todie) — consistent CI/CD, linting, security scanning, release automation, and commit discipline across every project.

---

## Overview

`template-terraform` is a GitHub template repository that gives you a complete, opinionated Terraform project skeleton in seconds. Clone it, rename a few variables, and ship.

**What's included:**

| Layer | Tooling |
|---|---|
| Infrastructure | Terraform ≥ 1.6, AWS provider ~5.0 |
| Linting | TFLint + terraform ruleset + AWS ruleset |
| Security | Checkov, Trivy, OPA/Conftest |
| Testing | Terraform native tests (`terraform test`) |
| Git hooks | pre-commit (fmt, validate, lint, scan, secrets) |
| CI/CD | GitHub Actions — lint → security → plan → infracost |
| Releases | release-please (Conventional Commits → automated changelogs) |

---

## Quick Start

```bash
# 1. Use this template on GitHub, then clone your new repo
git clone https://github.com/<your-org>/<your-repo>.git
cd <your-repo>

# 2. Install dependencies
brew install terraform tflint pre-commit     # macOS
# or: see .tool-versions / docs for other platforms

# 3. Install git hooks
pre-commit install

# 4. Init & plan
terraform init
terraform plan \
  -var="project_name=my-project" \
  -var="environment=dev"
```

---

## Repository Structure

```
.
├── main.tf                       ← root provider + backend config
├── variables.tf                  ← root input variables
├── outputs.tf                    ← root outputs
├── versions.tf                   ← version pinning notes
│
├── environments/
│   ├── dev/main.tf               ← dev backend + root module call
│   ├── staging/main.tf           ← staging backend + root module call
│   └── prod/main.tf              ← prod backend + root module call
│
├── modules/
│   └── example/                  ← reusable module skeleton
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── policy/
│   └── require_tags.rego         ← OPA: all resources must have required tags
│
├── tests/
│   └── example.tftest.hcl        ← Terraform native test file
│
├── .tflint.hcl                   ← TFLint ruleset config
├── .pre-commit-config.yaml       ← pre-commit hook definitions
├── .editorconfig                 ← editor formatting standards
│
└── .github/
    └── workflows/
        ├── ci.yml                ← CI pipeline
        └── release.yml           ← release-please automation
```

---

## Development

### Init & Plan

```bash
# Root module
terraform init
terraform plan -var="project_name=my-project" -var="environment=dev"

# Specific environment
cd environments/dev
terraform init
terraform plan
```

### Validate & Format

```bash
terraform validate
terraform fmt -recursive -diff
```

### Lint

```bash
tflint --init
tflint --config=.tflint.hcl
```

### Security Scan

```bash
# Static analysis
checkov -d . --framework terraform --compact

# Vulnerability scan
trivy config .
```

### OPA Policy Check

```bash
terraform plan -out=tfplan.binary -var="project_name=test" -var="environment=dev"
terraform show -json tfplan.binary > tfplan.json
conftest test tfplan.json --policy policy/
```

### Native Tests

```bash
terraform test
```

### Run All Pre-commit Hooks

```bash
pre-commit run --all-files
```

---

## CI/CD

### CI Pipeline (`ci.yml`)

Every push and pull request runs the following jobs in order:

```
┌─────────────────┐    ┌──────────────────┐
│   lint          │    │   security       │
│                 │    │                  │
│  fmt -check     │    │  checkov (SARIF) │
│  init           │    │  trivy  (SARIF)  │
│  validate       │    │                  │
│  tflint         │    └────────┬─────────┘
└────────┬────────┘             │
         └──────────┬───────────┘
                    ▼
          ┌─────────────────┐    ┌──────────────────┐
          │   plan          │    │   infracost      │
          │                 │    │  (PRs only)      │
          │  terraform plan │    │  cost diff → PR  │
          │  (mock creds)   │    │  comment         │
          └─────────────────┘    └──────────────────┘
```

Security scan results are uploaded to the **GitHub Security tab** as SARIF reports.

### Release Pipeline (`release.yml`)

Commits to `main` that follow [Conventional Commits](https://www.conventionalcommits.org/) are automatically batched into a release PR by [release-please](https://github.com/googleapis/release-please). Merging the release PR:

- Bumps the version in `.release-please-manifest.json`
- Generates / updates `CHANGELOG.md`
- Creates a GitHub Release with a git tag

### Required Secrets

| Secret | Purpose |
|--------|---------|
| `INFRACOST_API_KEY` | Cost estimation on PRs — [get one free](https://www.infracost.io/) |
| `AWS_ACCESS_KEY_ID` | Real plan/apply (add per-environment) |
| `AWS_SECRET_ACCESS_KEY` | Real plan/apply (add per-environment) |

---

## Environments

Each directory under `environments/` is a standalone Terraform root that calls the root module with environment-specific backend and variable values.

```
environments/
├── dev/      → s3://my-terraform-state/dev/terraform.tfstate
├── staging/  → s3://my-terraform-state/staging/terraform.tfstate
└── prod/     → s3://my-terraform-state/prod/terraform.tfstate
```

Update the `backend "s3"` blocks in each `environments/*/main.tf` with your real bucket and table names before use.

---

## Modules

Drop reusable components under `modules/`. The `example` module is a minimal skeleton — replace it with real infrastructure.

```bash
# Reference from root or an environment
module "my_thing" {
  source      = "./modules/example"
  name        = "my-thing"
  environment = var.environment
}
```

---

## Policies

OPA policies live in `policy/`. They are enforced in CI via [Conftest](https://www.conftest.dev/) against the Terraform plan JSON.

| Policy | File | Rule |
|--------|------|------|
| Require tags | `require_tags.rego` | All taggable resources must have `Environment`, `ManagedBy`, and `Project` tags |

Add more `.rego` files to `policy/` — Conftest picks them up automatically.

---



## Related Templates

Looking for a different language? Check out the other todie templates:

| Template | Stack |
|----------|-------|
| [template-rust](https://github.com/todie/template-rust) | Rust · clippy · cargo-deny · nextest |
| [template-python](https://github.com/todie/template-python) | Python · uv · ruff · pyright · pytest |
| [template-node](https://github.com/todie/template-node) | Node.js · TypeScript · Vitest · Biome |

---

## License

MIT © 2026 [todie.io](https://todie.io)
