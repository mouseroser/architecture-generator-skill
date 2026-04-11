# Architecture Generator 使用指南

基于 `WORKSPACE-BLUEPRINT.md` 重构和验证 OpenClaw workspace 工作区结构。

---

## 快速开始

### 1. 综合优化（推荐）

```bash
# 一键优化：结构检查 + agent 位置修复 + 插件检测 + 记忆架构优化
bash ~/.openclaw/skills/architecture-generator/scripts/optimize-workspace.sh
```

包含：
- Step 1: 检查结构 → 发现问题 → 自动修复
- Step 1.5: 检查 agent 位置 → 发现 workspace-* → 提示移动
- Step 2-4: 检查 Layer 1/2/agent 配置
- Step 4.5: 调用 reorganize-agent-content.sh（重组内容）
- Step 5: 调用 optimize-memory-architecture.sh（记忆优化）

### 2. 初始化 workspace（全新创建）

```bash
# 完整初始化（推荐首次使用）
bash ~/.openclaw/skills/architecture-generator/scripts/init-workspace.sh --full
```

### 3. 验证和修复

```bash
# 验证结构
bash ~/.openclaw/skills/architecture-generator/scripts/validate-workspace.sh

# 补全缺失 + 修复 agent 位置
bash ~/.openclaw/skills/architecture-generator/scripts/converge-workspace.sh --all
```

---

## 脚本清单

| 脚本 | 功能 | 说明 |
|------|------|------|
| `optimize-workspace.sh` | 综合优化（推荐） | 结构 + agent + 插件 + 记忆 |
| `init-workspace.sh` | 按 Blueprint 初始化 workspace | 全新创建 |
| `validate-workspace.sh` | 验证 workspace 是否符合 Blueprint | 只检查，不修改 |
| `converge-workspace.sh` | 补全缺失 + 修复 agent 位置 | `--fill` / `--fix-agents` / `--all` |
| `clean-workspace.sh` | 清理不合规文件 | 谨慎使用 |

---

## optimize-workspace.sh（推荐）

综合优化 workspace：结构检查 + agent 位置修复 + 插件检测 + 记忆架构优化。

### 用法

```bash
bash optimize-workspace.sh
```

### 执行流程

```
Step 1: 检查 workspace 结构
    ↓ 发现问题
提示用户是否自动修复？(y/n)
    ↓ y
converge-workspace.sh --fill
    ↓
Step 1.5: 检查 agent 文件位置
    ↓ 发现 workspace-* 格式
提示用户是否移动到标准位置？(y/n)
    ↓ y
converge-workspace.sh --fix-agents
    ↓
Step 2-4: 检查 Layer 1/2/agent 配置
    ↓
Step 4.5: 检测 agent 配置 → 调用 reorganize-agent-content.sh
    ↓
Step 5: 检测插件安装状态
    ↓ 检测到插件
调用 optimize-memory-architecture.sh
```

### 输出示例

```
=== Step 1/6: 检查 workspace 结构 ===
✅ SOUL.md
✅ IDENTITY.md
⚠️  缺失 MEMORY.md

是否自动修复？(y/n)

=== Step 1.5/6: 检查 agent 文件位置 ===
⚠️  发现独立的 agent 工作区（workspace-* 格式）
是否自动识别并移动到标准位置？(y/n)

=== Step 4.5/6: Agent 配置内容重组 ===
📋 检测到 agent 配置文件
是否重组内容？(y/n)
    ↓ y
🔧 调用 reorganize-agent-content.sh...
✅ 内容重组完成

=== Step 5/6: 记忆架构优化 ===
✅ memory-architecture-manager skill 可用
🔧 调用 optimize-memory-architecture.sh...
```

---

## init-workspace.sh

按 Blueprint 生成完整的 workspace 结构。

### 用法

```bash
bash init-workspace.sh [--full|--workspace-only|--memory-only]
```

| 模式 | 说明 |
|------|------|
| `--full` | 完整初始化（默认） |
| `--workspace-only` | 只初始化 workspace 根目录文件 |
| `--memory-only` | 只初始化 memory 结构 |

---

## 创建新 Agent

直接使用 agent-config-generator：

```bash
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh <agent-name> [role] [model]

# 示例
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh coding "代码实现专家" opus
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh wemedia "自媒体管家" sonnet
```

---

## 初始化后的下一步

### 1. 运行综合优化

```bash
bash ~/.openclaw/skills/architecture-generator/scripts/optimize-workspace.sh
```

### 2. 安装 Layer 2 插件（如未安装）

**Layer 2A: memory-lancedb-pro**（长期记忆）
```bash
openclaw plugins install memory-lancedb-pro@beta
```
GitHub: https://github.com/CortexReach/memory-lancedb-pro

**Layer 2B: lossless-claw-enhanced**（上下文管理）
```bash
git clone https://github.com/win4r/lossless-claw-enhanced.git
openclaw plugins install --link ./lossless-claw-enhanced
```
GitHub: https://github.com/win4r/lossless-claw-enhanced

---

## 与其他 Skill 的联动

### 三 Skill 联动架构

```
architecture-generator（主入口）
    └── optimize-workspace.sh（一键优化）
        ├── Step 4.5: 调用 reorganize-agent-content.sh
        └── Step 5: 调用 optimize-memory-architecture.sh
```

### 联动说明

1. **architecture-generator** = 主入口，负责结构优化
2. **agent-config-generator** = 独立工作，生成/重组 agent 配置
3. **memory-architecture-manager** = 可选模块，优化记忆架构

---

## Blueprint 参考

Blueprint 定义了：
1. **三层工作架构**：身份层 / 操作层 / 知识层
2. **shared-context/ 文件语义**：THESIS / FEEDBACK-LOG / PATHS / SIGNALS / AGENT-FILE-ARCHITECTURE
3. **记忆架构**：Layer 2A + Layer 2B 双轨并行

详见：`references/WORKSPACE-BLUEPRINT.md`

---

**最后更新**: 2026-04-05
