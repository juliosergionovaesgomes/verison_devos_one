# verison_devos_one
Deploy first

## 🚀 LocalStack DevOps Setup

This project is configured to use LocalStack for local AWS service emulation, allowing you to develop and test your infrastructure without connecting to real AWS services.

### Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Node.js 20+
- Python 3.11+
- AWS CLI
- Terraform

### Quick Start

#### Option 1: Automated Setup (Recommended)

**Windows:**
```bash
setup-localstack.bat
```

**Linux/Mac:**
```bash
chmod +x setup-localstack.sh
./setup-localstack.sh
```

#### Option 2: Manual Setup

1. **Start LocalStack:**
   ```bash
   npm run localstack:start
   ```

2. **Install LocalStack CLI and AWS Local:**
   ```bash
   pip install localstack awscli-local
   ```

3. **Configure AWS CLI for LocalStack:**
   ```bash
   aws configure set aws_access_key_id giropops
   aws configure set aws_secret_access_key stringus
   aws configure set default.region us-east-1
   ```

4. **Deploy Infrastructure:**
   ```bash
   npm run terraform:init
   npm run terraform:plan
   npm run terraform:apply
   ```

5. **Build and Start the Application:**
   ```bash
   npm install
   npm run build
   npm run dev
   ```

### Available Scripts

| Command | Description |
|---------|-------------|
| `npm run localstack:start` | Start LocalStack container |
| `npm run localstack:stop` | Stop LocalStack container |
| `npm run localstack:logs` | View LocalStack logs |
| `npm run terraform:init` | Initialize Terraform |
| `npm run terraform:plan` | Plan Terraform deployment |
| `npm run terraform:apply` | Apply Terraform changes |
| `npm run terraform:destroy` | Destroy Terraform infrastructure |
| `npm run deploy:local` | Full local deployment (LocalStack + Terraform + Build) |

### LocalStack Services

LocalStack is configured to emulate the following AWS services:
- **ECR** - Elastic Container Registry
- **ECS** - Elastic Container Service
- **IAM** - Identity and Access Management
- **EC2** - Elastic Compute Cloud
- **VPC** - Virtual Private Cloud

### Accessing LocalStack

- **Main Endpoint:** http://localhost:4566
- **Health Check:** http://localhost:4566/_localstack/health
- **Web UI:** http://localhost:4566/_localstack/cockpit (Pro version)

### Useful Commands

**Check LocalStack Status:**
```bash
curl http://localhost:4566/_localstack/health
```

**List Resources with AWS Local:**
```bash
awslocal s3 ls                    # List S3 buckets
awslocal ecr describe-repositories # List ECR repositories
awslocal ecs list-clusters        # List ECS clusters
```

### CI/CD with GitHub Actions

The project includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) that:
1. Starts LocalStack as a service
2. Installs dependencies and tools
3. Deploys Terraform infrastructure
4. Builds the Next.js application
5. Verifies deployment

### Troubleshooting

**LocalStack not starting:**
- Ensure Docker is running
- Check if port 4566 is available
- Review logs with `npm run localstack:logs`

**Terraform errors:**
- Verify LocalStack is healthy: `curl http://localhost:4566/_localstack/health`
- Check AWS CLI configuration
- Ensure proper environment variables are set

**Permission issues (Linux/Mac):**
```bash
chmod +x setup-localstack.sh
```

### Configuration

The project uses the following configuration:
- **AWS Region:** us-east-1
- **LocalStack Endpoint:** http://localhost:4566
- **Dummy Credentials:** Access Key: `giropops`, Secret Key: `stringus`

> **Note:** These are dummy credentials safe for LocalStack. Never use real AWS credentials in development.
