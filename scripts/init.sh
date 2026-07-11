#!/usr/bin/env bash
# Bootstrap the Terraform S3 backend from environment variables.
#
# Usage:
#   ./scripts/init.sh                          # uses defaults / env vars
#   TF_BACKEND_BUCKET=my-bucket ./scripts/init.sh
#
# Environment variables (all optional — sensible defaults shown):
#   TF_BACKEND_BUCKET   S3 bucket for state (default: my-terraform-state)
#   TF_BACKEND_KEY      State key path        (default: terraform.tfstate)
#   TF_BACKEND_REGION   AWS region            (default: us-east-1)
#   TF_BACKEND_TABLE    DynamoDB lock table   (default: terraform-locks, omit to skip)
#   TF_WORKSPACE_DIR    Directory to init     (default: . — root; or environments/<env>)
set -euo pipefail

BUCKET="${TF_BACKEND_BUCKET:-my-terraform-state}"
KEY="${TF_BACKEND_KEY:-terraform.tfstate}"
REGION="${TF_BACKEND_REGION:-us-east-1}"
TABLE="${TF_BACKEND_TABLE:-terraform-locks}"
DIR="${TF_WORKSPACE_DIR:-.}"

echo "Initializing Terraform backend:"
echo "  bucket: ${BUCKET}"
echo "  key:    ${KEY}"
echo "  region: ${REGION}"
if [ -n "${TABLE}" ]; then
  echo "  table:  ${TABLE}"
fi
echo "  dir:    ${DIR}"
echo

# Build backend-config args
ARGS=(
  -backend-config="bucket=${BUCKET}"
  -backend-config="key=${KEY}"
  -backend-config="region=${REGION}"
)
if [ -n "${TABLE}" ]; then
  ARGS+=(-backend-config="dynamodb_table=${TABLE}")
fi
ARGS+=(-backend-config="encrypt=true")

cd "${DIR}"
terraform init -reconfigure "${ARGS[@]}"

echo
echo "Backend initialized. Run 'terraform plan' to preview changes."
