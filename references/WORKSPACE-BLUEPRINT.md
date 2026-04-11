# OpenClaw 工作区结构 Blueprint

> 创建 skill 时的架构参照蓝本。聚焦通用架构，不包含具体业务流水线。
> 最后更新：2026-04-05

---

## 一、三层工作架构（文件架构）

### Layer 1 — 身份层
回答"我是谁？为谁服务？"

| 文件 | 用途 |
|------|------|
| `SOUL.md` | 人格与边界，定义 agent 的判断方式和行动风格 |
| `IDENTITY.md` | 身份卡片，快速参考（名字/角色/气质/emoji） |
| `USER.md` | 服务对象合同，定义服务对象的背景/硬规则/偏好 |

**特点**：每次会话启动时首先加载，建立 agent 的自我认知和服务边界。

### Layer 2 — 操作层
回答"我怎么工作？出问题怎么办？"

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 执行手册，定义职责/编排规范/通知规则/记忆规则 |
| `HEARTBEAT.md` | 值班清单，定义健康检查项/时间条件/异常输出格式 |
| `agents/*/` | Sub-agent 专属配置目录，每个 agent 有自己的操作指南 |

**特点**：定义可重复的工作流程和自愈机制，支持多 agent 协作。

### Layer 3 — 知识层
回答"我们学到了什么？当前在关注什么？"

| 文件/目录 | 用途 |
|----------|------|
| `MEMORY.md` | 长期伤疤索引（血泪教训/错误示范/稳定规则） |
| `memory/YYYY-MM-DD.md` | 每日原始日志，记录当天事件/判断/修复 |
| `memory/topics/*.md` | 主题伤疤详情，MEMORY.md 的展开内容 |
| `shared-context/` | 跨 agent 共享知识（THESIS/FEEDBACK-LOG/SIGNALS） |
| `intel/` | Agent 协作文件，单写者原则 |

**特点**：从原始记录到精炼知识的完整链路，支持跨会话学习和多 agent 知识共享。

---

## 二、架构设计原则

1. **文件系统即协作基础设施**  
   不依赖消息队列或数据库，通过文件系统实现 agent 间的信息传递和状态共享。

2. **单写者原则**  
   每个共享文件只有一个 owner 负责写入，其他 agent 只读，避免并发冲突。

3. **执行顺序保证依赖**  
   Agent 间的依赖关系通过 cron 调度和 spawn 顺序保证，不需要复杂的依赖管理系统。

4. **持久化优先**  
   重要结论必须写入文件（Text > Brain），agent 的"记忆"存在于文件系统而非运行时状态。

5. **文件语义固定，数量可增长**  
   不因数量少而合并不同语义，主语清晰优先。

6. **自然增长，不强制最小化**  
   文件按真实需求增长，有价值就保留，无价值就不创建。

---

## 三、根级文件语义与内容格式

> 详细的文件语义定义和架构原则见 [AGENT-FILE-ARCHITECTURE.md](./AGENT-FILE-ARCHITECTURE.md)

### 文件语义表

| 文件 | 主语 | 回答的问题 | 骨架 |
|------|------|------------|------|
| `IDENTITY.md` | agent 自己 | 我是谁 | 名字 / 角色 / 气质 / emoji / 灵感来源 |
| `SOUL.md` | agent 自己 | 我怎么判断和行动 | 核心身份 + 角色 + 原则 + 边界 + 风格 |
| `USER.md` | 服务对象 | 我服务谁 | 背景 / 硬规则 / 偏好 |
| `AGENTS.md` | 当前执行单元 | 我这类任务通常怎么跑 | 职责 / 执行规则 / 通知规则 / 记忆规则 |
| `HEARTBEAT.md` | 值班动作 | 查什么、何时报警 | 检查项 / 具体命令 / 时间条件 / 异常输出格式 |
| `TOOLS.md` | 本地环境 / 工具链 | 这套工具和环境有什么坑 | 路径坑 / schema 坑 / CLI 怪癖 |
| `MEMORY.md` | 长期学习结果 | 我们学到了什么 | 血泪教训 / 错误示范 / 长期稳定规则 / 长期偏好 |
| `memory/YYYY-MM-DD.md` | 当天事实与判断 | 今天发生了什么 | 当天事件 / 判断 / 错误 / 修复 / 待跟进 |

### 内容格式规范

#### IDENTITY.md
```markdown
# IDENTITY.md

- **名字**: <agent 名字>
- **角色**: <一句话角色定位>
- **气质**: <性格特点>
- **Emoji**: <代表 emoji>
- **灵感来源**: <设计灵感>
```

#### SOUL.md
```markdown
# SOUL.md

## 核心身份
<agent 的核心定位>

## 你的角色
<具体角色说明>

## 你的原则
1. **原则 1** — <说明>
2. **原则 2** — <说明>
...

## 你的边界
<不能做什么 / 权限边界>

## 你的风格
<沟通风格 / 执行风格>
```

#### USER.md
```markdown
# USER.md - 关于 <服务对象名>

- **名字**: <真实姓名>
- **称呼**: <常用称呼>
- **时区**: <时区>
- **主通道**: <主要沟通渠道>

## 背景
<服务对象背景信息>

## 硬规则
<不可违反的规则>

## 偏好
<工作偏好 / 沟通偏好>
```

#### AGENTS.md
```markdown
# AGENTS.md - <Agent 名>

## 身份
- **Agent ID**: <agent-id>
- **角色**: <角色>
- **模型**: <默认模型>

## 每次会话
<会话启动时必读文件清单>

## 职责
<核心职责说明>

## 执行规则
<具体执行规范>

## 通知规则
<通知策略>

## 记忆与文件
<记忆管理规则>
```

#### HEARTBEAT.md
```markdown
# HEARTBEAT.md - <Agent 名>健康检查

## 原则
<健康检查的总体原则>

## 检查项

### 检查项 1
检查：
```bash
<检查命令>
```

判定：
<正常/异常判定标准>

时间感知：
<时间相关的判定条件>

## 输出格式

有问题时：
```text
⚠️ <问题类型>
- 影响：<简述>
- 是否需要介入：<是/否>
```

正常时：
```text
HEARTBEAT_OK
```
```

#### TOOLS.md
```markdown
# TOOLS.md - Local Notes

## 本地工具坑位

- <工具/命令> — <坑点说明>
- <路径限制> — <具体限制>
...

## Examples

<具体示例>
```

#### MEMORY.md
```markdown
# MEMORY.md - <Agent 名>的长期记忆（索引）

> 本文件是索引，详细内容在 `memory/topics/*.md` 主题文件中。
> 每条索引 ≤1 行 ≤150 字符。

## ⚠️ 血泪教训（索引）

### <分类 1>
- [<教训标题>](memory/topics/<文件名>.md) — <一句话说明>

### <分类 2>
...

## ✅ 验证有效的做法（Confirmed Approaches）

<记录确认有效的做法>

## 🛡️ 记忆漂移防御

<防御规则>

## 📌 长期稳定规则

<长期不变的规则>

## 🌱 长期偏好

<长期偏好>
```

#### memory/YYYY-MM-DD.md
```markdown
# YYYY-MM-DD 日志

## <事件标题>

### 背景
<事件背景>

### 执行步骤
<具体步骤>

### 最终状态
<结果状态>

### 教训
<学到的教训>

---

<自动捕获的记忆条目>
- YYYY-MM-DDTHH:MM:SS.sssZ [<类型>:<scope>] <内容>
```

---


#### shared-context/THESIS.md
```markdown
# THESIS.md - 当前世界观

> 这不是成果周报。这是整个实例看世界的方式。

---

## 1. 总纲
<系统定位：是什么 / 不是是什么 / 是什么的演化>

## 2. 核心判断

### 系统哲学
<核心系统哲学>

### 执行哲学
<核心执行哲学>

### 通知哲学
<通知策略>

### 记忆哲学
<三层记忆架构>

## 3. 业务主架构

### <业务线 A>（<定位>）
<关键判断>

### <业务线 B>（<定位>）
<关键判断>

## 4. 当前优先级

### 高 / 中 / 低 / 观察
<优先级项>

## 5. 明确不做 / 不优先做
- ❌ <不做项>

## 6. 最近世界观更新
**YYYY-MM-DD**: <更新内容>

---
**最后更新**: YYYY-MM-DD
**下次回顾**: YYYY-MM-DD
```

#### shared-context/FEEDBACK-LOG.md
```markdown
# FEEDBACK-LOG.md - 跨智能体纠偏账本

## 使用规则
- 新纠偏先写这里，所有 agent 共读
- 旧口径被覆盖时，必须标注 `superseded by` 并移到历史区
- 每条纠偏带：问题 → 影响 → 当前最终结论 → 状态
- 状态：✅ 已固化 / ⚠️ 待验证 / ❌ 已失效

---

## 当前有效纠偏（Canonical）

### 执行类 / 边界类 / 通知类 / 架构类 / 环境类

#### <纠偏标题>（YYYY-MM-DD）
- **问题**: <问题描述>
- **影响**: <影响范围>
- **结论**: <最终结论>
- **状态**: ✅ / ⚠️ / ❌

---

## 通用原则（从纠偏中沉淀）
<沉淀的执行/边界/通知/记忆原则>

---

## 历史纠偏（已失效 / 被覆盖）

### ❌ YYYY-MM-DD <标题>
- **失效原因**: <原因>
- **Superseded by**: <新口径>
```

#### shared-context/PATHS.md
```markdown
# PATHS.md - 路径索引

> 所有 agent 共享的路径参考。路径找不到时先查这里。
> **单写者**: <owner>

## 核心文档 / 配置 / Skill 脚本 / 守护 & 运维脚本 / 插件 & 服务

| 类型 | 文件/目录 | 路径 | 说明 |
|------|-----------|------|------|
| <类型> | <文件> | <路径> | <说明> |

## <业务线> 协作产物（intel/collaboration/<name>）

> **单写者原则**：每个子目录只有一个 agent 写，其他只读。

| 目录 | 负责 agent | 说明 |
|------|-----------|------|
| <目录> | <agent> | <说明> |

---

## ⚠️ 常见错误路径

| ❌ 错误 | ✅ 正确 |
|---------|--------|
| <错误路径> | <正确路径> |
```

#### shared-context/SIGNALS.md
```markdown
# SIGNALS.md - 信号定义

> 外部信号池。记录来自用户或外部系统的信号定义。
> **单写者**: <owner>

## 信号定义

| 信号名 | 来源 | 含义 | 处理方式 |
|--------|------|------|----------|
| <信号> | <来源> | <含义> | <处理> |

---

## 最近新增 / 更新
- YYYY-MM-DD: <更新内容>
```

---

## 记忆架构（可选插件）

> 本节说明可选的记忆插件配置，不影响基础 workspace 结构。

### Layer 1: 本地文件（必需）
- `MEMORY.md` — 系统级长期护栏
- `memory/YYYY-MM-DD.md` — 每日日志
- `shared-context/*.md` — 跨 agent 知识

### Layer 2: 自动记忆系统（双轨并行，推荐插件）

#### Layer 2A: memory-lancedb-pro（长期记忆）
- **功能**: 向量检索、自动捕捉、智能遗忘、跨会话记忆
- **GitHub**: https://github.com/CortexReach/memory-lancedb-pro
- **安装**: `openclaw plugins install memory-lancedb-pro@beta`
- **推荐度**: ⭐⭐⭐⭐⭐ 强烈推荐
- **工具**: memory_store, memory_recall, memory_forget 等

#### Layer 2B: lossless-claw-enhanced（上下文管理）
- **功能**: DAG-based 摘要、Token 管理、CJK 友好
- **GitHub**: https://github.com/win4r/lossless-claw-enhanced
- **安装**: `openclaw plugins install lossless-claw`
- **启用**: `openclaw plugins enable lossless-claw`
- **推荐度**: ⭐⭐⭐⭐⭐ 强烈推荐
- **工具**: lcm_grep, lcm_expand, lcm_describe 等

### Layer 3: 深度归档（可选，高级用户）
- NotebookLM（需手动配置）
- 其他云端归档方案

### 推荐配置

| 用户类型 | Layer 2A | Layer 2B | Layer 3 | 说明 |
|---------|---------|---------|---------|------|
| 生产环境 | ✅ | ✅ | 可选 | 完整配置 |
| 记忆优先 | ✅ | ❌ | 可选 | 重视长期记忆 |
| 上下文优先 | ❌ | ✅ | 可选 | 重视上下文管理 |
| 极简用户 | ❌ | ❌ | ❌ | 只用内置功能 |

> **重要**: Layer 2A 和 Layer 2B 是并行的两个系统，不是层级关系
> - Layer 2A = 长期记忆（跨会话）
> - Layer 2B = 上下文管理（当前会话）

### 插件检测脚本

```bash
# 检测插件安装状态
extensions_dir="$HOME/.openclaw/extensions"

# memory-lancedb-pro
if [ -d "$extensions_dir/memory-lancedb-pro" ]; then
    echo "✅ memory-lancedb-pro 已安装"
else
    echo "❌ memory-lancedb-pro 未安装"
    echo "   安装: https://github.com/CortexReach/memory-lancedb-pro"
fi

# lossless-claw-enhanced
if [ -d "$extensions_dir/lossless-claw-enhanced" ]; then
    echo "✅ lossless-claw-enhanced 已安装"
else
    echo "❌ lossless-claw-enhanced 未安装"
    echo "   安装: https://github.com/win4r/lossless-claw-enhanced"
fi
```

---

## 四、Sub-agent 文件增长规则

### 最小启动骨架
- `SOUL.md`
- `IDENTITY.md`
- `AGENTS.md`（含"服务对象"段）
- `memory/`

### 自然增长文件
- `HEARTBEAT.md` — 当该 agent 有稳定值班清单时
- `TOOLS.md` — 当该 agent 有自己稳定的工具链坑位时
- `MEMORY.md` — 当该 agent 有高代价、可复发、agent-specific 的长期伤疤时
- `BOOTSTRAP.md` — 当该 agent 有复杂初始化流程时
- 独立 `USER.md` — 当服务对象上下文厚到会显著挤压 `AGENTS.md` 时

### 判断标准
1. 有没有真实价值
2. 主语是否清晰
3. 能否减少重复 prompt / 重复踩坑 / 重复解释
4. 是否真正帮助该 agent 在未来做得更好

---

## 五、通用目录结构

```
~/.openclaw/workspace/
├── SOUL.md              # 人格与边界
├── IDENTITY.md          # 名片（Agent ID / 角色 / 气质 / Emoji）
├── USER.md              # 服务对象合同
├── AGENTS.md            # 执行手册
├── HEARTBEAT.md         # 值班清单
├── TOOLS.md             # 环境坑位
├── MEMORY.md            # 长期伤疤与护栏（索引文件）
├── README.md            # 工作区说明
│
├── shared-context/      # 跨 agent 共享上下文
│   ├── THESIS.md        # 当前世界观
│   ├── FEEDBACK-LOG.md  # 跨 agent 纠偏账本
│   ├── PATHS.md         # 关键路径索引
│   ├── SIGNALS.md       # 信号定义
│   └── ...              # 其他共享文档
│
├── intel/               # 情报层 / 协作产物
│   └── collaboration/   # 各流水线协作产物
│
├── agents/              # 各 sub-agent 的配置目录
│   ├── <agent-name>/    # agent 工作区（workspace-<agent-name>）
│   └── ...
│   （每个 agent 目录下最小骨架：SOUL.md + IDENTITY.md + AGENTS.md + memory/）
│
├── memory/              # 记忆系统
│   ├── YYYY-MM-DD.md    # 当天日志（每日新建）
│   ├── topics/          # 主题伤疤详情
│   ├── archive/         # 历史日志归档
│   ├── reflections/     # 反思记录
│   └── ...
│
├── .learnings/          # 学习与错误记录
│   ├── ERRORS.md
│   └── LEARNINGS.md
│
├── runtime/             # 运行时状态
│
└── skills/              # 工作区内 skill（本地开发的 skill）
```

---

## 六、核心原则

1. **单写者原则**：一个文件只允许一个 owner 写
2. **文件语义固定，数量可增长**：不因数量少而合并不同语义
3. **MEMORY.md 只做索引**：细节放 `memory/topics/*.md`
4. **记忆漂移防御**：执行前必须验证当前状态，不信记忆快照
5. **主语清晰 > 文件数量少**：宁可多文件，不混语义
6. **协作产物走 intel/collaboration/**：不存 agent 私有 reports/
7. **服务对象信息默认收敛到 AGENTS.md**：不默认恢复独立 USER.md
8. **知道规则就执行**：不问"要我…吗？"
9. **Text > Brain**：重要结论写进文件
10. **踩坑即记**：防止重复踩坑

---

**创建时间**：2026-04-04
**最后更新**：2026-04-05
**维护者**：main（小光）
**用途**：创建新 skill 时的通用架构参照蓝本
