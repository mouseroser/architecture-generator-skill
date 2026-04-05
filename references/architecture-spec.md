# Architecture Specification

OpenClaw 完整架构规范（2026-04-05 更新）。

---

## 一句话总纲

- **main**：人类协作入口 + 主会话编排
- **文件语义固定，文件数量可增长**
- **主语清晰 > 文件数量少**

---

## 目录结构（通用架构）

```text
~/.openclaw/workspace/
├── SOUL.md
├── IDENTITY.md
├── AGENTS.md
├── USER.md
├── MEMORY.md
├── HEARTBEAT.md
├── TOOLS.md
├── README.md
├── shared-context/
│   ├── THESIS.md
│   ├── FEEDBACK-LOG.md
│   ├── PATHS.md
│   └── SIGNALS.md
├── intel/
│   └── collaboration/
├── agents/
│   └── <agent-name>/
└── memory/
    ├── YYYY-MM-DD.md
    ├── topics/
    └── archive/
```

---

## 文件职责

- `IDENTITY.md`：名片
- `SOUL.md`：人格与边界
- `USER.md`：服务对象合同
- `AGENTS.md`：执行手册
- `HEARTBEAT.md`：值班清单
- `TOOLS.md`：环境坑位
- `MEMORY.md`：长期伤疤与护栏
- `memory/YYYY-MM-DD.md`：当天账本与晋升池

### 关键原则
- sub-agent 可以从最小骨架启动
- 但不能被永久锁死在三件套
- 文件增长由真实使用驱动
- 优化只做主语纠偏、内容瘦身、结构整理
- 不做 blanket trimming

---

## 主 Agent 职责

### main
负责：
- 人类协作入口
- 主会话编排
- 可靠通知 owner

不负责：
- routine heartbeat（由 HEARTBEAT.md 定义）
- routine cron 宿主（由各 agent 自行管理）

---

## intel 分层

### `intel/collaboration/`
- 协作产物目录
- 按业务线组织（如 starchain / stareval / media）
- 单写者原则

---

## MEMORY.md 规范

main 与 sub-agent 统一骨架：
1. 血泪教训
2. 错误示范 / 反模式
3. 长期稳定规则
4. 长期偏好（可选）

### 写入门槛
至少满足以下 3 条才进 MEMORY.md：
- 高代价
- 可复发
- 已验证
- 长期有效
- 不写进去以后大概率还会再犯

### 分工
- root `MEMORY.md`：系统级、跨 agent、长期护栏
- sub-agent `MEMORY.md`：agent-specific 的高代价长期伤疏

---

## 架构变更收口规则

重大架构调整后：
1. 写入 `master-execution-plan.md`
2. 至少运行观察 2-3 天
3. 只根据真实使用反馈决定下一轮小修
4. 不在同一天连续做多轮结构手术

---

**最后更新**: 2026-04-05
