variable "name" {
  description = "Name of the resource managed by this module."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
  type        = string
}
