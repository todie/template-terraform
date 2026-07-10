output "project_name" {
  description = "The name of the project."
  value       = var.project_name
}

output "environment" {
  description = "The deployment environment."
  value       = var.environment
}

output "aws_region" {
  description = "The AWS region resources were deployed into."
  value       = var.aws_region
}

output "cloudflare_dns_record_names" {
  description = "Map of created Cloudflare DNS record keys to their names. Empty if DNS module is not used."
  value       = length(var.cloudflare_dns_zones) > 0 ? module.cloudflare_dns[0].record_names : {}
}

output "cloudflare_dns_zone_ids" {
  description = "Map of Cloudflare zone names to their resolved IDs. Empty if DNS module is not used."
  value       = length(var.cloudflare_dns_zones) > 0 ? module.cloudflare_dns[0].zone_ids : {}
}
