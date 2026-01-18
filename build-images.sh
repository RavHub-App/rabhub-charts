#!/bin/bash
set -e

# Base dirs
CORE_DIR="ravhub-core"
ENT_DIR="ravhub-enterprise"
BUILD_DIR="build-enterprise"

echo "Building Community Image..."
docker build -t ravhub:community -f $CORE_DIR/Dockerfile.community $CORE_DIR

echo "Preparing Enterprise Build Context..."
rm -rf $BUILD_DIR
cp -r $CORE_DIR $BUILD_DIR

echo "Injecting Enterprise Modules..."

# 1. Backup Module -> src/modules/backup
# Create dir if not exists (it shouldn't in core, but backup dir might be missing)
mkdir -p $BUILD_DIR/apps/api/src/modules/backup
cp -r $ENT_DIR/modules/backup/* $BUILD_DIR/apps/api/src/modules/backup/

# 2. License Module -> src/modules/license (Overwrite Stub)
cp -r $ENT_DIR/modules/license/* $BUILD_DIR/apps/api/src/modules/license/

# 3. Plugins -> src/modules/plugins/impl
cp -r $ENT_DIR/modules/plugins/impl/* $BUILD_DIR/apps/api/src/modules/plugins/impl/

# 4. Storage Adapters -> src/enterprise/storage
mkdir -p $BUILD_DIR/apps/api/src/enterprise/storage
cp -r $ENT_DIR/modules/storage/* $BUILD_DIR/apps/api/src/enterprise/storage/

echo "Building Enterprise Image..."
docker build -t ravhub:enterprise -f $CORE_DIR/Dockerfile.enterprise $BUILD_DIR

rm -rf $BUILD_DIR
echo "Builds Complete."
echo "Images: ravhub:community, ravhub:enterprise"
