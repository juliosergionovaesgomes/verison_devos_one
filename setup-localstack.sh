#!/bin/bash

echo "🚀 Setting up LocalStack environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Install LocalStack CLI if not present
if ! command -v localstack &> /dev/null; then
    echo "📦 Installing LocalStack CLI..."
    pip install localstack
fi

# Install AWS CLI Local if not present
if ! command -v awslocal &> /dev/null; then
    echo "📦 Installing AWS CLI Local..."
    pip install awscli-local
fi

# Start LocalStack
echo "🐳 Starting LocalStack..."
npm run localstack:start

# Wait for LocalStack to be ready
echo "⏳ Waiting for LocalStack to be ready..."
timeout 60s sh -c 'until curl -f http://localhost:4566/_localstack/health 2>/dev/null; do echo "Waiting..."; sleep 2; done'

if [ $? -eq 0 ]; then
    echo "✅ LocalStack is ready!"
    
    # Configure AWS CLI for LocalStack
    echo "🔧 Configuring AWS CLI for LocalStack..."
    aws configure set aws_access_key_id giropops
    aws configure set aws_secret_access_key stringus
    aws configure set default.region us-east-1
    
    # Initialize and apply Terraform
    echo "🏗️  Initializing Terraform..."
    npm run terraform:init
    
    echo "📋 Planning Terraform deployment..."
    npm run terraform:plan
    
    echo "🚀 Deploying infrastructure to LocalStack..."
    npm run terraform:apply
    
    echo "✅ Setup complete! LocalStack is running at http://localhost:4566"
    echo "🔍 You can check the health status at: http://localhost:4566/_localstack/health"
    echo "📊 Use 'npm run localstack:logs' to see LocalStack logs"
    echo "🛑 Use 'npm run localstack:stop' to stop LocalStack"
else
    echo "❌ LocalStack failed to start within 60 seconds"
    exit 1
fi