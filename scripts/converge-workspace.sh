#!/bin/bash
# converge-workspace.sh - 收敛 workspace：补全缺失文件、修复错位文件
# Usage: bash converge-workspace.sh [--fill|--fix-agents]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
TEMPLATES="$SKILL_DIR/templates"

MODE="${1:---fill}"

echo "🔧 Architecture Converger"
echo "   Mode: $MODE"
echo "   Workspace: $WORKSPACE"
echo ""

# 统计变量
CREATED=0
SKIPPED=0
MOVED=0

# ========== FILL 模式：补全缺失文件 ==========
fill_missing() {
  echo "📝 补全缺失文件..."
  echo ""
  
  # 1. Layer 1 - 身份层
  echo "Layer 1 - 身份层"
  for file in SOUL.md IDENTITY.md USER.md; do
    if [ ! -f "$WORKSPACE/$file" ]; then
      if [ -f "$TEMPLATES/workspace/$file" ]; then
        cp "$TEMPLATES/workspace/$file" "$WORKSPACE/$file"
        echo "  ✅ 创建 $file"
        ((CREATED++))
      fi
    else
      echo "  ⚠️  $file 已存在，跳过"
      ((SKIPPED++))
    fi
  done
  
  # 2. Layer 2 - 操作层
  echo ""
  echo "Layer 2 - 操作层"
  for file in AGENTS.md HEARTBEAT.md TOOLS.md MEMORY.md README.md; do
    if [ ! -f "$WORKSPACE/$file" ]; then
      if [ -f "$TEMPLATES/workspace/$file" ]; then
        cp "$TEMPLATES/workspace/$file" "$WORKSPACE/$file"
        echo "  ✅ 创建 $file"
        ((CREATED++))
      fi
    else
      echo "  ⚠️  $file 已存在，跳过"
      ((SKIPPED++))
    fi
  done
  
  # 3. 目录结构
  echo ""
  echo "目录结构"
  for dir in shared-context intel/collaboration memory/topics memory/archive agents .learnings; do
    if [ ! -d "$WORKSPACE/$dir" ]; then
      mkdir -p "$WORKSPACE/$dir"
      echo "  ✅ 创建 $dir/"
      ((CREATED++))
    else
      echo "  ⚠️  $dir/ 已存在，跳过"
      ((SKIPPED++))
    fi
  done
  
  # 4. shared-context 核心文件
  echo ""
  echo "shared-context/ 核心文件"
  for file in THESIS.md FEEDBACK-LOG.md PATHS.md SIGNALS.md AGENT-FILE-ARCHITECTURE.md; do
    if [ ! -f "$WORKSPACE/shared-context/$file" ]; then
      if [ -f "$TEMPLATES/shared-context/$file" ]; then
        cp "$TEMPLATES/shared-context/$file" "$WORKSPACE/shared-context/$file"
        echo "  ✅ 创建 shared-context/$file"
        ((CREATED++))
      else
        echo "  ⚠️  shared-context/$file 无模板，跳过"
        ((SKIPPED++))
      fi
    else
      echo "  ⚠️  shared-context/$file 已存在，跳过"
      ((SKIPPED++))
    fi
  done
  
  # 5. intel README
  echo ""
  echo "intel/ 文件"
  if [ ! -f "$WORKSPACE/intel/README.md" ]; then
    if [ -f "$TEMPLATES/intel/README.md" ]; then
      mkdir -p "$WORKSPACE/intel"
      cp "$TEMPLATES/intel/README.md" "$WORKSPACE/intel/"
      echo "  ✅ 创建 intel/README.md"
      ((CREATED++))
    fi
  fi
  
  if [ ! -f "$WORKSPACE/intel/collaboration/README.md" ]; then
    if [ -f "$TEMPLATES/intel/collaboration/README.md" ]; then
      mkdir -p "$WORKSPACE/intel/collaboration"
      cp "$TEMPLATES/intel/collaboration/README.md" "$WORKSPACE/intel/collaboration/"
      echo "  ✅ 创建 intel/collaboration/README.md"
      ((CREATED++))
    fi
  fi
  
  # 6. memory README
  echo ""
  echo "memory/ 文件"
  if [ ! -f "$WORKSPACE/memory/README.md" ]; then
    if [ -f "$TEMPLATES/memory/README.md" ]; then
      mkdir -p "$WORKSPACE/memory"
      cp "$TEMPLATES/memory/README.md" "$WORKSPACE/memory/"
      echo "  ✅ 创建 memory/README.md"
      ((CREATED++))
    fi
  fi
  
  # 7. .learnings/ 文件
  echo ""
  echo ".learnings/ 文件"
  if [ ! -f "$WORKSPACE/.learnings/ERRORS.md" ]; then
    mkdir -p "$WORKSPACE/.learnings"
    cat > "$WORKSPACE/.learnings/ERRORS.md" << 'EOF'
# ERRORS.md - 错误记录

> 记录重大错误和修复，供后续参考。
EOF
    echo "  ✅ 创建 .learnings/ERRORS.md"
    ((CREATED++))
  fi
  
  if [ ! -f "$WORKSPACE/.learnings/LEARNINGS.md" ]; then
    mkdir -p "$WORKSPACE/.learnings"
    cat > "$WORKSPACE/.learnings/LEARNINGS.md" << 'EOF'
# LEARNINGS.md - 学习记录

> 记录重要经验、成功实践和优化建议。
EOF
    echo "  ✅ 创建 .learnings/LEARNINGS.md"
    ((CREATED++))
  fi
}

# ========== FIX-AGENTS 模式：修复 agent 文件位置 ==========
fix_agents() {
  echo "🔍 扫描并修复 agent 文件位置..."
  echo ""
  
  # 确保 agents/ 目录存在
  mkdir -p "$WORKSPACE/agents"
  
  MOVED=0
  SKIPPED=0
  
  # 扫描所有可能的 agent 工作区
  # 1. ~/.openclaw/workspace-<agent> 格式
  for workspace_dir in "$HOME/.openclaw"/workspace-*; do
    [ -d "$workspace_dir" ] || continue
    
    agent_name=$(basename "$workspace_dir" | sed 's/^workspace-//')
    target_dir="$WORKSPACE/agents/$agent_name"
    
    echo "发现 agent 工作区: $workspace_dir"
    echo "  目标位置: $target_dir"
    
    if [ -d "$target_dir" ]; then
      echo "  ⚠️  目标位置已存在，跳过"
      ((SKIPPED++))
      continue
    fi
    
    echo "  是否移动到标准位置？(y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      mv "$workspace_dir" "$target_dir"
      echo "  ✅ 已移动到 agents/$agent_name/"
      ((MOVED++))
    else
      echo "  ⏭️  跳过"
      ((SKIPPED++))
    fi
    echo ""
  done
  
  # 2. 检查 ~/.openclaw/ 根目录下包含 AGENTS.md 的目录
  echo "🔍 扫描 ~/.openclaw/ 根目录下的 agent 配置..."
  for dir in "$HOME/.openclaw"/*; do
    [ -d "$dir" ] || continue
    
    # 跳过已知的系统目录
    dir_name=$(basename "$dir")
    case "$dir_name" in
      workspace|workspace-*|extensions|config-backups|state|todo|skills|.git)
        continue
        ;;
    esac
    
    # 检查是否包含 AGENTS.md
    if [ -f "$dir/AGENTS.md" ]; then
      agent_name="$dir_name"
      target_dir="$WORKSPACE/agents/$agent_name"
      
      echo "发现 agent 配置: $dir"
      echo "  目标位置: $target_dir"
      
      if [ -d "$target_dir" ]; then
        echo "  ⚠️  目标位置已存在，跳过"
        ((SKIPPED++))
        continue
      fi
      
      echo "  是否移动到标准位置？(y/n)"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        mv "$dir" "$target_dir"
        echo "  ✅ 已移动到 agents/$agent_name/"
        ((MOVED++))
      else
        echo "  ⏭️  跳过"
        ((SKIPPED++))
      fi
      echo ""
    fi
  done
  
  # 3. 检查 workspace/ 根目录下包含 AGENTS.md 的目录
  echo "🔍 扫描 workspace/ 根目录下的 agent 配置..."
  for dir in "$WORKSPACE"/*; do
    [ -d "$dir" ] || continue
    
    # 跳过已知的系统目录
    dir_name=$(basename "$dir")
    case "$dir_name" in
      agents|memory|shared-context|intel|.learnings|runtime|skills|plugins|services|.git|.archive|.openclaw)
        continue
        ;;
    esac
    
    # 检查是否包含 AGENTS.md
    if [ -f "$dir/AGENTS.md" ]; then
      agent_name="$dir_name"
      target_dir="$WORKSPACE/agents/$agent_name"
      
      echo "发现 agent 配置: $dir"
      echo "  目标位置: $target_dir"
      
      if [ -d "$target_dir" ]; then
        echo "  ⚠️  目标位置已存在，跳过"
        ((SKIPPED++))
        continue
      fi
      
      echo "  是否移动到标准位置？(y/n)"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        mv "$dir" "$target_dir"
        echo "  ✅ 已移动到 agents/$agent_name/"
        ((MOVED++))
      else
        echo "  ⏭️  跳过"
        ((SKIPPED++))
      fi
      echo ""
    fi
  done
  
  echo "📊 修复完成: 移动 $MOVED 个，跳过 $SKIPPED 个"
}

# ========== 主流程 ==========
case "$MODE" in
  "--fill")
    fill_missing
    ;;
  "--fix-agents")
    fix_agents
    ;;
  "--all")
    fill_missing
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    fix_agents
    ;;
  *)
    echo "❌ 未知模式: $MODE"
    echo "   用法："
    echo "     --fill         补全缺失文件"
    echo "     --fix-agents   修复 agent 文件位置"
    echo "     --all          执行所有修复"
    exit 1
    ;;
esac

# 总结
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 收敛结果汇总"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ 创建：$CREATED"
echo "  🔄 移动：$MOVED"
echo "  ⚠️  跳过：$SKIPPED"
echo ""

if [ $CREATED -gt 0 ] || [ $MOVED -gt 0 ]; then
  echo "💡 运行 validate-workspace.sh 验证收敛结果："
  echo "   bash scripts/validate-workspace.sh"
fi
