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

# Upload static files using Next.js build output
echo "📤 Uploading Next.js files to S3..."

# Check if Next.js build output exists
if [ ! -d "out" ]; then
    echo "❌ Next.js build output 'out' directory not found!"
    echo "💡 Make sure 'npm run build' completed successfully"
    echo "💡 Check if next.config.ts has 'output: export' configured"
    exit 1
fi

echo "✅ Found Next.js build output, proceeding with deployment..."
echo "📁 Files in out directory:"
ls -la out/ | head -10
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .tech-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid #e9ecef;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-style: italic;
        }
        .emoji {
            font-size: 1.5em;
        }
        .pipeline-info {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Verison DevOps One</h1>
        
        <div class="status">
            ✅ Deploy Automático Realizado via GitHub Actions!
        </div>

        <div class="pipeline-info">
            <h3>🔄 Pipeline Executada com Sucesso!</h3>
            <p>Este website foi deployado automaticamente através do GitHub Actions + LocalStack + Terraform.</p>
            <p><strong>🕐 Deployment Time:</strong> <span id="deployTime"></span></p>
        </div>
        
        <div class="info">
            <h3>📋 Informações do Deployment</h3>
            <ul>
                <li><strong>🌍 Ambiente:</strong> GitHub Actions + LocalStack</li>
                <li><strong>🪣 Bucket S3:</strong> verison-devos-one-website</li>  
                <li><strong>🌎 Região:</strong> us-east-1</li>
                <li><strong>🔗 Endpoint:</strong> http://localhost:4566</li>
                <li><strong>⚡ Framework:</strong> Next.js 16.1.6</li>
                <li><strong>🏗️ Infrastructure:</strong> Terraform</li>
                <li><strong>📅 Data:</strong> <span id="currentDate"></span></li>
            </ul>
        </div>

        <div class="info">
            <h3>🛠️ Stack Tecnológica</h3>
            <div class="tech-stack">
                <div class="tech-item">
                    <div class="emoji">⚡</div>
                    <strong>Next.js</strong><br>
                    React Framework
                </div>
                <div class="tech-item">
                    <div class="emoji">🐳</div>
                    <strong>LocalStack</strong><br>
                    AWS Local Emulation
                </div>
                <div class="tech-item">
                    <div class="emoji">🪣</div>
                    <strong>S3</strong><br>
                    Static Hosting
                </div>
                <div class="tech-item">
                    <div class="emoji">🏗️</div>
                    <strong>Terraform</strong><br>
                    Infrastructure as Code
                </div>
                <div class="tech-item">
                    <div class="emoji">🚀</div>
                    <strong>GitHub Actions</strong><br>
                    CI/CD Pipeline
                </div>
                <div class="tech-item">
                    <div class="emoji">🤖</div>
                    <strong>Automation</strong><br>
                    Zero Touch Deploy
                </div>
            </div>
        </div>

        <div class="info">
            <h3>🔗 Links Úteis</h3>
            <ul>
                <li><a href="http://localhost:4566/_localstack/health" target="_blank">🏥 LocalStack Health Check</a></li>
                <li><a href="http://localhost:4566/_localstack/cockpit" target="_blank">🎛️ LocalStack Dashboard</a></li>
                <li><a href="https://github.com/juliosergionovaesgomes/verison_devos_one" target="_blank">📂 Repository GitHub</a></li>
                <li><a href="https://github.com/juliosergionovaesgomes/verison_devos_one/actions" target="_blank">🔄 GitHub Actions</a></li>
            </ul>
        </div>

        <p style="text-align: center; font-size: 1.1em; margin: 30px 0;">
            🎉 Pipeline DevOps totalmente automatizada!<br>
            Deploy realizado sem intervenção manual. Zero-touch deployment! 🚀
        </p>

        <div class="footer">
            <p>Desenvolvido com ❤️ usando GitHub Actions + LocalStack + Next.js + Terraform</p>
            <p>🌟 Pipeline DevOps executada automaticamente!</p>
        </div>
    </div>

    <script>
        // Mostrar data e hora atual
        const now = new Date();
        document.getElementById('currentDate').textContent = now.toLocaleDateString('pt-BR');
        document.getElementById('deployTime').textContent = now.toLocaleString('pt-BR');
        
        // Animação simples
        document.querySelector('.container').style.animation = 'fadeIn 1s ease-in';
        
        // CSS da animação
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
EOF

# Upload all Next.js static export files
echo "📤 Syncing Next.js build to S3...
awslocal s3 sync out/ s3://verison-devos-one-website --endpoint-url=http://localhost:4566 --delete

echo "📊 Verifying uploaded files..."
awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566

echo "✅ Deployment complete!"
echo "🌐 Website URL: http://verison-devos-one-website.s3-website.us-east-1.localhost.localstack.cloud:4566"
echo "🔍 Check bucket contents: awslocal s3 ls s3://verison-devos-one-website --endpoint-url=http://localhost:4566"