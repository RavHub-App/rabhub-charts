# 📦 RavHub Parent Repository

This is the meta-repository for the RavHub ecosystem. It connects all component repositories using Git Submodules.

## 🗂️ Project Structure

| Component          | Repository                                         | Description                                | License     |
| ------------------ | -------------------------------------------------- | ------------------------------------------ | ----------- |
| **Core**           | [`ravhub-core`](./ravhub-core)                     | The open-source artifacts registry engine. | AGPL-3.0    |
| **Enterprise**     | [`ravhub-enterprise`](./ravhub-enterprise)         | Proprietary extensions (S3, Backup, etc.). | Proprietary |
| **License Portal** | [`ravhub-license-portal`](./ravhub-license-portal) | SaaS control plane & billing.              | Proprietary |
| **Charts**         | [`ravhub-charts`](./ravhub-charts)                 | Helm charts for Kubernetes deployment.     | Apache-2.0  |

## 🚀 Getting Started

To clone the entire project including all submodules:

```bash
git clone --recursive git@github.com:RavHub-App/ravhub-parent.git
cd ravhub-parent
```

If you already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```
