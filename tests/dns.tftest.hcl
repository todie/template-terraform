# Cloudflare DNS module — tests
#
# Run with: terraform test
#
# Uses the cloudflare provider mock to avoid hitting the real API.
# Asserts on root-level outputs (cloudflare_dns_record_names, cloudflare_dns_zone_ids).

variables {
  project_name         = "test-project"
  environment          = "dev"
  aws_region           = "us-east-1"
  cloudflare_api_token = "abcdefghijklmnopqrstuvwxyz0123456789-_AB"
  cloudflare_dns_zones = {
    "example.com" = {
      records = {
        "www" = [
          {
            name    = "www.example.com"
            value   = "192.0.2.1"
            type    = "A"
            proxied = true
          }
        ],
        "mail" = [
          {
            name     = "example.com"
            value    = "mail.example.com"
            type     = "MX"
            proxied  = false
            priority = 10
          }
        ]
      }
    }
  }
}

# ── Plan-time checks ──────────────────────────────────────────────────────────

run "plan_succeeds" {
  command = plan

  assert {
    condition     = length(var.cloudflare_dns_zones) == 1
    error_message = "Should have one zone in test."
  }
}

run "record_count" {
  command = plan

  assert {
    condition     = length(output.cloudflare_dns_record_names) == 2
    error_message = "Should plan 2 records (1 A + 1 MX)."
  }
}

run "zone_resolved" {
  command = plan

  assert {
    condition     = lookup(output.cloudflare_dns_zone_ids, "example.com", null) != null
    error_message = "Zone example.com should be resolved."
  }
}

# ── Apply-time checks (mocked) ────────────────────────────────────────────────

mock_provider "cloudflare" {
  mock_resource "cloudflare_dns_record" {
    defaults = {
      id      = "mock-record-id"
      zone_id = "mock-zone-id"
    }
  }
  mock_data "cloudflare_zone" {
    defaults = {
      id   = "mock-zone-id"
      name = "example.com"
    }
  }
}

run "apply_creates_records" {
  command = apply

  assert {
    condition     = length(output.cloudflare_dns_record_names) == 2
    error_message = "Should create 2 records."
  }
}
