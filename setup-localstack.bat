@echo off
echo 🚀 Setting up LocalStack environment...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker first.
    pause
    exit /b 1
)

REM Install LocalStack CLI if not present
where localstack >nul 2>&1
if errorlevel 1 (
    echo 📦 Installing LocalStack CLI...
    pip install localstack
)

REM Install AWS CLI Local if not present
where awslocal >nul 2>&1
if errorlevel 1 (
    echo 📦 Installing AWS CLI Local...
    pip install awscli-local
)

REM Start LocalStack
echo 🐳 Starting LocalStack...
npm run localstack:start

REM Wait for LocalStack to be ready
echo ⏳ Waiting for LocalStack to be ready...
:wait_loop
timeout /t 2 /nobreak >nul
curl -f http://localhost:4566/_localstack/health >nul 2>&1
if errorlevel 1 (
    echo Waiting...
    goto wait_loop
)

echo ✅ LocalStack is ready!

REM Configure AWS CLI for LocalStack
echo 🔧 Configuring AWS CLI for LocalStack...
aws configure set aws_access_key_id giropops
aws configure set aws_secret_access_key stringus
aws configure set default.region us-east-1

REM Initialize and apply Terraform
echo 🏗️  Initializing Terraform...
npm run terraform:init

echo 📋 Planning Terraform deployment...
npm run terraform:plan

echo 🚀 Deploying infrastructure to LocalStack...
npm run terraform:apply

echo ✅ Setup complete! LocalStack is running at http://localhost:4566
echo 🔍 You can check the health status at: http://localhost:4566/_localstack/health
echo 📊 Use 'npm run localstack:logs' to see LocalStack logs
echo 🛑 Use 'npm run localstack:stop' to stop LocalStack
pause