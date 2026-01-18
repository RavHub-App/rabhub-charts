---
description: How to test S3 integrations locally using MinIO
---

This workflow sets up a local MinIO instance (S3 compatible) and runs a script to verify that the application's S3 storage adapter can successfully communicate with it.

1. **Start the local S3 (MinIO) service:**
   This uses a dedicated docker-compose file to avoid conflicts with your main development environment. It runs MinIO on ports 9900 (API) and 9901 (Console).

   ```bash
   docker compose -f docker-compose.s3-test.yml up -d --wait
   ```

2. **Run the integration test script:**
   This script executes standard storage operations (Save, Exists, Get, List, Stream) against the local MinIO bucket.

   ```bash
   cd apps/api
   npx ts-node test/storage/test-s3-local.ts
   ```

3. **(Optional) View MinIO Console:**
   You can access the MinIO console at [http://localhost:9901](http://localhost:9901).
   - User: `admin`
   - Password: `password`

4. **Cleanup:**
   When finished, stop the containers.

   ```bash
   docker compose -f docker-compose.s3-test.yml down
   ```
