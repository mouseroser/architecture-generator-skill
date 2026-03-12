#!/bin/bash
# Export OpenClaw architecture to snapshot

set -e

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SNAPSHOT_DIR="${SNAPSHOT_DIR:-$HOME/.openclaw/snapshots}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SNAPSHOT_NAME="architecture-${TIMESTAMP}"
SNAPSHOT_FILE="${SNAPSHOT_DIR}/${SNAPSHOT_NAME}.tar.gz"

# Create snapshot directory
mkdir -p "$SNAPSHOT_DIR"

echo "📦 Exporting OpenClaw architecture..."
echo ""

# Step 1: Collect architecture info
echo "Step 1: Collecting architecture info..."
VERSION=$(grep "星链流水线 v" "$WORKSPACE/AGENTS.md" 2>/dev/null | head -1 | sed 's/.*v\([0-9.]*\).*/\1/' || echo "unknown")
AGENT_COUNT=$(find "$WORKSPACE/agents" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")

cat > "${SNAPSHOT_DIR}/${SNAPSHOT_NAME}.json" <<EOF
{
  "snapshot_id": "${SNAPSHOT_NAME}",
  "version": "${VERSION}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "workspace": "${WORKSPACE}",
  "agent_count": ${AGENT_COUNT}
}
EOF

echo "✅ Architecture info collected"
echo ""

# Step 2: Create tarball (exclude large files)
echo "Step 2: Creating snapshot tarball..."
tar -czf "$SNAPSHOT_FILE" \
  -C "$WORKSPACE" \
  --exclude='memory/202*.md' \
  --exclude='memory/archive/*' \
  --exclude='memory/*.md' \
  --exclude='.git' \
  --exclude='node_modules' \
  . 2>/dev/null || true

echo "✅ Snapshot created: $SNAPSHOT_FILE"
echo ""

# Step 3: Generate checksum
echo "Step 3: Generating checksum..."
CHECKSUM=$(shasum -a 256 "$SNAPSHOT_FILE" | cut -d' ' -f1)
echo "$CHECKSUM  $SNAPSHOT_FILE" > "${SNAPSHOT_FILE}.sha256"
echo "✅ Checksum: $CHECKSUM"
echo ""

# Step 4: Get file info
FILE_SIZE=$(du -h "$SNAPSHOT_FILE" | cut -f1)
FILE_COUNT=$(tar -tzf "$SNAPSHOT_FILE" 2>/dev/null | wc -l || echo "0")

# Step 5: Update metadata
cat > "${SNAPSHOT_DIR}/${SNAPSHOT_NAME}.json" <<EOF
{
  "snapshot_id": "${SNAPSHOT_NAME}",
  "version": "${VERSION}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "workspace": "${WORKSPACE}",
  "agent_count": ${AGENT_COUNT},
  "file_count": ${FILE_COUNT},
  "size": "${FILE_SIZE}",
  "checksum": "${CHECKSUM}"
}
EOF

echo "📊 Export Summary:"
echo "  - Snapshot ID: ${SNAPSHOT_NAME}"
echo "  - Version: ${VERSION}"
echo "  - Agent Count: ${AGENT_COUNT}"
echo "  - File Count: ${FILE_COUNT}"
echo "  - Size: ${FILE_SIZE}"
echo "  - Checksum: ${CHECKSUM}"
echo ""
echo "✅ Export complete!"
echo ""
echo "Snapshot saved to:"
echo "  ${SNAPSHOT_FILE}"
echo "  ${SNAPSHOT_FILE}.sha256"
echo "  ${SNAPSHOT_DIR}/${SNAPSHOT_NAME}.json"
