#!/bin/bash
# optimize-workspace.sh - OpenClaw workspace 综合优化工具
# 功能：结构检查、插件安装状态检测、记忆架构优化

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== OpenClaw Workspace 优化工具 ==="
echo ""

# 检测 workspace 目录
WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "❌ 未找到 workspace: $WORKSPACE_DIR"
    exit 1
fi

echo "📁 Workspace: $WORKSPACE_DIR"
echo ""

# Step 1: 检查 workspace 结构
echo "=== Step 1/6: 检查 workspace 结构 ==="
bash "$SCRIPT_DIR/validate-workspace.sh" --quiet || {
    echo ""
    echo "⚠️  发现结构问题，是否自动修复？(y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/converge-workspace.sh" --fill
    fi
}
echo ""

# Step 1.5: 检查并修复 agent 文件位置
echo "=== Step 1.5/6: 检查 agent 文件位置 ==="
if ls "$HOME/.openclaw"/workspace-* >/dev/null 2>&1; then
    echo "⚠️  发现独立的 agent 工作区（workspace-* 格式）"
    echo "是否自动识别并移动到标准位置？(y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/converge-workspace.sh" --fix-agents
    fi
else
    echo "✅ 未发现需要移动的 agent 工作区"
fi
echo ""

# Step 2: 检查记忆架构（Layer 1 本地文件）
echo "=== Step 2/6: 检查 Layer 1 本地文件 ==="
layer1_ok=true
if [ ! -f "$WORKSPACE_DIR/MEMORY.md" ]; then
    echo "⚠️  缺失 MEMORY.md"
    layer1_ok=false
else
    echo "✅ MEMORY.md"
fi

if [ ! -d "$WORKSPACE_DIR/memory" ]; then
    echo "⚠️  缺失 memory/ 目录"
    layer1_ok=false
else
    echo "✅ memory/ 目录"
fi

if [ ! -d "$WORKSPACE_DIR/shared-context" ]; then
    echo "⚠️  缺失 shared-context/ 目录"
    layer1_ok=false
else
    echo "✅ shared-context/ 目录"
fi
echo ""

# Step 3: 检查插件安装状态（Layer 2A + Layer 2B）
echo "=== Step 3/6: 检查 Layer 2 插件安装状态 ==="
extensions_dir="$HOME/.openclaw/extensions"

# Layer 2A: memory-lancedb-pro
layer2a_installed=false
if [ -d "$extensions_dir/memory-lancedb-pro" ]; then
    echo "✅ Layer 2A: memory-lancedb-pro 已安装"
    layer2a_installed=true
else
    echo "❌ Layer 2A: memory-lancedb-pro 未安装"
    echo "   💡 安装: https://github.com/CortexReach/memory-lancedb-pro"
    echo "   📦 命令: openclaw plugins install memory-lancedb-pro@beta"
fi

# Layer 2B: lossless-claw-enhanced
layer2b_installed=false
if [ -d "$extensions_dir/lossless-claw-enhanced" ]; then
    echo "✅ Layer 2B: lossless-claw-enhanced 已安装"
    layer2b_installed=true
else
    echo "❌ Layer 2B: lossless-claw-enhanced 未安装"
    echo "   💡 安装: https://github.com/win4r/lossless-claw-enhanced"
fi
echo ""

# Step 4: 检查 agent 配置
echo "=== Step 4/6: 检查 agent 配置 ==="
echo "检查核心配置文件..."
for file in SOUL.md IDENTITY.md AGENTS.md; do
    if [ -f "$WORKSPACE_DIR/$file" ]; then
        echo "✅ $file"
    else
        echo "⚠️  缺失 $file"
    fi
done

if [ -d "$WORKSPACE_DIR/agents" ]; then
    agent_count=$(find "$WORKSPACE_DIR/agents" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    echo "📊 Sub-agent 数量: $agent_count"
fi
echo ""

# Step 4.5: 检测并提示内容重组
echo "=== Step 4.5/6: Agent 配置内容重组 ==="

# 检查是否有 agent 配置文件
agent_config_exists=false
if [ -f "$WORKSPACE_DIR/AGENTS.md" ] || [ -d "$WORKSPACE_DIR/agents" ]; then
    agent_config_exists=true
fi

if [ "$agent_config_exists" = true ]; then
    echo "📋 检测到 agent 配置文件"
    echo ""
    echo "💡 是否重组 agent 配置内容？"
    echo "   - 按主语边界移动内容到正确文件"
    echo "   - 保留所有内容，不删除"
    echo ""
    echo "是否执行内容重组？(y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo ""
        
        # 检查 agent-config-generator skill
        AGENT_CONFIG_GENERATOR="$HOME/.openclaw/skills/agent-config-generator"
        
        if [ -d "$AGENT_CONFIG_GENERATOR" ] && [ -f "$AGENT_CONFIG_GENERATOR/scripts/reorganize-agent-content.sh" ]; then
            echo "🔧 调用 agent-config-generator 重组内容..."
            bash "$AGENT_CONFIG_GENERATOR/scripts/reorganize-agent-content.sh" all
            echo "✅ 内容重组完成"
        else
            echo "⚠️  agent-config-generator skill 不可用"
            echo "   请先安装: git clone https://github.com/win4r/agent-config-generator.git"
            echo "   openclaw plugins install --link ./agent-config-generator"
        fi
    else
        echo "⏭️  跳过内容重组"
    fi
else
    echo "ℹ️  未检测到 agent 配置文件，跳过内容重组"
fi
echo ""

# Step 5: 记忆架构优化（如果插件已安装）
echo "=== Step 5/6: 记忆架构优化 ==="

MEMORY_ARCH_MANAGER="$HOME/.openclaw/skills/memory-architecture-manager"
memory_optimization_available=false

if [ -d "$MEMORY_ARCH_MANAGER" ]; then
    memory_optimization_available=true
    echo "✅ memory-architecture-manager skill 可用"
    
    # 检查是否有插件安装
    if [ "$layer2a_installed" = true ] || [ "$layer2b_installed" = true ]; then
        echo ""
        echo "💡 检测到 Layer 2 插件已安装，是否运行记忆架构优化？(y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo ""
            echo "🔧 运行记忆架构优化..."
            
            # 调用 memory-architecture-manager 的优化脚本
            OPTIMIZE_MEMORY_SCRIPT="$MEMORY_ARCH_MANAGER/scripts/optimize-memory-architecture.sh"
            
            if [ -f "$OPTIMIZE_MEMORY_SCRIPT" ]; then
                bash "$OPTIMIZE_MEMORY_SCRIPT" "$WORKSPACE_DIR"
                echo "✅ 记忆架构优化完成"
            else
                echo "⚠️  找不到 optimize-memory-architecture.sh"
                echo "   可手动运行 memory-architecture-manager skill"
            fi
        else
            echo "⏭️  跳过记忆架构优化"
        fi
    else
        echo "ℹ️  未检测到 Layer 2 插件，跳过记忆架构优化"
        echo "   安装插件后可运行记忆架构优化"
    fi
else
    echo "⚠️  memory-architecture-manager skill 不可用"
    echo "   记忆架构优化功能不可用"
fi
echo ""

# 生成综合报告
echo "=== 优化报告 ==="
echo ""
echo "📊 Layer 1 (本地文件): $([ "$layer1_ok" = true ] && echo '✅ 正常' || echo '⚠️ 需修复')"
echo "📊 Layer 2A (memory-lancedb-pro): $([ "$layer2a_installed" = true ] && echo '✅ 已安装' || echo '❌ 未安装')"
echo "📊 Layer 2B (lossless-claw-enhanced): $([ "$layer2b_installed" = true ] && echo '✅ 已安装' || echo '❌ 未安装')"
echo "📊 记忆架构优化: $([ "$memory_optimization_available" = true ] && echo '✅ 可用' || echo '❌ 不可用')"
echo ""

# 推荐配置建议
echo "💡 推荐配置:"
if [ "$layer2a_installed" = true ] && [ "$layer2b_installed" = true ]; then
    echo "   ✅ 完整配置 (Layer 2A + Layer 2B)"
elif [ "$layer2a_installed" = true ]; then
    echo "   ⚠️  记忆优先配置 (仅 Layer 2A)"
    echo "   💡 建议安装 lossless-claw-enhanced 获得完整上下文管理"
elif [ "$layer2b_installed" = true ]; then
    echo "   ⚠️  上下文优先配置 (仅 Layer 2B)"
    echo "   💡 建议安装 memory-lancedb-pro 获得长期记忆能力"
else
    echo "   ❌ 极简配置 (无 Layer 2 插件)"
    echo "   💡 建议安装 memory-lancedb-pro 和 lossless-claw-enhanced"
fi
echo ""

# 插件安装建议
if [ "$layer2a_installed" = false ] || [ "$layer2b_installed" = false ]; then
    echo "📦 插件安装指引:"
    echo ""
    if [ "$layer2a_installed" = false ]; then
        echo "   memory-lancedb-pro (长期记忆):"
        echo "   - GitHub: https://github.com/CortexReach/memory-lancedb-pro"
        echo "   - 安装命令: openclaw plugins install memory-lancedb-pro@beta"
        echo ""
    fi
    if [ "$layer2b_installed" = false ]; then
        echo "   lossless-claw-enhanced (上下文管理):"
        echo "   - GitHub: https://github.com/win4r/lossless-claw-enhanced"
        echo "   - 安装命令: openclaw plugins install --link ./lossless-claw-enhanced"
        echo ""
    fi
fi

echo "✅ 结构检查完成"
echo ""
echo "📝 下一步:"
if [ "$layer2a_installed" = false ] || [ "$layer2b_installed" = false ]; then
    echo "   1. 根据需要安装上述插件"
    echo "   2. 安装完成后，重新运行本脚本进行记忆架构优化"
else
    echo "   1. 定期运行本脚本检查 workspace 健康状态"
    echo "   2. 使用 agent-config-generator 创建新 agent"
fi
echo ""
echo "✅ 优化完成"
