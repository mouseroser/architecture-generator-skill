# Architecture Specification

OpenClaw 完整架构规范（v2.6）。

---

## 目录结构

```
~/.openclaw/workspace/
├── SOUL.md                    # Main agent 人格定义
├── IDENTITY.md                # Main agent 快速参考
├── AGENTS.md                  # 根级行为规则（所有 agent 继承）
├── USER.md                    # 关于用户
├── MEMORY.md                  # Main agent 长期记忆
├── HEARTBEAT.md               # 自愈检查清单
├── TOOLS.md                   # 工具配置和本地笔记
├── MEMORY-ARCHITECTURE.md     # 记忆架构说明
├── shared-context/
│   ├── THESIS.md              # 当前世界观和关注点
│   ├── FEEDBACK-LOG.md        # 跨 agent 纠正日志
│   └── SIGNALS.md             # 追踪的趋势与信号
├── intel/
│   ├── DAILY-INTEL.md         # 每日情报（gemini/notebooklm 写入）
│   └── collaboration/         # 多 agent 协作材料
├── agents/
│   ├── coding/
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   └── HEARTBEAT.md
│   ├── review/
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   └── HEARTBEAT.md
│   ├── test/
│   ├── gemini/
│   ├── notebooklm/
│   ├── brainstorming/
│   ├── docs/
│   ├── wemedia/
│   ├── nano-banana/
│   ├── monitor-bot/
│   ├── claude/
│   └── openai/
├── memory/
│   ├── YYYY-MM-DD.md          # 每日操作日志
│   ├── YYYY-MM-DD-daily.md    # 结构化日志
│   └── archive/               # 归档目录
├── scripts/
│   ├── layer1-compress-check.sh
│   └── layer2-health-check.sh
└── skills/
    ├── agent-config-generator/
    ├── memory-architecture-manager/
    └── architecture-generator/
```

---

## 文件规范

### 根级文件

#### SOUL.md
**用途**: Main agent 的人格定义

**必须包含**:
- 核心身份
- 核心原则
- 边界
- 语气风格
- 执行风格
- 持续性

**示例**:
```markdown
# SOUL.md - 小光是谁

## 核心身份
小光 — 晨星的 AI 伙伴。阳光、开朗、乐于助人。

## 核心原则
- 真诚帮助，不做表演
- 有自己的观点
- 先尝试解决，再寻求帮助
- 用能力赢得信任
- 记住你是客人

## 边界
- 私密的事保持私密
- 有疑问时，外部操作前先问
- 永远不要发送半成品回复
```

#### IDENTITY.md
**用途**: Main agent 的快速参考卡

**必须包含**:
- 名字
- 角色
- 气质
- Emoji
- 灵感来源
- 快速参考（原则、风格、不做）

#### AGENTS.md
**用途**: 根级行为规则，所有 agent 继承

**必须包含**:
- Every Session 规则
- 单写者原则
- Agent 协作规则
- 代码修改硬性限制
- 记忆管理规则
- 流水线编排规则

#### USER.md
**用途**: 关于用户的信息

**必须包含**:
- 名字
- 称呼
- 代词
- 时区
- 主要通讯渠道
- 沟通偏好
- 工作习惯

#### MEMORY.md
**用途**: Main agent 的长期记忆

**必须包含**:
- 血泪教训（永不重犯）
- 错误示范（不要这样做）
- 核心偏好
- 配置信息
- 踩坑笔记

#### HEARTBEAT.md
**用途**: 自愈检查清单

**必须包含**:
- 健康检查项
- 检查命令
- 故障恢复流程
- 原则

#### TOOLS.md
**用途**: 工具配置和本地笔记

**必须包含**:
- 环境特定配置
- 设备昵称
- SSH 主机
- 首选设置

#### MEMORY-ARCHITECTURE.md
**用途**: 记忆架构说明

**必须包含**:
- 三层架构概览
- 层级映射关系
- 使用场景
- 维护计划

---

### shared-context/

#### THESIS.md
**用途**: 当前世界观和关注点

**必须包含**:
- 我当前关注什么
- 我已经写了什么
- 还有哪些空白
- 下一步计划

#### FEEDBACK-LOG.md
**用途**: 跨 agent 纠正日志

**必须包含**:
- 纠正日志（问题、影响、纠正、状态）
- 通用原则

#### SIGNALS.md
**用途**: 追踪的趋势与信号

**必须包含**:
- 技术趋势
- 行业动态
- 个人兴趣
- 当前热点
- 避免的话题

---

### intel/

#### DAILY-INTEL.md
**用途**: 每日情报

**写者**: gemini/notebooklm
**读者**: 所有 agent

#### collaboration/
**用途**: 多 agent 协作材料

**规则**: 单写者原则，任务发起者写入，参与者读取

---

### agents/

每个 agent 必须有：
- `SOUL.md` - 人格定义
- `IDENTITY.md` - 快速参考
- `HEARTBEAT.md` - 健康检查

**标准 agent 列表**:
1. coding - 代码实现者
2. review - 审查执行者
3. test - 测试执行者
4. gemini - 快速扫描者
5. notebooklm - 知识补料者
6. brainstorming - 根因分析者
7. docs - 文档交付者
8. wemedia - 内容创作者
9. nano-banana - 视觉创作者
10. monitor-bot - 系统守望者
11. claude - 主方案设计者
12. openai - 宪法制定者

---

### memory/

#### YYYY-MM-DD.md
**用途**: 每日操作日志

**格式**:
```markdown
# YYYY-MM-DD

## 今日重点
## 完成的任务
## 学到的经验
## 待办事项
```

#### archive/
**用途**: 归档超过 40k tokens 的日志

---

### scripts/

#### layer1-compress-check.sh
**用途**: 压缩超过阈值的每日日志

**功能**:
- 扫描 memory/YYYY-MM-DD.md
- 压缩超过 40k tokens 的文件
- 归档到 memory/archive/

#### layer2-health-check.sh
**用途**: 检查 memory-lancedb-pro 健康状态

**功能**:
- 检查向量数据库
- 检查 rerank sidecar
- 检查自动捕获
- 生成健康评分

---

## Cron 任务规范

### 必须创建的 Cron 任务

1. **layer2-health-check**
   - 时间: 每天 02:00
   - 模型: minimax
   - 超时: 300 秒

2. **memory-quality-audit**
   - 时间: 每天 03:00
   - 模型: minimax
   - 超时: 300 秒

3. **daily-memory-report**
   - 时间: 每天 05:00
   - 模型: opus
   - 超时: 1200 秒

4. **layer1-compress-check**
   - 时间: 每周日 04:00
   - 模型: minimax
   - 超时: 300 秒

5. **MEMORY.md 维护**
   - 时间: 每周日 22:00
   - 模型: opus
   - 超时: 600 秒

6. **memory-archive-weekly-sync**
   - 时间: 每周日 23:00
   - 模型: opus
   - 超时: 600 秒

---

## 单写者原则

### 文件所有权映射

| 文件/目录 | 写者 | 读者 |
|-----------|------|------|
| 根级文件 | main | main |
| shared-context/ | main | all agents |
| intel/DAILY-INTEL.md | gemini/notebooklm | all agents |
| intel/collaboration/ | 任务发起者 | 参与者 |
| agents/<agent-id>/ | 对应 agent | 对应 agent |
| memory/ | main | all agents |

---

## 架构版本

### v2.6（当前版本）
- Review agent 不再编排其他 agent
- Main agent 直接编排所有 agent
- 统一推送规范
- 三层记忆架构

### v2.5
- Review agent 编排 coding/test/gemini
- 基础推送规范
- 两层记忆架构

---

**最后更新**: 2026-03-12 16:11
**维护者**: main (小光)
**版本**: v2.6
