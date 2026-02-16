# S3 Access Policy (minimal IAM for S3 operations if needed)
resource "aws_iam_user" "s3_user" {
  name = "s3-deployment-user"
  
  tags = {
    Name        = "s3-deployment-user"
    Environment = var.environment
  }
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "s3-deployment-policy"
  user = aws_iam_user.s3_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:PutBucketWebsite",
          "s3:GetBucketWebsite"
        ]
        Resource = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*",
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      }
    ]
  })
}