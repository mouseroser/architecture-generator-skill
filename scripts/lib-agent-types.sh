#!/bin/bash
# lib-agent-types.sh - Agent 类型检测和验证函数库
# 供 validate-workspace.sh 和 converge-workspace.sh 调用

# 检测 agent 类型
detect_agent_type() {
  local agent_dir="$1"
  
  # 从 AGENTS.md 读取类型标记
  if [ -f "$agent_dir/AGENTS.md" ]; then
    local type=$(grep -o 'agent-type: [a-z]*' "$agent_dir/AGENTS.md" 2>/dev/null | cut -d' ' -f2)
    if [ -n "$type" ]; then
      echo "$type"
      return
    fi
  fi
  
  # 默认：如果有 USER.md 则为 independent，否则为 operational
  if [ -f "$agent_dir/USER.md" ]; then
    echo "independent"
  else
    echo "operational"
  fi
}

# 验证 agent 文件（根据类型）
validate_agent_files() {
  local agent_dir="$1"
  local agent_name=$(basename "$agent_dir")
  local agent_type=$(detect_agent_type "$agent_dir")
  
  echo "      类型: $agent_type"
  
  case "$agent_type" in
    functional)
      if [ -f "$agent_dir/SOUL.md" ] && [ -f "$agent_dir/AGENTS.md" ]; then
        echo "      └─ 配置完整 ✅ (SOUL + AGENTS)"
        return 0
      else
        echo "      └─ ⚠️  配置不完整（功能型需要 SOUL.md + AGENTS.md）"
        return 1
      fi
      ;;
    
    operational)
      local missing=()
      [ ! -f "$agent_dir/IDENTITY.md" ] && missing+=("IDENTITY.md")
      [ ! -f "$agent_dir/SOUL.md" ] && missing+=("SOUL.md")
      [ ! -f "$agent_dir/AGENTS.md" ] && missing+=("AGENTS.md")
      
      if [ ${#missing[@]} -eq 0 ]; then
        echo "      └─ 配置完整 ✅ (IDENTITY + SOUL + AGENTS)"
        
        # 检查可选文件
        local optional=()
        [ -f "$agent_dir/MEMORY.md" ] && optional+=("MEMORY")
        [ -f "$agent_dir/HEARTBEAT.md" ] && optional+=("HEARTBEAT")
        [ -f "$agent_dir/TOOLS.md" ] && optional+=("TOOLS")
        [ -d "$agent_dir/memory" ] && optional+=("memory/")
        
        if [ ${#optional[@]} -gt 0 ]; then
          echo "         可选: ${optional[*]}"
        fi
        return 0
      else
        echo "      └─ ⚠️  配置不完整（职能型缺少: ${missing[*]}）"
        return 1
      fi
      ;;
    
    independent)
      local missing=()
      [ ! -f "$agent_dir/IDENTITY.md" ] && missing+=("IDENTITY.md")
      [ ! -f "$agent_dir/SOUL.md" ] && missing+=("SOUL.md")
      [ ! -f "$agent_dir/USER.md" ] && missing+=("USER.md")
      [ ! -f "$agent_dir/AGENTS.md" ] && missing+=("AGENTS.md")
      [ ! -f "$agent_dir/MEMORY.md" ] && missing+=("MEMORY.md")
      
      if [ ${#missing[@]} -eq 0 ]; then
        echo "      └─ 配置完整 ✅ (完整人格配置)"
        
        # 检查可选文件
        local optional=()
        [ -f "$agent_dir/HEARTBEAT.md" ] && optional+=("HEARTBEAT")
        [ -f "$agent_dir/TOOLS.md" ] && optional+=("TOOLS")
        [ -d "$agent_dir/memory" ] && optional+=("memory/")
        
        if [ ${#optional[@]} -gt 0 ]; then
          echo "         可选: ${optional[*]}"
        fi
        return 0
      else
        echo "      └─ ⚠️  配置不完整（独立人格型缺少: ${missing[*]}）"
        return 1
      fi
      ;;
    
    *)
      echo "      └─ ⚠️  未知类型: $agent_type"
      return 1
      ;;
  esac
}

# 获取 agent 类型所需的必需文件列表
get_required_files() {
  local agent_type="$1"
  
  case "$agent_type" in
    functional)
      echo "SOUL.md AGENTS.md"
      ;;
    operational)
      echo "IDENTITY.md SOUL.md AGENTS.md"
      ;;
    independent)
      echo "IDENTITY.md SOUL.md USER.md AGENTS.md MEMORY.md"
      ;;
    *)
      echo ""
      ;;
  esac
}
