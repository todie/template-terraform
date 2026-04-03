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
