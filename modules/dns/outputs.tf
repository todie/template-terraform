output "record_names" {
  description = "Map of created record keys to their full DNS names."
  value       = { for k, r in cloudflare_dns_record.records : k => r.name }
}

output "zone_ids" {
  description = "Map of zone names to their resolved Cloudflare zone IDs."
  value       = { for k, z in data.cloudflare_zone.zones : k => z.id }
}
