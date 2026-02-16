@echo off
REM Deploy Script para LocalStack S3 usando Next.js Static Export

set BUCKET_NAME=verison-devos-one-website
set BUILD_DIR=out
set ENDPOINT_URL=http://localhost:4566

echo 🚀 Iniciando deploy do Next.js para LocalStack S3...
echo 📦 Bucket: %BUCKET_NAME%
echo 📁 Build directory: %BUILD_DIR%
echo 🌐 Endpoint: %ENDPOINT_URL%

REM Fazer o build do Next.js primeiro
echo 🔨 Fazendo build do Next.js (static export)...
if not exist "package.json" (
    echo ❌ Arquivo package.json não encontrado!
    echo 💡 Execute este script do diretório raiz do projeto Next.js
    pause
    exit /b 1
)

call npm run build

REM Verificar se o diretório de build foi criado
if not exist "%BUILD_DIR%" (
    echo ❌ Diretório de build '%BUILD_DIR%' não foi criado!
    echo 💡 Verifique se next.config.ts tem 'output: export' configurado
    pause
    exit /b 1
)

REM Configurar AWS CLI para LocalStack
set AWS_ACCESS_KEY_ID=test
set AWS_SECRET_ACCESS_KEY=test
set AWS_DEFAULT_REGION=us-east-1

echo 🔍 Verificando status do LocalStack...

REM Verificar LocalStack health usando PowerShell
powershell -Command "try { $response = Invoke-WebRequest -Uri '%ENDPOINT_URL%/_localstack/health' -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host '✅ LocalStack está funcionando!' } } catch { Write-Host '❌ LocalStack não está respondendo'; Write-Host '💡 Inicie o LocalStack primeiro: npm run localstack:start'; exit 1 }"

echo 🪣 Criando bucket S3 (se não existir)...

REM Criar bucket se não existir
aws s3 mb s3://%BUCKET_NAME% --endpoint-url=%ENDPOINT_URL% 2>nul || echo 📦 Bucket já existe ou foi criado.

echo ⚙️ Configurando website hosting...

REM Configurar website hosting
aws s3 website s3://%BUCKET_NAME% --index-document index.html --error-document 404.html --endpoint-url=%ENDPOINT_URL%

echo 📤 Fazendo upload dos arquivos do Next.js...

REM Upload todos os arquivos da pasta out com encoding correto
echo 📤 Fazendo upload dos arquivos do Next.js com UTF-8...

REM Upload HTML files with proper Content-Type
aws s3 sync %BUILD_DIR%/ s3://%BUCKET_NAME% --delete --endpoint-url=%ENDPOINT_URL% --exclude "*" --include "*.html" --content-type "text/html; charset=utf-8"

REM Upload other assets
aws s3 sync %BUILD_DIR%/ s3://%BUCKET_NAME% --delete --endpoint-url=%ENDPOINT_URL% --exclude "*.html"

echo 🔗 URLs do website:
echo 📍 LocalStack S3 Website: http://%BUCKET_NAME%.s3-website.us-east-1.localhost.localstack.cloud:4566
echo 📍 LocalStack S3 Direct: %ENDPOINT_URL%/%BUCKET_NAME%/index.html

echo 🏥 Verificando status do website...

REM Verificar se o site está acessível usando PowerShell
set WEBSITE_URL=http://%BUCKET_NAME%.s3-website.us-east-1.localhost.localstack.cloud:4566
powershell -Command "try { $response = Invoke-WebRequest -Uri '%WEBSITE_URL%' -UseBasicParsing -Method Head; if ($response.StatusCode -eq 200) { Write-Host '✅ Website acessível em: %WEBSITE_URL%' } } catch { Write-Host '⚠️ Website pode demorar alguns segundos para ficar disponível'; Write-Host '🔗 Tente acessar: %WEBSITE_URL%' }"

echo.
echo 🎉 Deploy do Next.js concluído com sucesso!
echo 🌟 Sua aplicação Next.js está rodando em LocalStack S3!
echo 📊 Arquivos deployados:
dir /b %BUILD_DIR% | findstr /v /c:"."

echo.
echo 💡 Para testar localmente, acesse: %WEBSITE_URL%
pause