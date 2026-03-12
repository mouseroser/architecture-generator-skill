#!/bin/bash
# Upgrade OpenClaw architecture to latest version

set -e

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
TARGET_VERSION="${1:-2.6}"

echo "🚀 Upgrading OpenClaw architecture to v${TARGET_VERSION}..."
echo ""

# Step 1: Detect current version
echo "Step 1: Detecting current version..."
if [ -f "$WORKSPACE/AGENTS.md" ]; then
    CURRENT_VERSION=$(grep "星链流水线 v" "$WORKSPACE/AGENTS.md" 2>/dev/null | head -1 | sed 's/.*v\([0-9.]*\).*/\1/' || echo "unknown")
    echo "✅ Current version: v${CURRENT_VERSION}"
else
    echo "❌ AGENTS.md not found, cannot detect version"
    exit 1
fi
echo ""

# Step 2: Backup current architecture
echo "Step 2: Backing up current architecture..."
BACKUP_SCRIPT="$WORKSPACE/skills/architecture-generator/scripts/export.sh"
if [ -f "$BACKUP_SCRIPT" ]; then
    bash "$BACKUP_SCRIPT"
    echo "✅ Backup complete"
else
    echo "⚠️  Export script not found, skipping backup"
fi
echo ""

# Step 3: Execute upgrade
echo "Step 3: Executing upgrade from v${CURRENT_VERSION} to v${TARGET_VERSION}..."

case "${CURRENT_VERSION}->${TARGET_VERSION}" in
    "2.5->2.6")
        echo "Upgrading from v2.5 to v2.6..."
        
        # Update review agent (no longer orchestrates)
        if [ -f "$WORKSPACE/agents/review/SOUL.md" ]; then
            echo "  - Updating review agent configuration..."
            # Add constraint about not orchestrating
            if ! grep -q "绝不编排其他 agent" "$WORKSPACE/agents/review/SOUL.md"; then
                echo "" >> "$WORKSPACE/agents/review/SOUL.md"
                echo "## 硬性约束（v2.6）" >> "$WORKSPACE/agents/review/SOUL.md"
                echo "- **绝不编排其他 agent** — Review 只执行审查，所有编排由 main 负责" >> "$WORKSPACE/agents/review/SOUL.md"
            fi
        fi
        
        # Update AGENTS.md
        if [ -f "$WORKSPACE/AGENTS.md" ]; then
            echo "  - Updating AGENTS.md..."
            sed -i.bak 's/星链流水线 v2.5/星链流水线 v2.6/g' "$WORKSPACE/AGENTS.md"
        fi
        
        # Update FEEDBACK-LOG.md
        if [ -f "$WORKSPACE/shared-context/FEEDBACK-LOG.md" ]; then
            echo "  - Updating FEEDBACK-LOG.md..."
            if ! grep -q "Review 不应编排其他 agent" "$WORKSPACE/shared-context/FEEDBACK-LOG.md"; then
                echo "" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
                echo "### $(date +%Y-%m-%d) Review 不应编排其他 agent (v2.6)" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
                echo "- **问题**: Review 编排 coding/test/gemini，导致 mode=run 轮次限制" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
                echo "- **影响**: review agent" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
                echo "- **纠正**: Review 只执行审查，所有编排由 main 负责（v2.6 架构）" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
                echo "- **状态**: ✅ 已修复" >> "$WORKSPACE/shared-context/FEEDBACK-LOG.md"
            fi
        fi
        
        echo "✅ Upgrade to v2.6 complete"
        ;;
        
    "2.4->2.6"|"2.3->2.6")
        echo "⚠️  Multi-version upgrade not yet implemented"
        echo "Please upgrade to v2.5 first, then to v2.6"
        exit 1
        ;;
        
    *)
        echo "❌ Unsupported upgrade path: v${CURRENT_VERSION} -> v${TARGET_VERSION}"
        exit 1
        ;;
esac
echo ""

# Step 4: Verify upgrade
echo "Step 4: Verifying upgrade..."
NEW_VERSION=$(grep "星链流水线 v" "$WORKSPACE/AGENTS.md" 2>/dev/null | head -1 | sed 's/.*v\([0-9.]*\).*/\1/' || echo "unknown")
if [ "$NEW_VERSION" = "$TARGET_VERSION" ]; then
    echo "✅ Version updated to v${NEW_VERSION}"
else
    echo "⚠️  Version mismatch: expected v${TARGET_VERSION}, got v${NEW_VERSION}"
fi
echo ""

# Step 5: Summary
echo "📊 Upgrade Summary:"
echo "  - From: v${CURRENT_VERSION}"
echo "  - To: v${NEW_VERSION}"
echo "  - Workspace: $WORKSPACE"
echo ""
echo "✅ Upgrade complete!"
echo ""
echo "Next steps:"
echo "  1. Run validation: 使用 architecture-generator skill 验证架构"
echo "  2. Test all agents to ensure they work correctly"
echo "  3. Review FEEDBACK-LOG.md for new guidelines"
