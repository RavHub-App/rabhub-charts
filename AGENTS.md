---
id: ravhub-charts-agent
role: DevOps Engineer
stack:
  - Helm
  - Kubernetes
  - Bitnami Charts
deployment_targets:
  - "minikube"
  - "eks"
  - "gke"
variables:
  - "global.imageRegistry"
  - "license.enabled"
coding_standards:
  - "No redundant comments; variable names/values must be descriptive."
  - "Strict adherence to DRY (Don't Repeat Yourself) in templates."
  - "Small, focused templates."
  - "Package Management: Use pnpm instead of npm for all commands"
---

# 📂 RavHub Helm Context

## 📍 Scope

Official Helm Chart for deploying RavHub to Kubernetes.
Supports **Community** & **Enterprise** via toggles.

## ⚙️ Configuration Logic

### Edition Switching

Controlled by `license.enabled`:

- `false` (Default): Deploys `ravhub/api`.
- `true`: Deploys `ravhub/enterprise-api`. Requires `license.key`.

### Scalability (HA)

To enable `replicaCount > 1`:

1. **Redis**: Must be enabled (internal/external).
2. **Storage**: Must switch to S3/GCS or ReadWriteMany PVC.

## 🚀 Deployment Checklist

1. **Secrets**: Use `existingSecret` in production.
2. **Ingress**: Ensure `proxy-body-size: 0` for Docker uploads.
3. **Resources**: Set limits to avoid OOMKilled on buffer operations.

## 🧑‍💻 Coding Standards (Local)

1. **Helm Templates**: Keep templates simple. Use `_helpers.tpl` for complex logic.
2. **Readability**: Indent correctly. No comment clutter in `values.yaml`.
3. **License Protocol (Apache-2.0)**: Ensure every file starts with the Apache-2.0 header. Use `scripts/add-headers.js` to enforce.

---

_Use `helm template .` to validate manifest changes._
