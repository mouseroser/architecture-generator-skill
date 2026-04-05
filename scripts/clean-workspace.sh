#!/bin/bash
# clean-workspace.sh - 清理不符合 WORKSPACE-BLUEPRINT.md 的文件和目录
# Usage: bash clean-workspace.sh [--dry-run|--execute|--full]

set +e  # 允许命令失败继续

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
BLUEPRINT="$SKILL_DIR/references/WORKSPACE-BLUEPRINT.md"

MODE="${1:---dry-run}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_DIR="$WORKSPACE/.archive/cleaned-$TIMESTAMP"

echo "🧹 Architecture Cleaner"
echo "   Mode: $MODE"
echo "   Workspace: $WORKSPACE"
echo ""

# 统计变量
TO_CLEAN=0
CLEANED=0
PRESERVED=0

# Blueprint 定义的合法根级文件
LEGAL_ROOT_FILES=(
  "SOUL.md"
  "IDENTITY.md"
  "USER.md"
  "AGENTS.md"
  "HEARTBEAT.md"
  "TOOLS.md"
  "MEMORY.md"
  "README.md"
)

# Blueprint 定义的合法根级目录
LEGAL_ROOT_DIRS=(
  "shared-context"
  "intel"
  "agents"
  "memory"
  ".learnings"
)

# 保留的特殊目录（不清理）
PRESERVED_DIRS=(
  ".git"
  ".archive"
  ".openclaw"
  "runtime"
  "skills"
  "plugins"
  "services"
  "reports"  # 保留，可能有历史数据
)

# 检查文件是否合法
is_legal_file() {
  local file="$1"
  for legal in "${LEGAL_ROOT_FILES[@]}"; do
    if [ "$file" == "$legal" ]; then
      return 0
    fi
  done
  return 1
}

# 检查目录是否合法
is_legal_dir() {
  local dir="$1"
  for legal in "${LEGAL_ROOT_DIRS[@]}"; do
    if [ "$dir" == "$legal" ]; then
      return 0
    fi
  done
  for preserved in "${PRESERVED_DIRS[@]}"; do
    if [ "$dir" == "$preserved" ]; then
      return 0
    fi
  done
  return 1
}

# 清理或预览
clean_item() {
  local item="$1"
  local type="$2"  # file or dir
  
  if [ "$MODE" == "--dry-run" ]; then
    echo "  🗑️  将清理: $item ($type)"
    ((TO_CLEAN++))
  elif [ "$MODE" == "--execute" ] || [ "$MODE" == "--full" ]; then
    mkdir -p "$ARCHIVE_DIR"
    mv "$WORKSPACE/$item" "$ARCHIVE_DIR/"
    echo "  ✅ 已归档: $item → .archive/cleaned-$TIMESTAMP/"
    ((CLEANED++))
  fi
}

# 扫描根级文件
echo "📋 扫描根级文件..."
for file in "$WORKSPACE"/*; do
  [ -f "$file" ] || continue
  filename=$(basename "$file")
  
  # 跳过隐藏文件
  [[ "$filename" == .* ]] && continue
  
  if is_legal_file "$filename"; then
    echo "  ✅ 保留: $filename"
    ((PRESERVED++))
  else
    clean_item "$filename" "file"
  fi
done

# 扫描根级目录
echo ""
echo "📋 扫描根级目录..."
for dir in "$WORKSPACE"/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  
  if is_legal_dir "$dirname"; then
    echo "  ✅ 保留: $dirname/"
    ((PRESERVED++))
  else
    clean_item "$dirname" "dir"
  fi
done

# 检查 shared-context 内容
echo ""
echo "📋 检查 shared-context/ 内容..."
if [ -d "$WORKSPACE/shared-context" ]; then
  # Blueprint 定义的合法 shared-context 文件
  LEGAL_SHARED_CONTEXT=(
    "THESIS.md"
    "FEEDBACK-LOG.md"
    "PATHS.md"
    "CRON-MATRIX.md"
    "SIGNALS.md"
  )
  
  # 业务流水线相关文件（保留，这些是工作文件）
  BUSINESS_FILES=(
    # 这些文件虽然是业务流水线相关，但是实际工作需要的配置文件
    # 不应该被清理
  )
  
  for file in "$WORKSPACE/shared-context"/*; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    
    # 检查是否是业务流水线文件
    is_business=false
    for business in "${BUSINESS_FILES[@]}"; do
      if [ "$filename" == "$business" ]; then
        is_business=true
        break
      fi
    done
    
    if [ "$is_business" == "true" ]; then
      clean_item "shared-context/$filename" "file"
    else
      # 检查是否是合法文件
      is_legal=false
      for legal in "${LEGAL_SHARED_CONTEXT[@]}"; do
        if [ "$filename" == "$legal" ]; then
          is_legal=true
          break
        fi
      done
      
      if [ "$is_legal" == "true" ]; then
        echo "  ✅ 保留: shared-context/$filename"
        ((PRESERVED++))
      else
        echo "  ⚠️  未知文件: shared-context/$filename（保留）"
        ((PRESERVED++))
      fi
    fi
  done
fi

# 检查 intel 内容
echo ""
echo "📋 检查 intel/ 内容..."
if [ -d "$WORKSPACE/intel" ]; then
  # 保留 DAILY-INTEL.md
  if [ -f "$WORKSPACE/intel/DAILY-INTEL.md" ]; then
    echo "  ✅ 保留: intel/DAILY-INTEL.md"
    ((PRESERVED++))
  fi
  
  # 保留 collaboration/ 和 media-ops/
  if [ -d "$WORKSPACE/intel/collaboration" ]; then
    echo "  ✅ 保留: intel/collaboration/"
    ((PRESERVED++))
  fi
  
  if [ -d "$WORKSPACE/intel/media-ops" ]; then
    echo "  ✅ 保留: intel/media-ops/"
    ((PRESERVED++))
  fi
  
  # 检查其他文件
  for file in "$WORKSPACE/intel"/*; do
    [ -f "$file" ] || [ -d "$file" ] || continue
    filename=$(basename "$file")
    
    if [ "$filename" != "DAILY-INTEL.md" ] && \
       [ "$filename" != "collaboration" ] && \
       [ "$filename" != "media-ops" ]; then
      if [ -f "$file" ]; then
        echo "  ⚠️  未知文件: intel/$filename（保留）"
        ((PRESERVED++))
      else
        echo "  ⚠️  未知目录: intel/$filename/（保留）"
        ((PRESERVED++))
      fi
    fi
  done
fi

# 如果是 --full 模式，执行补全
if [ "$MODE" == "--full" ]; then
  echo ""
  echo "📝 执行补全..."
  bash "$SCRIPT_DIR/converge-workspace.sh" --fill
fi

# 总结
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 清理结果汇总"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$MODE" == "--dry-run" ]; then
  echo "  🗑️  待清理：$TO_CLEAN"
  echo "  ✅ 保留：$PRESERVED"
  echo ""
  echo "💡 这是预览模式，没有实际清理任何文件"
  echo "   执行清理："
  echo "     bash scripts/clean-workspace.sh --execute"
  echo "   完整重构（清理 + 补全）："
  echo "     bash scripts/clean-workspace.sh --full"
elif [ "$MODE" == "--execute" ] || [ "$MODE" == "--full" ]; then
  echo "  ✅ 已清理：$CLEANED"
  echo "  ✅ 保留：$PRESERVED"
  echo ""
  if [ $CLEANED -gt 0 ]; then
    echo "📦 归档位置："
    echo "   $ARCHIVE_DIR"
    echo ""
    echo "💡 如需恢复，从归档目录复制回 workspace"
  fi
  
  if [ "$MODE" == "--full" ]; then
    echo ""
    echo "💡 运行 validate-workspace.sh 验证重构结果："
    echo "   bash scripts/validate-workspace.sh"
  fi
fi
