terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.62"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  # Uncomment and configure your backend:
  # backend "s3" {
  #   bucket         = "my-terraform-state"
  #   key            = "global/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "terraform"
      Project     = var.project_name
    }
  }
}

# ── Cloudflare DNS ────────────────────────────────────────────────────────────
# Optional: set cloudflare_dns_zones to create DNS records via the dns module.
# Leave cloudflare_dns_zones = {} (default) to skip.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "cloudflare_dns" {
  source               = "./modules/dns"
  count                = length(var.cloudflare_dns_zones) > 0 ? 1 : 0
  cloudflare_api_token = var.cloudflare_api_token
  zones                = var.cloudflare_dns_zones
}
