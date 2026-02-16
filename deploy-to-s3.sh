#!/bin/bash

echo "🚀 Deploying Next.js application to LocalStack S3..."

# Build the Next.js application
echo "📦 Building Next.js application..."
npm run build

# Check if Next.js build output exists
if [ ! -d "out" ]; then
    echo "❌ Next.js build output 'out' directory not found!"
    echo "💡 Make sure 'npm run build' completed successfully"
    echo "💡 Check if next.config.ts has 'output: export' configured"
    exit 1
fi

echo "✅ Found Next.js build output, proceeding with deployment..."
echo "📁 Files in out directory:"
find out -type f | head -10

# Check if LocalStack is running
echo "🔍 Checking LocalStack health..."
if ! curl -f http://localhost:4566/_localstack/health > /dev/null 2>&1; then
    echo "❌ LocalStack is not running. Please start it first with 'npm run localstack:start'"
    exit 1
fi

# Create S3 bucket if it doesn't exist
echo "🪣 Creating S3 bucket..."
awslocal s3 mb s3://verison-devos-one-website --endpoint-url=http://localhost:4566 2>/dev/null || echo "Bucket already exists"

# Configure S3 bucket for website hosting
echo "🌐 Configuring S3 bucket for website hosting..."
awslocal s3api put-bucket-website \
    --bucket verison-devos-one-website \
    --website-configuration '{
        "IndexDocument": {"Suffix": "index.html"},
        "ErrorDocument": {"Key": "404.html"}
    }' \
    --endpoint-url=http://localhost:4566

# Make bucket public
echo "🔓 Making bucket public..."
awslocal s3api put-bucket-policy \
    --bucket verison-devos-one-website \
    --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::verison-devos-one-website/*"
            }
        ]
    }' \
    --endpoint-url=http://localhost:4566

# Upload all Next.js static export files with proper Content-Type
echo "📤 Syncing Next.js build to S3 with UTF-8 encoding..."
awslocal s3 sync out/ s3://verison-devos-one-website --endpoint-url=http://localhost:4566 --delete \
  --content-type "text/html; charset=utf-8" --exclude "*" --include "*.html" 

# Upload other assets
awslocal s3 sync out/ s3://verison-devos-one-website --endpoint-url=http://localhost:4566 --delete \
  --exclude "*.html"

echo "📊 Verifying uploaded files..."
awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566 --recursive

echo "✅ Deployment complete!"
echo "🌐 Website URL: http://verison-devos-one-website.s3-website.us-east-1.localhost.localstack.cloud:4566"
echo "🔍 Check bucket contents: awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566"

# Clean up - no temporary files needed since we're using Next.js build output
echo "🎉 Next.js application successfully deployed to LocalStack S3!"
echo "💡 Your Next.js app is now running at the website URL above"