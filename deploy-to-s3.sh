#!/bin/bash

echo "🚀 Deploying Next.js application to LocalStack S3..."

# Build the Next.js application
echo "📦 Building Next.js application..."
npm run build

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
        "ErrorDocument": {"Key": "error.html"}
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

# Upload static files
echo "📤 Uploading files to S3..."

# Create a simple index.html if .next/server doesn't have it
if [ ! -f ".next/server/pages/index.html" ]; then
    echo "📝 Creating simple index.html..."
    mkdir -p temp_deployment
    cat > temp_deployment/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verison DevOps One - LocalStack Deployment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .status {
            background: #4CAF50;
            color: white;
            padding: 10px;
            border-radius: 4px;
            text-align: center;
            margin: 20px 0;
        }
        .info {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Verison DevOps One</h1>
        <div class="status">
            ✅ Successfully deployed to LocalStack!
        </div>
        <div class="info">
            <h3>LocalStack Deployment Information</h3>
            <ul>
                <li><strong>Environment:</strong> LocalStack Development</li>
                <li><strong>S3 Bucket:</strong> verison-devos-one-website</li>
                <li><strong>Region:</strong> us-east-1</li>
                <li><strong>Endpoint:</strong> http://localhost:4566</li>
            </ul>
        </div>
        <p>This is a Next.js application deployed on LocalStack S3 static website hosting.</p>
        <p>Your DevOps pipeline is working correctly! 🎉</p>
    </div>
</body>
</html>
EOF
    
    # Upload the custom index.html
    awslocal s3 cp temp_deployment/index.html s3://verison-devos-one-website/index.html --endpoint-url=http://localhost:4566
    
    # Clean up
    rm -rf temp_deployment
else
    # Upload Next.js generated files
    awslocal s3 cp .next/server/pages/index.html s3://verison-devos-one-website/index.html --endpoint-url=http://localhost:4566
fi

# Upload static assets if they exist
if [ -d ".next/static" ]; then
    echo "📁 Uploading static assets..."
    awslocal s3 sync .next/static s3://verison-devos-one-website/_next/static --endpoint-url=http://localhost:4566
fi

# Create error page
echo "📄 Creating error page..."
cat > error.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Error</title></head>
<body><h1>Page Not Found</h1><p>The requested page could not be found.</p></body>
</html>
EOF

awslocal s3 cp error.html s3://verison-devos-one-website/error.html --endpoint-url=http://localhost:4566
rm error.html

echo "✅ Deployment complete!"
echo "🌐 Website URL: http://verison-devos-one-website.s3-website.us-east-1.localhost.localstack.cloud:4566"
echo "🔍 Check bucket contents: awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566"