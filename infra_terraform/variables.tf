variable "region" { 
  description = "AWS region"
  default = "us-east-1" 
}

variable "aws_access_key" {
  default = "giropops"
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default = "stringus"
}

variable "use_localstack" {
  description = "Whether to use LocalStack for local development"
  type = bool
  default = true  # Set to true for LocalStack usage
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "verison-devos-one"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "localstack"
}

# LocalStack accepts any dummy credentials for testing