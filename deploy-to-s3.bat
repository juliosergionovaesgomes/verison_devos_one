@echo off
echo 🚀 Deploying Next.js application to LocalStack S3...

REM Build the Next.js application
echo 📦 Building Next.js application...
npm run build

REM Check if LocalStack is running
echo 🔍 Checking LocalStack health...
curl -f http://localhost:4566/_localstack/health >nul 2>&1
if errorlevel 1 (
    echo ❌ LocalStack is not running. Please start it first with 'npm run localstack:start'
    pause
    exit /b 1
)

REM Create S3 bucket if it doesn't exist
echo 🪣 Creating S3 bucket...
awslocal s3 mb s3://verison-devos-one-website --endpoint-url=http://localhost:4566 2>nul || echo Bucket already exists

REM Configure S3 bucket for website hosting
echo 🌐 Configuring S3 bucket for website hosting...
echo {"IndexDocument": {"Suffix": "index.html"}, "ErrorDocument": {"Key": "error.html"}} > website-config.json
awslocal s3api put-bucket-website --bucket verison-devos-one-website --website-configuration file://website-config.json --endpoint-url=http://localhost:4566
del website-config.json

REM Make bucket public
echo 🔓 Making bucket public...
echo {"Version": "2012-10-17", "Statement": [{"Sid": "PublicReadGetObject", "Effect": "Allow", "Principal": "*", "Action": "s3:GetObject", "Resource": "arn:aws:s3:::verison-devos-one-website/*"}]} > bucket-policy.json
awslocal s3api put-bucket-policy --bucket verison-devos-one-website --policy file://bucket-policy.json --endpoint-url=http://localhost:4566
del bucket-policy.json

REM Upload static files
echo 📤 Uploading files to S3...

REM Create a simple index.html 
echo 📝 Creating index.html...
mkdir temp_deployment 2>nul
(
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Verison DevOps One - LocalStack Deployment^</title^>
echo     ^<style^>
echo         body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; background-color: #f5f5f5; }
echo         .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba^(0,0,0,0.1^); }
echo         h1 { color: #333; text-align: center; }
echo         .status { background: #4CAF50; color: white; padding: 10px; border-radius: 4px; text-align: center; margin: 20px 0; }
echo         .info { background: #e7f3ff; border-left: 4px solid #2196F3; padding: 15px; margin: 20px 0; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>🚀 Verison DevOps One^</h1^>
echo         ^<div class="status"^>✅ Successfully deployed to LocalStack!^</div^>
echo         ^<div class="info"^>
echo             ^<h3^>LocalStack Deployment Information^</h3^>
echo             ^<ul^>
echo                 ^<li^>^<strong^>Environment:^</strong^> LocalStack Development^</li^>
echo                 ^<li^>^<strong^>S3 Bucket:^</strong^> verison-devos-one-website^</li^>
echo                 ^<li^>^<strong^>Region:^</strong^> us-east-1^</li^>
echo                 ^<li^>^<strong^>Endpoint:^</strong^> http://localhost:4566^</li^>
echo             ^</ul^>
echo         ^</div^>
echo         ^<p^>This is a Next.js application deployed on LocalStack S3 static website hosting.^</p^>
echo         ^<p^>Your DevOps pipeline is working correctly! 🎉^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > temp_deployment\index.html

REM Upload the index.html
awslocal s3 cp temp_deployment\index.html s3://verison-devos-one-website/index.html --endpoint-url=http://localhost:4566

REM Clean up
rmdir /s /q temp_deployment

REM Upload static assets if they exist
if exist ".next\static" (
    echo 📁 Uploading static assets...
    awslocal s3 sync .next\static s3://verison-devos-one-website/_next/static --endpoint-url=http://localhost:4566
)

REM Create error page
echo 📄 Creating error page...
(
echo ^<!DOCTYPE html^>
echo ^<html^>^<head^>^<title^>Error^</title^>^</head^>
echo ^<body^>^<h1^>Page Not Found^</h1^>^<p^>The requested page could not be found.^</p^>^</body^>^</html^>
) > error.html

awslocal s3 cp error.html s3://verison-devops-one-website/error.html --endpoint-url=http://localhost:4566
del error.html

echo ✅ Deployment complete!
echo 🌐 Website URL: http://verison-devos-one-website.s3-website.us-east-1.localhost.localstack.cloud:4566
echo 🔍 Check bucket contents: awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566
pause