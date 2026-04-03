# CLAUDE.md — template-terraform

This repository is a Terraform project template. Below is a map of the scaffolding and the commands you'll use most.

## Structure

```
.
├── main.tf                     # Root provider + backend config
├── variables.tf                # Root input variables
├── outputs.tf                  # Root outputs
├── versions.tf                 # Version pinning notes
├── environments/
│   ├── dev/main.tf             # Dev backend + root module call
│   ├── staging/main.tf         # Staging backend + root module call
│   └── prod/main.tf            # Prod backend + root module call
├── modules/
│   └── example/               # Example reusable module skeleton
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── policy/
│   └── require_tags.rego      # OPA policy: all resources must have required tags
├── tests/
│   └── example.tftest.hcl     # Terraform native test file
├── .tflint.hcl                # TFLint ruleset config (terraform + aws plugins)
├── .pre-commit-config.yaml    # Pre-commit hooks (fmt, validate, tflint, checkov, trivy)
├── .github/
│   └── workflows/
│       ├── ci.yml             # CI: fmt → validate → tflint → checkov → plan + infracost
│       └── release.yml        # release-please automated versioning
├── release-please-config.json
└── .release-please-manifest.json
```

## Common Commands

### Init & Plan

```bash
# Initialise (root)
terraform init

# Plan (root — dev vars)
terraform plan -var="project_name=my-project" -var="environment=dev"

# Plan a specific environment
cd environments/dev && terraform init && terraform plan
```

### Validate & Format

```bash
terraform validate
terraform fmt -recursive
```

### Lint

```bash
# Install TFLint: https://github.com/terraform-linters/tflint
tflint --init
tflint --config=.tflint.hcl
```

### Security Scan

```bash
# Checkov
pip install checkov
checkov -d . --framework terraform

# Trivy
trivy config .
```

### OPA / Conftest Policy Check

```bash
# Generate a plan JSON first
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json

# Run conftest
conftest test tfplan.json --policy policy/
```

### Native Terraform Tests

```bash
terraform test
```

### Pre-commit

```bash
# Install pre-commit: https://pre-commit.com
pre-commit install
pre-commit run --all-files
```

## CI/CD

CI runs on every push and PR:
1. `terraform fmt -check` — formatting gate
2. `terraform init && terraform validate` — structural correctness
3. `tflint` — linting
4. `checkov` + `trivy` — security scanning (SARIF uploaded to GitHub Security tab)
5. `conftest` — OPA policy enforcement
6. `terraform plan` — plan with placeholder credentials (no real AWS calls)
7. Infracost — cost diff comment on PRs (requires `INFRACOST_API_KEY` secret)

Releases are managed by release-please and follow Conventional Commits.

## Secrets Required

| Secret | Purpose |
|--------|---------|
| `INFRACOST_API_KEY` | Infracost cost estimation on PRs |
| `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` | Real plan/apply (add per environment) |


## Related Templates

| Language | Repository |
|----------|------------|
| Rust | [todie/template-rust](https://github.com/todie/template-rust) |
| Python | [todie/template-python](https://github.com/todie/template-python) |
| Node.js | [todie/template-node](https://github.com/todie/template-node) |
