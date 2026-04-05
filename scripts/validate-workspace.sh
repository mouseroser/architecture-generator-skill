#!/bin/bash
# validate-workspace.sh - 验证 workspace 是否符合 WORKSPACE-BLUEPRINT.md
# Usage: bash validate-workspace.sh [--verbose]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
BLUEPRINT="$SKILL_DIR/references/WORKSPACE-BLUEPRINT.md"

VERBOSE="${1:-}"

echo "🔍 Architecture Validator"
echo "   Workspace: $WORKSPACE"
echo ""

# 统计变量
PASS=0
FAIL=0
WARN=0

check_file() {
  local file="$1"
  local desc="$2"
  
  if [ -f "$WORKSPACE/$file" ]; then
    echo "  ✅ $file"
    ((PASS++))
    return 0
  else
    echo "  ❌ $file（缺失）"
    ((FAIL++))
    return 1
  fi
}

check_dir() {
  local dir="$1"
  local desc="$2"
  
  if [ -d "$WORKSPACE/$dir" ]; then
    echo "  ✅ $dir/"
    ((PASS++))
    return 0
  else
    echo "  ❌ $dir/（缺失）"
    ((FAIL++))
    return 1
  fi
}

# 1. 检查 Layer 1 - 身份层文件
echo "📋 Layer 1 - 身份层文件"
check_file "SOUL.md" "人格与边界"
check_file "IDENTITY.md" "身份卡片"
check_file "USER.md" "服务对象合同"

# 2. 检查 Layer 2 - 操作层文件
echo ""
echo "📋 Layer 2 - 操作层文件"
check_file "AGENTS.md" "执行手册"
check_file "HEARTBEAT.md" "值班清单"
check_file "TOOLS.md" "环境坑位"

# 3. 检查 Layer 3 - 知识层文件
echo ""
echo "📋 Layer 3 - 知识层文件"
check_file "MEMORY.md" "长期伤疤索引"
check_dir "memory" "memory/ 目录"
check_dir "memory/topics" "memory/topics/ 目录"
check_dir "shared-context" "shared-context/ 目录"
check_dir "intel" "intel/ 目录"

# 4. 检查 shared-context 核心文件
echo ""
echo "📋 shared-context/ 核心文件"
check_file "shared-context/THESIS.md" "世界观"
check_file "shared-context/FEEDBACK-LOG.md" "纠偏账本"
check_file "shared-context/AGENT-FILE-ARCHITECTURE.md" "文件语义与边界"
check_file "shared-context/SIGNALS.md" "信号定义"

# 5. 检查 intel 结构
echo ""
echo "📋 intel/ 结构"
check_dir "intel/collaboration" "intel/collaboration/"

# 6. 检查 .learnings/ 结构
echo ""
echo "📋 .learnings/ 结构"
check_dir ".learnings" ".learnings/"

# 7. 检查 agents/ 结构
echo ""
echo "📋 agents/ 结构"
check_dir "agents" "agents/"

# 8. 文件语义验证
echo ""
echo "📋 文件语义验证"

if [ -f "$WORKSPACE/IDENTITY.md" ]; then
  if grep -q "名字\|角色\|气质" "$WORKSPACE/IDENTITY.md"; then
    echo "  ✅ IDENTITY.md 语义正确"
    ((PASS++))
  else
    echo "  ⚠️  IDENTITY.md 语义可能不符"
    ((WARN++))
  fi
fi

if [ -f "$WORKSPACE/SOUL.md" ]; then
  if grep -q "原则\|边界\|风格" "$WORKSPACE/SOUL.md"; then
    echo "  ✅ SOUL.md 语义正确"
    ((PASS++))
  else
    echo "  ⚠️  SOUL.md 语义可能不符"
    ((WARN++))
  fi
fi

if [ -f "$WORKSPACE/AGENTS.md" ]; then
  if grep -q "职责\|执行规则\|通知规则" "$WORKSPACE/AGENTS.md"; then
    echo "  ✅ AGENTS.md 语义正确"
    ((PASS++))
  else
    echo "  ⚠️  AGENTS.md 语义可能不符"
    ((WARN++))
  fi
fi

if [ -f "$WORKSPACE/MEMORY.md" ]; then
  if grep -q "血泪教训\|错误示范\|长期稳定规则" "$WORKSPACE/MEMORY.md"; then
    echo "  ✅ MEMORY.md 语义正确"
    ((PASS++))
  else
    echo "  ⚠️  MEMORY.md 语义可能不符"
    ((WARN++))
  fi
fi

# 9. 检查 agents 子目录（自动发现）
echo ""
echo "📋 agents/ 子目录（自动发现）"

if [ -d "$WORKSPACE/agents" ]; then
  for agent_dir in "$WORKSPACE/agents"/*; do
    if [ -d "$agent_dir" ]; then
      agent_name=$(basename "$agent_dir")
      echo "  ✅ agents/$agent_name/"
      
      # 检查最小骨架
      if [ -f "$agent_dir/SOUL.md" ] && \
         [ -f "$agent_dir/IDENTITY.md" ] && \
         [ -f "$agent_dir/AGENTS.md" ]; then
        echo "      └─ 最小骨架 ✅"
      else
        echo "      └─ ⚠️  最小骨架不完整（需要 SOUL.md + IDENTITY.md + AGENTS.md）"
        ((WARN++))
      fi
    fi
  done
fi

# 总结
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 验证结果汇总"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ 通过：$PASS"
echo "  ❌ 失败：$FAIL"
echo "  ⚠️  警告：$WARN"
echo ""

if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
  echo "🎉 workspace 完全符合 Blueprint！"
  exit 0
elif [ $FAIL -eq 0 ]; then
  echo "⚠️  workspace 基本符合 Blueprint，有 $WARN 个警告"
  exit 0
else
  echo "❌ workspace 不符合 Blueprint，有 $FAIL 个缺失 + $WARN 个警告"
  echo ""
  echo "💡 使用 converge-workspace.sh 补全缺失："
  echo "   bash scripts/converge-workspace.sh --fill"
  exit 1
fi
