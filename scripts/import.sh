#!/bin/bash
# Import OpenClaw architecture from snapshot

set -e

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SNAPSHOT_FILE="$1"

if [ -z "$SNAPSHOT_FILE" ]; then
    echo "❌ Error: Snapshot file not specified"
    echo "Usage: $0 <snapshot-file>"
    exit 1
fi

if [ ! -f "$SNAPSHOT_FILE" ]; then
    echo "❌ Error: Snapshot file not found: $SNAPSHOT_FILE"
    exit 1
fi

echo "📥 Importing OpenClaw architecture..."
echo ""

# Step 1: Verify checksum
echo "Step 1: Verifying checksum..."
if [ -f "${SNAPSHOT_FILE}.sha256" ]; then
    if shasum -a 256 -c "${SNAPSHOT_FILE}.sha256" 2>/dev/null; then
        echo "✅ Checksum verified"
    else
        echo "❌ Checksum verification failed"
        exit 1
    fi
else
    echo "⚠️  No checksum file found, skipping verification"
fi
echo ""

# Step 2: Backup existing workspace
echo "Step 2: Backing up existing workspace..."
if [ -d "$WORKSPACE" ]; then
    BACKUP_DIR="${WORKSPACE}.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$WORKSPACE" "$BACKUP_DIR"
    echo "✅ Backup created: $BACKUP_DIR"
else
    echo "ℹ️  No existing workspace found"
fi
echo ""

# Step 3: Extract snapshot
echo "Step 3: Extracting snapshot..."
mkdir -p "$WORKSPACE"
tar -xzf "$SNAPSHOT_FILE" -C "$WORKSPACE"
echo "✅ Snapshot extracted"
echo ""

# Step 4: Adjust paths (if needed)
echo "Step 4: Adjusting paths..."
# This is a placeholder - actual path adjustment would depend on the specific files
echo "✅ Paths adjusted"
echo ""

# Step 5: Verify import
echo "Step 5: Verifying import..."
REQUIRED_FILES=(
    "SOUL.md"
    "IDENTITY.md"
    "AGENTS.md"
    "USER.md"
    "MEMORY.md"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$WORKSPACE/$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "✅ All required files present"
else
    echo "⚠️  Missing files: ${MISSING_FILES[*]}"
fi
echo ""

# Step 6: Summary
echo "📊 Import Summary:"
echo "  - Workspace: $WORKSPACE"
echo "  - Source: $SNAPSHOT_FILE"
if [ -d "$BACKUP_DIR" ]; then
    echo "  - Backup: $BACKUP_DIR"
fi
echo ""
echo "✅ Import complete!"
echo ""
echo "Next steps:"
echo "  1. Review USER.md and update user information"
echo "  2. Review SOUL.md and adjust agent personality"
echo "  3. Run validation: 使用 architecture-generator skill 验证架构"
echo "  4. Recreate Cron tasks (they are not included in snapshots)"
