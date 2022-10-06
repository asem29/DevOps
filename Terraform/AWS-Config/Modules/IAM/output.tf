output "arn_iam" {
  description = "ARN of the IAMRole"
  value       = aws_iam_role.config_role.arn
}