provider "aws" {
  region = var.region
  
  # LocalStack accepts any credentials
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  # LocalStack specific configuration
  s3_use_path_style           = var.use_localstack
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack

  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      ecr        = "http://localhost:4566"
      ecs        = "http://localhost:4566"
      iam        = "http://localhost:4566"
      ec2        = "http://localhost:4566"
      logs       = "http://localhost:4566"
    }
  }
}

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}