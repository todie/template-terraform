variable "project_name" {
  description = "Name of the project. Used for tagging and resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token. Required if using the DNS module. Leave empty to skip."
  type        = string
  default     = ""
  sensitive   = true
}

variable "cloudflare_dns_zones" {
  description = "Cloudflare DNS zones and records to manage. Empty = no DNS. See modules/dns/variables.tf for shape."
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
