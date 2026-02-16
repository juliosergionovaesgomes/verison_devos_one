#!/bin/bash

# Deploy Script para LocalStack S3 usando Next.js Static Export
set -e

BUCKET_NAME="verison-devos-one-website"
BUILD_DIR="out"
ENDPOINT_URL="http://localhost:4566"

echo "🚀 Iniciando deploy do Next.js para LocalStack S3..."
echo "📦 Bucket: $BUCKET_NAME"
echo "📁 Build directory: $BUILD_DIR"
echo "🌐 Endpoint: $ENDPOINT_URL"

# Fazer o build do Next.js primeiro
echo "🔨 Fazendo build do Next.js (static export)..."
if [ ! -f "package.json" ]; then
    echo "❌ Arquivo package.json não encontrado!"
    echo "💡 Execute este script do diretório raiz do projeto Next.js"
    exit 1
fi

npm run build

# Verificar se o diretório de build foi criado
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Diretório de build '$BUILD_DIR' não foi criado!"
    echo "💡 Verifique se next.config.ts tem 'output: export' configurado"
    exit 1
fi

# Configurar AWS CLI para LocalStack
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"

echo "🔍 Verificando status do LocalStack..."

# Verificar LocalStack health
if curl -s "$ENDPOINT_URL/_localstack/health" | grep -q "running"; then
    echo "✅ LocalStack está funcionando!"
else
    echo "❌ LocalStack não está respondendo em $ENDPOINT_URL"
    echo "💡 Inicie o LocalStack primeiro: npm run localstack:start"
    exit 1
fi

echo "🪣 Criando bucket S3 (se não existir)..."

# Criar bucket se não existir
aws s3 mb s3://$BUCKET_NAME --endpoint-url=$ENDPOINT_URL 2>/dev/null || echo "📦 Bucket já existe ou foi criado."

echo "⚙️ Configurando website hosting..."

# Configurar website hosting
aws s3 website s3://$BUCKET_NAME --index-document index.html --error-document 404.html --endpoint-url=$ENDPOINT_URL

echo "📤 Fazendo upload dos arquivos do Next.js..."

# Upload todos os arquivos da pasta out
aws s3 sync $BUILD_DIR/ s3://$BUCKET_NAME --endpoint-url=$ENDPOINT_URL --delete

echo "🔗 URLs do website:"
echo "📍 LocalStack S3 Website: http://$BUCKET_NAME.s3-website.us-east-1.localhost.localstack.cloud:4566"
echo "📍 LocalStack S3 Direct: $ENDPOINT_URL/$BUCKET_NAME/index.html"

echo "🏥 Verificando status do website..."

# Verificar se o site está acessível
WEBSITE_URL="http://$BUCKET_NAME.s3-website.us-east-1.localhost.localstack.cloud:4566"
if curl -s --head "$WEBSITE_URL" | head -n 1 | grep -q "200 OK"; then
    echo "✅ Website acessível em: $WEBSITE_URL"
else
    echo "⚠️  Website pode demorar alguns segundos para ficar disponível"
    echo "🔗 Tente acessar: $WEBSITE_URL"
fi

echo ""
echo "🎉 Deploy do Next.js concluído com sucesso!"
echo "🌟 Sua aplicação Next.js está rodando em LocalStack S3!"
echo "📊 Arquivos deployados:"
find $BUILD_DIR -type f | head -10