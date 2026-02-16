# S3 Bucket for static website hosting
resource "aws_s3_bucket" "website" {
  bucket = "verison-devos-one-website"

  tags = {
    Name        = "verison-devos-one-website"
    Environment = "localstack"
  }
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 Bucket Public Access Block (disable for website hosting)
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for public read
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
    ]
  })
}

# S3 Bucket for deployment artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "verison-devos-one-artifacts"

  tags = {
    Name        = "verison-devos-one-artifacts"
    Environment = "localstack"
  }
}