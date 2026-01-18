---
description: How to test the On-Premise Helm deployment locally using Minikube
---

This workflow guides you through deploying the application to a local Minikube cluster to verify the Helm chart and Kubernetes configuration.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed
- [Helm](https://helm.sh/docs/intro/install/) installed
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) installed

## Steps

1.  **Start Minikube**
    Start a local cluster. We give it enough resources for the app and database.

    ```bash
    minikube start --cpus 4 --memory 8192 --disk-size 20g
    ```

2.  **Enable Ingress Addon**
    The chart uses Ingress, so we need the controller.

    ```bash
    minikube addons enable ingress
    ```

3.  **Build Docker Images Directly in Minikube**
    Instead of pushing to a registry, we point our shell to Minikube's Docker daemon and build the images there.

    ```bash
    eval $(minikube docker-env)

    # Build API/Backend image
    docker build -t ravhub/api:latest -f Dockerfile .

    # (Optional) Build other images if needed, currently chart only uses ravhub/api
    ```

4.  **Prepare Helm Dependencies**
    We added `postgresql` as a dependency, so we need to download it.

    ```bash
    helm dependency update charts/ravhub
    ```

5.  **Create a Local Values File**
    Create a `values-minikube.yaml` to enable Postgres and configure the connection.

    ```yaml
    # values-minikube.yaml
    postgresql:
      enabled: true
      auth:
        postgresPassword: "password123"
        username: postgres
        database: ravhub

    externalDatabase:
      host: "ravhub-postgresql" # Default service name for subchart
      port: 5432
      user: postgres
      database: ravhub
      password: "password123"
      existingSecret: ""

    image:
      repository: ravhub/api
      tag: latest
      pullPolicy: Never # Important: Use local image we built

    persistence:
      enabled: true
      size: 1Gi
    ```

6.  **Install the Chart**

    ```bash
    helm install ravhub charts/ravhub -f values-minikube.yaml
    ```

7.  **Verify Deployment**
    Check if pods are running.

    ```bash
    kubectl get pods -w
    ```

8.  **Access the Application**
    Since we are using Ingress, we need to map the host.

    ```bash
    # Get Minikube IP
    echo "$(minikube ip) ravhub.local" | sudo tee -a /etc/hosts
    ```

    Then access http://ravhub.local in your browser.

9.  **Cleanup**
    ```bash
    helm uninstall ravhub
    minikube stop
    ```
