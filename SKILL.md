---
name: architecture-generator
description: 基于 WORKSPACE-BLUEPRINT.md 优化 OpenClaw workspace 工作区结构。实现：生成、验证、收敛、优化。确保 workspace 文件语义清晰、内容格式符合 Blueprint。

## 与其他 skill 的联动

**核心定位**：workspace 结构优化的主入口

**分工原则**:
- `architecture-generator` (bash 脚本) → 处理 workspace **结构**（文件/目录）
- `memory-architecture-manager` (skill) → 处理**记忆架构**（Layer 1/2/3）
- `agent-config-generator` (skill) → 处理 **agent 配置**（SOUL/IDENTITY/AGENTS 等）

**实际工作流**:

```
用户调用 architecture-generator
    ↓
┌─────────────────────────────────────────────────────────┐
│ architecture-generator (bash 脚本)                      │
│ ├── init-workspace.sh      → 创建基础结构               │
│ ├── validate-workspace.sh  → 检查结构是否符合 Blueprint │
│ ├── converge-workspace.sh  → 补全缺失 + 修复 agent 位置  │
│ └── optimize-workspace.sh  → 综合检查 + 插件检测 + 记忆优化 │
└─────────────────────────────────────────────────────────┘
    ↓
检测到插件 → 提示运行 memory-architecture-manager
```

**三 Skill 联动架构**:

```
optimize-workspace.sh（主入口）
    ├── Step 1: 检查结构 → converge --fill
    ├── Step 1.5: 检查 agent 位置 → converge --fix-agents
    ├── Step 2-3: 检查 Layer 1/2 插件
    ├── Step 4: 检查 agent 配置
    ├── Step 4.5: 调用 reorganize-agent-content.sh（重组内容）
    └── Step 5: 调用 optimize-memory-architecture.sh（记忆优化）



converge-workspace.sh
    ├── --fill: 补全缺失文件
    ├── --fix-agents: 修复 agent 位置（检测包含 AGENTS.md 的目录）
    └── --all: 执行所有修复
```

**记忆架构（双轨并行）**:

| 组件 | 层级 | 用途 | GitHub |
|------|------|------|--------|
| **memory-lancedb-pro** | Layer 2A | 长期记忆、跨会话检索 | https://github.com/CortexReach/memory-lancedb-pro |
| **lossless-claw-enhanced** | Layer 2B | 上下文管理、DAG 摘要 | https://github.com/win4r/lossless-claw-enhanced |
| **NotebookLM**（可选） | Layer 3 | 深度归档、研究分析 | 高级用户可选 |

> **重要**: Layer 2A 和 Layer 2B 是并行的两个插件，强烈推荐两个都安装

---

# Architecture Generator

基于 Blueprint 优化 OpenClaw workspace 工作区结构。

## 核心目标

通过 `references/WORKSPACE-BLUEPRINT.md` 作为唯一事实来源，实现：
1. **生成（Generate）** — 按蓝图生成完整 workspace 结构
2. **验证（Validate）** — 检查现有 workspace 是否符合蓝图
3. **收敛（Converge）** — 补全缺失文件 + 修复 agent 位置
4. **优化（Optimize）** — 综合检查 + 插件检测 + 记忆架构优化

## 重要原则

**这个 skill 是优化已有 workspace 结构，不是删除已有文件，也不是重写内容。**

- ✅ 按蓝图补全缺失文件
- ✅ 自动识别并修复 agent 位置（检测包含 `AGENTS.md` 的目录）
- ✅ 检测插件安装状态，提供安装建议
- ✅ 检测到 agent 配置后，提示是否重组内容
- ✅ 检测到插件后，提示运行记忆架构优化
- ✅ 保留所有已有内容和数据
- ❌ 不删除 workspace 已有目录和文件
- ❌ 不覆盖已有内容（只补全缺失）
- ❌ 不自动重组内容（需用户确认后调用 agent-config-generator）

## 工作区识别

OpenClaw workspace 命名规则：
- **默认主 agent 工作区**：`workspace/` = `~/.openclaw/workspace/`
- **其他 agent 工作区**：`workspace-<agent-name>/` = `~/.openclaw/workspace-<agent-name>/`

skill 会自动识别所有 `workspace*` 目录，并按 Blueprint 验证和优化。

## Required Read

1. `references/WORKSPACE-BLUEPRINT.md` — 唯一事实来源
2. `templates/shared-context/AGENT-FILE-ARCHITECTURE.md` — 文件语义与边界

## 三层工作架构

### Layer 1 — 身份层
定义"我是谁？为谁服务？"
- `SOUL.md` — 人格与边界
- `IDENTITY.md` — 身份卡片
- `USER.md` — 服务对象合同

### Layer 2 — 操作层
定义"我怎么工作？出问题怎么办？"
- `AGENTS.md` — 执行手册
- `HEARTBEAT.md` — 值班清单
- `agents/*/` — Sub-agent 专属配置

### Layer 3 — 知识层
定义"我们学到了什么？"
- `MEMORY.md` — 长期伤疤索引
- `memory/YYYY-MM-DD.md` — 每日日志
- `memory/topics/*.md` — 主题伤疤详情
- `shared-context/` — 跨 agent 共享知识
- `intel/` — Agent 协作文件

## 操作模式

### 1. Generate（生成）

按 Blueprint 生成完整的 workspace 结构：

```bash
bash scripts/init-workspace.sh --full
```

### 2. Validate（验证）

检查现有 workspace 是否符合 Blueprint：

```bash
bash scripts/validate-workspace.sh
```

### 3. Converge（收敛）

补全缺失文件 + 修复 agent 位置：

```bash
# 只补全缺失文件
bash scripts/converge-workspace.sh --fill

# 只修复 agent 位置（workspace-* → agents/）
bash scripts/converge-workspace.sh --fix-agents

# 执行所有修复
bash scripts/converge-workspace.sh --all
```

### 4. Optimize（优化）- 推荐

综合检查 + 插件检测 + 记忆架构优化：

```bash
bash scripts/optimize-workspace.sh
```

包含：
- Step 1: 检查结构 → 发现问题 → converge --fill
- Step 1.5: 检查 agent 位置 → 发现 workspace-* → converge --fix-agents
- Step 2-4: 检查 Layer 1/2/agent 配置
- Step 5: 检测插件 → 提示运行 memory-architecture-manager

## 脚本清单

| 脚本 | 功能 | 说明 |
|------|------|------|
| `init-workspace.sh` | 按 Blueprint 初始化 workspace | 全新创建 |
| `validate-workspace.sh` | 验证 workspace 是否符合 Blueprint | 只检查，不修改 |
| `converge-workspace.sh` | 补全缺失 + 修复 agent 位置 | `--fill` / `--fix-agents` / `--all` |
| `optimize-workspace.sh` | 综合优化（推荐） | 结构 + agent + 插件 + 记忆 |
| `clean-workspace.sh` | 清理不合规文件 | 谨慎使用 |

## 创建新 Agent

直接使用 agent-config-generator：

```bash
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh <agent-name> <type> [role] [model]

# type 可选值：functional | operational | independent

# 示例
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh coding functional
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh monitor operational "系统监控哨" sonnet
bash ~/.openclaw/skills/agent-config-generator/scripts/generate-agent-config.sh assistant independent "个人助理" opus
```

## Blueprint 定义的合法文件/目录

### 根级文件（必须）
- `SOUL.md` / `IDENTITY.md` / `USER.md`
- `AGENTS.md` / `HEARTBEAT.md` / `TOOLS.md` / `MEMORY.md`
- `README.md`

### 根级目录（必须）
- `shared-context/`
- `intel/`
- `agents/`
- `memory/`
- `.learnings/`

### 根级目录（可选，按需保留）
- `runtime/` — 运行时状态
- `skills/` — 工作区内 skill
- `plugins/` — 工作区内 plugin
- `services/` — 服务配置
- `.git/` — Git 仓库
- `.archive/` — 归档目录
- `.openclaw/` — OpenClaw 内部目录

### 工作区目录
- `~/.openclaw/workspace/` — 默认主 agent 工作区
- `~/.openclaw/workspace-<agent>/` — 其他 agent 工作区（将被提示移动到 agents/）

## 根级文件语义

| 文件 | 主语 | 骨架 |
|------|------|------|
| `IDENTITY.md` | agent 自己 | 名字 / 角色 / 气质 / emoji / 灵感来源 |
| `SOUL.md` | agent 自己 | 核心身份 + 原则 + 边界 + 风格 |
| `USER.md` | 服务对象 | 背景 / 硬规则 / 偏好 |
| `AGENTS.md` | 当前执行单元 | 职责 / 执行规则 / 通知规则 / 记忆规则 |
| `HEARTBEAT.md` | 值班动作 | 检查项 / 命令 / 时间条件 / 异常格式 |
| `TOOLS.md` | 本地环境 | 路径坑 / schema 坑 / CLI 怪癖 |
| `MEMORY.md` | 长期学习结果 | 血泪教训 / 错误示范 / 长期稳定规则 |
| `memory/YYYY-MM-DD.md` | 当天事实 | 事件 / 判断 / 错误 / 修复 / 待跟进 |

## Sub-agent 文件增长规则

### 最小启动骨架
- `SOUL.md`
- `IDENTITY.md`
- `AGENTS.md`（含"服务对象"段）
- `memory/`

### 自然增长文件
- `HEARTBEAT.md` — 有稳定值班清单时
- `TOOLS.md` — 有稳定工具链坑位时
- `MEMORY.md` — 有 agent-specific 长期伤疤时
- `BOOTSTRAP.md` — 有复杂初始化流程时

## 核心原则

1. **单写者原则** — 一个文件只允许一个 owner
2. **文件语义固定，数量可增长** — 不因数量少而合并
3. **MEMORY.md 只做索引** — 细节放 topics/
4. **记忆漂移防御** — 执行前验证当前状态
5. **主语清晰 > 文件数量少** — 宁可多文件，不混语义
6. **Text > Brain** — 重要结论写文件
7. **优化不删除** — 只优化格式，保留内容
8. **自动识别 agent 工作区** — 识别 workspace-* 并提示移动
9. **插件检测不安装** — 只检测状态，提供安装建议
10. **记忆优化需确认** — 检测到插件后提示用户确认

## Hard Rules

- **保留所有已有内容** — 不删除 workspace 文件
- **优化前先验证** — 先检查是否符合 Blueprint
- **Blueprint 是唯一事实来源** — 所有操作以 WORKSPACE-BLUEPRINT.md 为准
- **自动识别工作区** — 识别 `workspace/` 和 `workspace-*` 目录
- **Agent 位置修复需确认** — 移动前提示用户确认
- **记忆优化需确认** — 检测到插件后提示用户确认

## Agent 类型识别

验证和收敛时会自动识别 agent 类型：

### 识别规则
1. 读取 `AGENTS.md` 中的类型标记：`<!-- agent-type: operational -->`
2. 如果无标记，根据文件判断：
   - 有 `USER.md` → independent
   - 无 `USER.md` → operational

### 验证规则

| 文件 | 功能型 | 职能型 | 独立人格型 |
|------|--------|--------|------------|
| IDENTITY.md | ❌ | ✅ 必需 | ✅ 必需 |
| SOUL.md | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| AGENTS.md | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| USER.md | ❌ | ❌ | ✅ 必需 |
| MEMORY.md | ❌ | 可选 | ✅ 必需 |
| HEARTBEAT.md | ❌ | 可选 | 可选 |
| TOOLS.md | ❌ | 可选 | 可选 |

### 补全规则

`converge-workspace.sh --fill` 会根据 agent 类型补全缺失文件：
- 功能型：只补全 SOUL.md + AGENTS.md
- 职能型：补全 IDENTITY.md + SOUL.md + AGENTS.md
- 独立人格型：补全完整配置

详见：`~/.openclaw/workspace/shared-context/AGENT-PERSONA-STRATEGY.md`

