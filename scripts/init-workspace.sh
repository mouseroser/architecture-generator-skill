#!/bin/bash
# init-workspace.sh - 按 WORKSPACE-BLUEPRINT.md 初始化 OpenClaw workspace
# Usage: bash init-workspace.sh [--full|--workspace-only|--memory-only]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES="$SKILL_DIR/templates"
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"

MODE="${1:---full}"

echo "🚀 Architecture Generator - Init"
echo "   Mode: $MODE"
echo "   Workspace: $WORKSPACE"
echo ""

# 检查 Blueprint 是否存在
BLUEPRINT="$SKILL_DIR/references/WORKSPACE-BLUEPRINT.md"
if [ ! -f "$BLUEPRINT" ]; then
  echo "❌ Blueprint 不存在: $BLUEPRINT"
  exit 1
fi

# 检查模板目录
if [ ! -d "$TEMPLATES" ]; then
  echo "❌ 模板目录不存在: $TEMPLATES"
  exit 1
fi

# 创建 workspace 根目录
mkdir -p "$WORKSPACE"

# 1. Workspace Root Files（Layer 1 身份层 + Layer 2 操作层）
if [[ "$MODE" == "--full" || "$MODE" == "--workspace-only" ]]; then
  echo "1️⃣ 初始化 workspace 根目录文件..."
  
  # Layer 1 - 身份层
  for file in SOUL.md IDENTITY.md USER.md; do
    if [ -f "$TEMPLATES/workspace/$file" ]; then
      if [ -f "$WORKSPACE/$file" ]; then
        echo "  ⚠️  $file 已存在，跳过"
      else
        cp "$TEMPLATES/workspace/$file" "$WORKSPACE/$file"
        echo "  ✅ $file（身份层）"
      fi
    fi
  done
  
  # Layer 2 - 操作层
  for file in AGENTS.md HEARTBEAT.md TOOLS.md MEMORY.md README.md; do
    if [ -f "$TEMPLATES/workspace/$file" ]; then
      if [ -f "$WORKSPACE/$file" ]; then
        echo "  ⚠️  $file 已存在，跳过"
      else
        cp "$TEMPLATES/workspace/$file" "$WORKSPACE/$file"
        echo "  ✅ $file（操作层）"
      fi
    fi
  done
fi

# 2. Shared Context
if [[ "$MODE" == "--full" || "$MODE" == "--workspace-only" ]]; then
  echo "2️⃣ 初始化 shared-context..."
  
  mkdir -p "$WORKSPACE/shared-context"
  
  for file in THESIS.md FEEDBACK-LOG.md PATHS.md SIGNALS.md AGENT-FILE-ARCHITECTURE.md; do
    if [ -f "$TEMPLATES/shared-context/$file" ]; then
      if [ -f "$WORKSPACE/shared-context/$file" ]; then
        echo "  ⚠️  shared-context/$file 已存在，跳过"
      else
        cp "$TEMPLATES/shared-context/$file" "$WORKSPACE/shared-context/$file"
        echo "  ✅ shared-context/$file"
      fi
    fi
  done
fi

# 3. Intel Structure
if [[ "$MODE" == "--full" || "$MODE" == "--workspace-only" ]]; then
  echo "3️⃣ 初始化 intel 结构..."
  
  mkdir -p "$WORKSPACE/intel/collaboration"
  
  if [ -f "$TEMPLATES/intel/README.md" ]; then
    if [ ! -f "$WORKSPACE/intel/README.md" ]; then
      cp "$TEMPLATES/intel/README.md" "$WORKSPACE/intel/"
      echo "  ✅ intel/README.md"
    else
      echo "  ⚠️  intel/README.md 已存在，跳过"
    fi
  fi
  
  if [ -f "$TEMPLATES/intel/collaboration/README.md" ]; then
    if [ ! -f "$WORKSPACE/intel/collaboration/README.md" ]; then
      cp "$TEMPLATES/intel/collaboration/README.md" "$WORKSPACE/intel/collaboration/"
      echo "  ✅ intel/collaboration/README.md"
    else
      echo "  ⚠️  intel/collaboration/README.md 已存在，跳过"
    fi
  fi
fi

# 4. Memory Structure（Layer 3 知识层）
if [[ "$MODE" == "--full" || "$MODE" == "--memory-only" ]]; then
  echo "4️⃣ 初始化 memory 结构（Layer 3 知识层）..."
  
  mkdir -p "$WORKSPACE/memory/topics"
  mkdir -p "$WORKSPACE/memory/archive"
  
  if [ -f "$TEMPLATES/memory/README.md" ]; then
    if [ ! -f "$WORKSPACE/memory/README.md" ]; then
      cp "$TEMPLATES/memory/README.md" "$WORKSPACE/memory/"
      echo "  ✅ memory/README.md"
    else
      echo "  ⚠️  memory/README.md 已存在，跳过"
    fi
  fi
fi

# 5. Agents Directory Structure
if [[ "$MODE" == "--full" ]]; then
  echo "5️⃣ 创建 agents 目录结构..."
  
  mkdir -p "$WORKSPACE/agents"
  
  # 创建 agents/README.md
  if [ ! -f "$WORKSPACE/agents/README.md" ]; then
    cat > "$WORKSPACE/agents/README.md" << 'EOF'
# agents/

Sub-agent 配置目录。每个 agent 一个子目录。

## 标准结构

```
agents/
└── <agent-name>/    # agent 工作区（workspace-<agent-name>）
```

## 文件语义

每个 agent 目录下：

| 文件 | 用途 | 骨架 |
|------|------|------|
| `SOUL.md` | 人格与边界 | 核心身份 + 原则 + 边界 + 风格 |
| `IDENTITY.md` | 身份卡片 | 名字 / 角色 / 气质 / emoji |
| `AGENTS.md` | 执行手册 | 职责 + 执行规则 + 通知规则 |

可选增长：
- `HEARTBEAT.md` — 有稳定值班清单时
- `TOOLS.md` — 有稳定工具链坑位时
- `MEMORY.md` — 有 agent-specific 长期伤疤时

## 文件语义固定，数量可增长

不强制最小化，按真实需求增长。
EOF
    echo "  ✅ agents/README.md"
  else
    echo "  ⚠️  agents/README.md 已存在，跳过"
  fi
fi

# 6. .learnings/ Directory
if [[ "$MODE" == "--full" ]]; then
  echo "6️⃣ 创建 .learnings/ 目录..."
  
  mkdir -p "$WORKSPACE/.learnings"
  
  if [ ! -f "$WORKSPACE/.learnings/ERRORS.md" ]; then
    cat > "$WORKSPACE/.learnings/ERRORS.md" << 'EOF'
# ERRORS.md - 错误记录

> 记录重大错误和修复，供后续参考。

## 格式

```markdown
### YYYY-MM-DD HH:MM - <错误简述>

**问题**：<描述>
**影响**：<影响>
**根因**：<根因分析>
**修复**：<修复方案>
**教训**：<学到的教训>
```

---
EOF
    echo "  ✅ .learnings/ERRORS.md"
  else
    echo "  ⚠️  .learnings/ERRORS.md 已存在，跳过"
  fi
  
  if [ ! -f "$WORKSPACE/.learnings/LEARNINGS.md" ]; then
    cat > "$WORKSPACE/.learnings/LEARNINGS.md" << 'EOF'
# LEARNINGS.md - 学习记录

> 记录重要经验、成功实践和优化建议。

## 格式

```markdown
### YYYY-MM-DD - <学习主题>

**内容**：<学习内容>
**应用场景**：<何时适用>
**效果**：<预期效果>
```
EOF
    echo "  ✅ .learnings/LEARNINGS.md"
  else
    echo "  ⚠️  .learnings/LEARNINGS.md 已存在，跳过"
  fi
fi

echo ""
echo "✅ 初始化完成"
echo ""
echo "📊 统计："
find "$WORKSPACE" -type f -name "*.md" 2>/dev/null | wc -l | xargs echo "  - Markdown 文件："
du -sh "$WORKSPACE" 2>/dev/null | awk '{print "  - Workspace 大小：" $1}'
echo ""
echo "🎯 下一步："
echo "  1. 编辑 $WORKSPACE/USER.md 填写服务对象信息"
echo "  2. 使用 agent-config-generator 生成 agent 配置"
echo "  3. 参考 $BLUEPRINT 验证 workspace 结构"
