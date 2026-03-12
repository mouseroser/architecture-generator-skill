#!/bin/bash
# Apply architecture template

set -e

SKILL_DIR="$HOME/.openclaw/workspace/skills/architecture-generator"
TEMPLATE_NAME="${1:-standard}"
TEMPLATE_DIR="$SKILL_DIR/templates/$TEMPLATE_NAME"
WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "❌ Error: Template not found: $TEMPLATE_NAME"
    echo ""
    echo "Available templates:"
    ls -1 "$SKILL_DIR/templates/" 2>/dev/null || echo "  (none)"
    exit 1
fi

if [ ! -f "$TEMPLATE_DIR/config.json" ]; then
    echo "❌ Error: Template config not found: $TEMPLATE_DIR/config.json"
    exit 1
fi

echo "📋 Applying template: $TEMPLATE_NAME"
echo ""

# Step 1: Load template config
echo "Step 1: Loading template configuration..."
TEMPLATE_VERSION=$(jq -r '.version' "$TEMPLATE_DIR/config.json")
TEMPLATE_DESC=$(jq -r '.description' "$TEMPLATE_DIR/config.json")
AGENT_COUNT=$(jq -r '.agents | length' "$TEMPLATE_DIR/config.json")
echo "✅ Template: $TEMPLATE_NAME v$TEMPLATE_VERSION"
echo "   Description: $TEMPLATE_DESC"
echo "   Agents: $AGENT_COUNT"
echo ""

# Step 2: Check if workspace exists
echo "Step 2: Checking workspace..."
if [ -d "$WORKSPACE" ] && [ -f "$WORKSPACE/AGENTS.md" ]; then
    echo "⚠️  Workspace already exists: $WORKSPACE"
    echo "   This will overwrite existing files!"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        exit 1
    fi
fi
echo ""

# Step 3: Create directory structure
echo "Step 3: Creating directory structure..."
mkdir -p "$WORKSPACE"/{shared-context,intel/collaboration,agents,memory/archive,scripts,skills}
echo "✅ Directories created"
echo ""

# Step 4: Generate root files
echo "Step 4: Generating root files..."
ROOT_FILES=$(jq -r '.files.root[]' "$TEMPLATE_DIR/config.json")
for file in $ROOT_FILES; do
    echo "  - Creating $file..."
    # This is a placeholder - actual file generation would use templates
    touch "$WORKSPACE/$file"
done
echo "✅ Root files created"
echo ""

# Step 5: Generate shared-context files
echo "Step 5: Generating shared-context files..."
HAS_SHARED_CONTEXT=$(jq -r '.shared_context' "$TEMPLATE_DIR/config.json")
if [ "$HAS_SHARED_CONTEXT" = "true" ]; then
    SHARED_FILES=$(jq -r '.files.shared_context[]' "$TEMPLATE_DIR/config.json")
    for file in $SHARED_FILES; do
        echo "  - Creating shared-context/$file..."
        touch "$WORKSPACE/shared-context/$file"
    done
    echo "✅ Shared-context files created"
else
    echo "ℹ️  No shared-context files in this template"
fi
echo ""

# Step 6: Generate intel files
echo "Step 6: Generating intel files..."
HAS_INTEL=$(jq -r '.intel' "$TEMPLATE_DIR/config.json")
if [ "$HAS_INTEL" = "true" ]; then
    INTEL_FILES=$(jq -r '.files.intel[]' "$TEMPLATE_DIR/config.json")
    for file in $INTEL_FILES; do
        echo "  - Creating intel/$file..."
        touch "$WORKSPACE/intel/$file"
    done
    echo "✅ Intel files created"
else
    echo "ℹ️  No intel files in this template"
fi
echo ""

# Step 7: Generate agent configurations
echo "Step 7: Generating agent configurations..."
AGENTS=$(jq -r '.agents[]' "$TEMPLATE_DIR/config.json")
for agent in $AGENTS; do
    if [ "$agent" != "main" ]; then
        echo "  - Creating agent: $agent"
        mkdir -p "$WORKSPACE/agents/$agent"
        touch "$WORKSPACE/agents/$agent"/{SOUL.md,IDENTITY.md,HEARTBEAT.md}
    fi
done
echo "✅ Agent configurations created"
echo ""

# Step 8: Summary
echo "📊 Template Application Summary:"
echo "  - Template: $TEMPLATE_NAME v$TEMPLATE_VERSION"
echo "  - Workspace: $WORKSPACE"
echo "  - Agents: $AGENT_COUNT"
echo "  - Shared Context: $HAS_SHARED_CONTEXT"
echo "  - Intel: $HAS_INTEL"
echo ""
echo "✅ Template applied!"
echo ""
echo "Next steps:"
echo "  1. Use agent-config-generator to populate agent files"
echo "  2. Use memory-architecture-manager to initialize memory system"
echo "  3. Edit USER.md with your information"
echo "  4. Edit SOUL.md to define agent personality"
echo "  5. Create Cron tasks based on template config"
