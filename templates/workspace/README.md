# OpenClaw Workspace

> 这是一个 OpenClaw agent 工作区。
> 基于 [WORKSPACE-BLUEPRINT.md](~/.openclaw/skills/architecture-generator/references/WORKSPACE-BLUEPRINT.md) 创建。

## 三层架构

### Layer 1 — 身份层
- `SOUL.md` — 人格与边界
- `IDENTITY.md` — 身份卡片
- `USER.md` — 服务对象合同

### Layer 2 — 操作层
- `AGENTS.md` — 执行手册
- `HEARTBEAT.md` — 值班清单
- `agents/*/` — Sub-agent 配置

### Layer 3 — 知识层
- `MEMORY.md` — 长期伤疤索引
- `memory/YYYY-MM-DD.md` — 每日日志
- `memory/topics/*.md` — 主题伤疤详情
- `shared-context/` — 跨 agent 共享知识
- `intel/` — Agent 协作文件

## 核心原则

1. **文件系统即协作基础设施** — 通过文件实现 agent 间信息传递
2. **单写者原则** — 每个共享文件只有一个 owner 负责写入
3. **持久化优先** — 重要结论必须写入文件（Text > Brain）
4. **文件语义固定，数量可增长** — 主语清晰优先
5. **自然增长，不强制最小化** — 有价值就保留

## 文件语义

详见 [AGENT-FILE-ARCHITECTURE.md](~/.openclaw/skills/architecture-generator/references/AGENT-FILE-ARCHITECTURE.md)

| 文件 | 主语 | 回答的问题 |
|------|------|------------|
| `IDENTITY.md` | agent 自己 | 我是谁 |
| `SOUL.md` | agent 自己 | 我怎么判断和行动 |
| `USER.md` | 服务对象 | 我服务谁 |
| `AGENTS.md` | 当前执行单元 | 我这类任务通常怎么跑 |
| `HEARTBEAT.md` | 值班动作 | 查什么、何时报警 |
| `TOOLS.md` | 本地环境 | 这套工具和环境有什么坑 |
| `MEMORY.md` | 长期学习结果 | 我们学到了什么 |
| `memory/YYYY-MM-DD.md` | 当天事实与判断 | 今天发生了什么 |

## 开始使用

1. 根据实际情况填写 Layer 1 文件（SOUL/IDENTITY/USER）
2. 定义 Layer 2 执行规则（AGENTS/HEARTBEAT）
3. 随着使用积累 Layer 3 知识（MEMORY/memory/）

---

**创建时间**: [日期]
**维护者**: [Agent 名字]
