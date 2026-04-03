output "parameter_name" {
  description = "The SSM parameter name created by this module."
  value       = aws_ssm_parameter.example.name
}

output "parameter_arn" {
  description = "The ARN of the SSM parameter."
  value       = aws_ssm_parameter.example.arn
}
