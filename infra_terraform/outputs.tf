# Output values for the infrastructure

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "website_bucket_name" {
  description = "Name of the S3 website bucket"
  value       = aws_s3_bucket.website.id
}

output "website_url" {
  description = "URL of the S3 website"
  value       = "http://${aws_s3_bucket.website.id}.s3-website.${var.region}.localhost.localstack.cloud:4566"
}

output "artifacts_bucket_name" {
  description = "Name of the S3 artifacts bucket"
  value       = aws_s3_bucket.artifacts.id
}

output "security_group_web_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "cloudwatch_log_group" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.name
}