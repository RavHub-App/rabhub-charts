# Testing RavHub (Open Core)

This guide details how to verify both Community and Enterprise editions locally using Docker Compose and Minikube.

## Prerequisites

- Docker
- Docker Compose
- Minikube
- Helm
- kubectl

## 1. Build Images

First, build both editions using the provided script. This script prepares the source code for each edition and builds the Docker images.

```bash
./build-images.sh
```

This will produce two local images:

- `ravhub:community`
- `ravhub:enterprise`

## 2. Testing with Docker Compose

We provide a `docker-compose.test.yaml` for quick local verification.

### Test Community Edition

Features:

- **Enabled**: NPM, Maven, Docker, PyPI repositories. Local Storage.
- **Disabled**: NuGet, Composer, Helm, Rust, Raw. Cloud Storage (S3/GCS/Azure). Backups.

```bash
# Start Community
export RAVHUB_IMAGE=ravhub:community
export RAVHUB_EDITION=community
docker-compose -f docker-compose.test.yaml up -d

# Verify
# UI: http://localhost:8080
# Login: admin / admin123 (if seeded) or check logs for initial setup
docker-compose -f docker-compose.test.yaml logs -f ravhub
```

Clean up:

```bash
docker-compose -f docker-compose.test.yaml down -v
```

### Test Enterprise Edition

Features:

- **Enabled**: All Repository Types (including NuGet, etc). Backups. Use `loadEnterpriseDriver` for storage.
- **Requires License**: Some features may be locked until a license key is provided (mock or real).

```bash
# Start Enterprise
export RAVHUB_IMAGE=ravhub:enterprise
export RAVHUB_EDITION=enterprise
docker-compose -f docker-compose.test.yaml up -d
```

## 3. Testing with Minikube (Helm)

The unified Helm chart is located in `ravhub-charts/ravhub`.

### Setup Minikube

```bash
minikube start
eval $(minikube docker-env)  # Point your terminal to Minikube's Docker daemon
```

_Note: If you run `build-images.sh` AFTER this command, the images will be built directly inside Minikube. If you built them on host, verify with `minikube image load ravhub:community ravhub:enterprise`._

### Deploy Community

```bash
helm install ravhub-community ./ravhub-charts/ravhub \
  --set image.repository=ravhub \
  --set image.tag=community \
  --set image.pullPolicy=Never \
  --set global.edition=community
```

Verify pods are running:

```bash
kubectl get pods
```

### Deploy Enterprise

```bash
helm install ravhub-enterprise ./ravhub-charts/ravhub \
  --set image.repository=ravhub \
  --set image.tag=enterprise \
  --set image.pullPolicy=Never \
  --set global.edition=enterprise \
  --set license.enabled=true \
  --set license.key="YOUR_LICENSE_KEY"
```

To expose the service:

```bash
minikube service ravhub-community-ravhub --url
```
