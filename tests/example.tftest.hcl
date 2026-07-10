# Terraform native test — requires Terraform >= 1.6
# Run with: terraform test

variables {
  project_name         = "test-project"
  environment          = "dev"
  aws_region           = "us-east-1"
  cloudflare_api_token = "abcdefghijklmnopqrstuvwxyz0123456789-_AB"
}

# ── Plan-time checks ──────────────────────────────────────────────────────────

run "plan_succeeds" {
  command = plan

  assert {
    condition     = var.environment == "dev"
    error_message = "Environment should be 'dev' in this test."
  }
}

run "invalid_environment_rejected" {
  command = plan

  variables {
    environment = "qa"
  }

  expect_failures = [var.environment]
}

# ── Apply-time checks (use mock_provider for unit tests) ──────────────────────

# Uncomment and configure mock providers to run apply-time assertions
# without hitting real AWS APIs.
#
# mock_provider "aws" {
#   mock_resource "aws_ssm_parameter" {
#     defaults = {
#       arn  = "arn:aws:ssm:us-east-1:123456789012:parameter/dev/test/placeholder"
#       name = "/dev/test/placeholder"
#     }
#   }
# }
#
# run "apply_creates_parameter" {
#   command = apply
#
#   assert {
#     condition     = module.example.parameter_arn != ""
#     error_message = "SSM parameter ARN should not be empty."
#   }
# }
