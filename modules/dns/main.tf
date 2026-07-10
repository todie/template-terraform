# Cloudflare DNS module — manage DNS records across multiple zones.
#
# Usage:
#   module "cloudflare_dns" {
#     source               = "./modules/dns"
#     cloudflare_api_token = var.cloudflare_api_token
#     zones = {
#       "example.com" = {
#         records = {
#           "www" = [{ name = "www.example.com", value = "192.0.2.1", type = "A", proxied = true }]
#         }
#       }
#     }
#   }
#
# Supports A, AAAA, CNAME, TXT, MX, and any other Cloudflare-supported record type.
# Proxied records use Cloudflare's automatic TTL (1); unproxied records default to 300.

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

# ── Zone lookups ─────────────────────────────────────────────────────────────

data "cloudflare_zone" "zones" {
  for_each = var.zones

  filter = {
    name = each.key
  }
}

# ── Records ─────────────────────────────────────────────────────────────────

resource "cloudflare_dns_record" "records" {
  for_each = {
    for r in flatten([
      for zone_name, groups in var.zones : [
        for group_key, records in groups.records : [
          for idx, rec in records : {
            zone_name = zone_name
            group_key = group_key
            idx       = idx
            record    = rec
          }
        ]
      ]
    ]) : "${r.zone_name}-${r.group_key}-${r.idx}" => r
  }

  zone_id  = data.cloudflare_zone.zones[each.value.zone_name].id
  name     = each.value.record.name
  content  = each.value.record.value
  type     = each.value.record.type
  ttl      = each.value.record.proxied ? 1 : 300
  proxied  = each.value.record.proxied
  priority = each.value.record.priority
}
