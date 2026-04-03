# Example module — replace with real resources.
#
# Usage:
#   module "example" {
#     source      = "./modules/example"
#     name        = "my-resource"
#     environment = var.environment
#   }

resource "aws_ssm_parameter" "example" {
  name  = "/${var.environment}/${var.name}/placeholder"
  type  = "String"
  value = "replace-me"

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}
