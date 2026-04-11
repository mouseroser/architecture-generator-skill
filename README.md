# Architecture Generator

[![GitHub](https://img.shields.io/badge/GitHub-mouseroser-blue?logo=github)](https://github.com/mousenerator-skill)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Skill-orange.svg)](https://openclaw.ai)

基于 `WORKSPACE-BLUEPRINT.md` 优化 OpenClaw workspace 工作区结构的主入口工具。

## ✨ 特性

- 🔍 **自动验证** - 检查 workspace 是否符合 Blueprint 规范
- 🔧 **智能修复** - 自动补全缺失文件和目录
- 📦 **Agent 管理** - 自动识别和修复 agent 位置
- 🔌 **插件检测** - 检测 Layer 2 插件安装状态
- 🎯 **一键优化** - 综合优化 workspace 结构

## 🚀 快速开始

### 安装

```bash
cd ~/.openclaw/skills
git clone https://github.com/mouseroser/architecture-generator-skill.git architecture-generator
```

### 使用

```bash
# 一键优化（推荐）
bash ~/.openclaw/skills/architecture-generator/scripts/optimize-workspace.sh
```

## 核心功能

### 综合优化（推荐）

```bash
bash ~/.openclaw/skills/architecture-generator/scripts/optimize-workspace.sh
```

一键优化：结构检查 + agent 位置修复 + 插件检测 + 记忆架构优化

### 初始化 workspace

```bash
bash ~/.openclaw/skills/architecture-generator/scripts/init-workspace.sh --full
```

### 验证和修复

```bash
# 验证结构
bash ~/.openclaw/skills/architecture-generator/scripts/validate-workspace.sh

# 补全缺失 + 修复 agent 位置
bash ~/.openclaw/skills/architecture-generator/scripts/converge-workspace.sh --all
```

---

## 脚本清单

| 脚本 | 功能 |
|------|------|
| `optimize-workspace.sh` | 综合优化（推荐） |
| `init-workspace.sh` | 按 Blueprint 初始化 workspace |
| `validate-workspace.sh` | 验证 workspace 是否符合 Blueprint |
| `converge-workspace.sh` | 补全缺失 + 修复 agent 位置 |
| `clean-workspace.sh` | 清理不合规文件（谨慎使用） |

---

## 三层工作架构

### 身份层（Who）
- `IDENTITY.md` — 名片
- `SOUL.md` — 人格与边界
- `USER.md` — 服务对象

### 操作层（How）
- `AGENTS.md` — 执行手册
- `TOOLS.md` — 环境坑位
- `HEARTBEAT.md` — 值班清单

### 知识层（What）
- `MEMORY.md` — 长期教训索引
- `memory/` — 每日记忆
- `memory/topics/` — 主题记忆

---

## 双轨记忆架构

### Layer 2A: memory-lancedb-pro（推荐）

长期记忆、向量检索、跨会话检索

```bash
openclaw plugins install memory-lancedb-pro@beta
```

GitHub: https://github.com/CortexReach/memory-lancedb-pro

### Layer 2B: lossless-claw-enhanced（推荐）

上下文管理、DAG 摘要、Token 管理

```bash
git clone https://github.com/win4r/lossless-claw-enhanced.git
openclaw plugins install --link ./lossless-claw-enhanced
```

GitHub: https://github.com/win4r/lossless-claw-enhanced

> **重要**: Layer 2A 和 Layer 2B 是并行的两个插件，强烈推荐两个都安装

---

## 与其他 Skill 的联动

### 三 Skill 联动架构

```
architecture-generator（主入口）
    └── optimize-workspace.sh
        ├── Step 4.5: 调用 reorganize-agent-content.sh
        └── Step 5: 调用 optimize-memory-architecture.sh
```

### 联动说明

1. **architecture-generator** = 主入口，负责结构优化
2. **agent-config-generator** = 独立工作，生成/重组 agent 配置
3. **memory-architecture-manager** = 可选模块，优化记忆架构

**重要**: optimize-workspace.sh 会在 Step 4.5 和 Step 5 直接调用其他 skill 的脚本。

---

## 创建新 agent

直接使用 agent-config-generator：

```bash
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh <agent-name> [role] [model]
```

示例：
```bash
# 创建 coding agent
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh coding "代码实现专家" opus

# 创建 wemedia agent
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh wemedia "自媒体管家" sonnet
```

---

## 安装

```bash
cd ~/.openclaw/skills
git clone https://github.com/mouseroser/architecture-generator-skill.git architecture-generator
```

或手动下载后放到 `~/.openclaw/skills/architecture-generator/`

---

## 📝 更新日志

### 2026-04-11
- 修复 YAML 警告：使用中文冒号避免 alias 语法冲突
- 优化 README 文档
- 添加徽章和快速开始指南

### 2026-04-05
- 初始版本发布

---

## 📄 License

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系

- GitHub: [@mouseroser](https://github.com/mouseroser)
- OpenClaw Community: [Discord](https://discord.com/invite/clawd)
