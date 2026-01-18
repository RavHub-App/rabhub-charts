---
description: How to test enterprise storage integrations (Azure/GCS) locally
---

This workflow sets up local emulators for Azure Blob Storage (Azurite) and Google Cloud Storage (fake-gcs-server) and runs a test script to verify that the application adapters work correctly.

1.  **Install dependencies (if not already installed):**
    These packages are required for the enterprise adapters.

    ```bash
    cd apps/api
    pnpm add @azure/storage-blob @google-cloud/storage
    ```

2.  **Start the local emulators:**
    This runs Azurite (Azure) on ports 10000-10002 and fake-gcs-server (GCS) on port 4443.

    ```bash
    docker compose -f docker-compose.enterprise-test.yml up -d --wait
    ```

3.  **Run the integration test script:**
    This runs a comprehensive test suite that connects to the local emulators.
    - **Azure:** Tests container creation, blob upload, existence check, URL generation, and streaming.
    - **GCS:** Tests bucket creation, object upload, and streaming. **Note:** Local GCS existence checks may fail due to emulator limitations, but upload/stream are verified.

    ```bash
    cd apps/api
    npx ts-node test/storage/test-enterprise-local.ts
    ```

4.  **Cleanup:**
    When finished, stop the emulator containers.

    ```bash
    docker compose -f docker-compose.enterprise-test.yml down
    ```
