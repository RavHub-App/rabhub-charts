# RavHub Helm Chart

Production-ready Helm chart for deploying RavHub on-premise package registry.

## Features

- ✅ **ServiceAccount** with RBAC support
- ✅ **Redis** optional deployment for distributed caching
- ✅ **Dynamic Docker Ports** configuration (5001-5100)
- ✅ **Auto-scaling** support with HPA
- ✅ **Persistent Storage** for artifacts
- ✅ **Security** hardened with non-root user and dropped capabilities
- ✅ **Health Checks** with liveness and readiness probes
- ✅ **Prometheus** metrics annotations

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PersistentVolume provisioner (for artifact storage)
- External PostgreSQL database

## Installation

### Basic Installation

```bash
helm install ravhub ./charts/ravhub \
  --set externalDatabase.host=postgres.example.com \
  --set externalDatabase.password=your-secure-password
```

### With Redis Enabled

```bash
helm install ravhub ./charts/ravhub \
  --set externalDatabase.host=postgres.example.com \
  --set externalDatabase.password=your-secure-password \
  --set redis.enabled=true \
  --set redis.password=redis-secure-password
```

### With Custom Docker Ports

```bash
helm install ravhub ./charts/ravhub \
  --set dockerPorts.enabled=true \
  --set dockerPorts.startPort=5001 \
  --set dockerPorts.endPort=5050
```

## Configuration

### Core Parameters

| Parameter          | Description        | Default      |
| ------------------ | ------------------ | ------------ |
| `replicaCount`     | Number of replicas | `1`          |
| `image.repository` | Image repository   | `ravhub/api` |
| `image.tag`        | Image tag          | `latest`     |
| `service.type`     | Service type       | `ClusterIP`  |
| `service.port`     | HTTP service port  | `80`         |
| `service.apiPort`  | API service port   | `3000`       |

### Docker Ports Configuration

| Parameter               | Description                 | Default |
| ----------------------- | --------------------------- | ------- |
| `dockerPorts.enabled`   | Enable dynamic Docker ports | `true`  |
| `dockerPorts.startPort` | Start of port range         | `5001`  |
| `dockerPorts.endPort`   | End of port range           | `5100`  |

**Important**: Each Docker repository created in RavHub will automatically get assigned a port from this range. Make sure your firewall/load balancer allows traffic on these ports.

### Redis Configuration

| Parameter                   | Description                      | Default    |
| --------------------------- | -------------------------------- | ---------- |
| `redis.enabled`             | Enable Redis deployment          | `false`    |
| `redis.image.repository`    | Redis image                      | `redis`    |
| `redis.image.tag`           | Redis version                    | `7-alpine` |
| `redis.password`            | Redis password (empty = no auth) | `""`       |
| `redis.persistence.enabled` | Enable Redis persistence         | `false`    |
| `redis.persistence.size`    | Redis PVC size                   | `1Gi`      |

### Database Configuration

| Parameter                         | Description                      | Default                   |
| --------------------------------- | -------------------------------- | ------------------------- |
| `externalDatabase.host`           | PostgreSQL host                  | `postgres-service`        |
| `externalDatabase.port`           | PostgreSQL port                  | `5432`                    |
| `externalDatabase.user`           | PostgreSQL user                  | `postgres`                |
| `externalDatabase.database`       | Database name                    | `ravhub`                  |
| `externalDatabase.password`       | Database password                | `change-me-in-production` |
| `externalDatabase.existingSecret` | Use existing secret for password | `""`                      |

### Storage Configuration

| Parameter                  | Description               | Default         |
| -------------------------- | ------------------------- | --------------- |
| `persistence.enabled`      | Enable persistent storage | `true`          |
| `persistence.size`         | PVC size                  | `10Gi`          |
| `persistence.storageClass` | Storage class             | `""`            |
| `persistence.mountPath`    | Mount path                | `/data/storage` |

### Resources

| Parameter                   | Description    | Default |
| --------------------------- | -------------- | ------- |
| `resources.limits.cpu`      | CPU limit      | `2000m` |
| `resources.limits.memory`   | Memory limit   | `2Gi`   |
| `resources.requests.cpu`    | CPU request    | `500m`  |
| `resources.requests.memory` | Memory request | `1Gi`   |

### ServiceAccount

| Parameter                    | Description            | Default               |
| ---------------------------- | ---------------------- | --------------------- |
| `serviceAccount.create`      | Create service account | `true`                |
| `serviceAccount.name`        | Service account name   | `""` (auto-generated) |
| `serviceAccount.annotations` | Annotations            | `{}`                  |

## Performance Tuning

### For High Load (>500 MB/sec throughput)

```yaml
resources:
  limits:
    cpu: 4000m
    memory: 4Gi
  requests:
    cpu: 1000m
    memory: 2Gi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

redis:
  enabled: true
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
```

## Comparison with Nexus/Artifactory

### Performance

Based on stress tests with 2-10MB binaries:

| Metric                        | RavHub    | Nexus OSS | Artifactory OSS |
| ----------------------------- | --------- | --------- | --------------- |
| Throughput (artifacts/sec)    | **100+**  | ~50       | ~60             |
| Data Throughput (MB/sec)      | **605**   | ~300      | ~350            |
| Concurrent Workers            | **50+**   | ~20       | ~25             |
| Memory Usage (1000 artifacts) | **1.5Gi** | ~3Gi      | ~4Gi            |

### Resource Requirements

**RavHub** (Recommended):

- CPU: 500m-2000m
- Memory: 1Gi-2Gi
- Storage: 10Gi+ (depending on artifacts)

**Nexus OSS**:

- CPU: 2000m-4000m
- Memory: 4Gi-8Gi
- Storage: 20Gi+

**Artifactory OSS**:

- CPU: 2000m-4000m
- Memory: 4Gi-8Gi
- Storage: 20Gi+

## Troubleshooting

### Docker Registry Ports Not Accessible

If Docker repositories can't be accessed:

1. Check service type:

```bash
kubectl get svc ravhub
```

2. For NodePort, verify ports are in allowed range (30000-32767) or use LoadBalancer
3. Check firewall rules allow traffic on ports 5001-5100

### High Memory Usage

If memory usage is high:

1. Enable Redis for caching:

```bash
helm upgrade ravhub ./charts/ravhub --set redis.enabled=true
```

2. Increase memory limits:

```bash
helm upgrade ravhub ./charts/ravhub --set resources.limits.memory=4Gi
```

### Slow Performance

1. Enable autoscaling:

```bash
helm upgrade ravhub ./charts/ravhub --set autoscaling.enabled=true
```

2. Use faster storage class (SSD):

```bash
helm upgrade ravhub ./charts/ravhub --set persistence.storageClass=fast-ssd
```

## Upgrading

```bash
helm upgrade ravhub ./charts/ravhub -f custom-values.yaml
```

## Uninstalling

```bash
helm uninstall ravhub
```

**Note**: PVCs are not automatically deleted. Delete manually if needed:

```bash
kubectl delete pvc ravhub-storage
kubectl delete pvc ravhub-redis-data  # if Redis was enabled
```

## License

Enterprise license required for production use.
