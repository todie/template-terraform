variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions for the target zones."
  type        = string
  sensitive   = true
}

variable "zones" {
  description = "Map of zone names to DNS record groups. Each zone has a `records` map of named groups, each a list of record objects."
  type = map(object({
    records = map(list(object({
      name     = string
      value    = string
      type     = string
      proxied  = bool
      priority = optional(number)
    })))
  }))
  default = {}
}
