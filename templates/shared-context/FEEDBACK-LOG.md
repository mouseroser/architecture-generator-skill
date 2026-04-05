# FEEDBACK-LOG.md - 跨智能体纠偏账本

## 使用规则
- 新纠偏先写这里，所有 agent 共读
- 旧口径被覆盖时，必须标注 `superseded by` 并移到历史区
- 每条纠偏带：问题 → 影响 → 当前最终结论 → 状态
- 状态：✅ 已固化 / ⚠️ 待验证 / ❌ 已失效

---

## 当前有效纠偏（Canonical）

### 执行类

#### 知道规则就执行，不要问（YYYY-MM-DD）
- **问题**: 明知该做什么还问"要我…吗？"
- **影响**: 全体 agent
- **结论**: 准备说"要我…吗？"时暂停，直接执行
- **状态**: ✅

#### 执行前必须查记忆（YYYY-MM-DD）
- **问题**: 发布/生图/多步骤任务前不查已知坑，反复踩
- **影响**: 全体 agent
- **结论**: 先 `memory_recall` 查已知坑位，对照 checklist 再执行
- **状态**: ✅

#### 卡点处理：最多重试 2 次就切方向（YYYY-MM-DD）
- **问题**: 链路不通时停在解释或等待
- **影响**: 全体 agent
- **结论**: 重试→换入口→重做产物→跳过→全失败才上报。第 3 次必须切方向
- **状态**: ⚠️ 待验证

#### <禁止模型> 禁止用于 <场景>（YYYY-MM-DD）
- **问题**: <具体问题>
- **影响**: <影响范围>
- **结论**: <场景> 必须用 <允许的模型>
- **状态**: ✅

### 边界类

#### Review 只审查，不编排（YYYY-MM-DD）
- **问题**: Review 编排其他 agent，触发 mode=run 轮次限制
- **影响**: review agent
- **结论**: Review 只执行审查，所有编排由 main 负责
- **状态**: ✅

#### Main 不承载长编排（YYYY-MM-DD）
- **问题**: 主私聊会话承载长时间编排，owner 私聊"像不可用"
- **影响**: main agent
- **结论**: 长任务必须外包到对应智能体或独立链路
- **状态**: ✅

#### 禁止 isolated session 编排（YYYY-MM-DD）
- **问题**: 用 isolated session 编排流水线，职能群收不到消息
- **影响**: main
- **结论**: 所有流水线禁止 isolated session 编排，main 在主会话直接 spawn
- **状态**: ✅

#### <Agent> 结果不可信（YYYY-MM-DD）
- **问题**: <Agent> 声称修复了 N 个 issues 但实际只修了 M 个
- **影响**: <Agent> agent
- **结论**: <Agent> 的 announce 不可信，必须通过 review 或 main 直接验证
- **状态**: ✅

### 通知类

#### 通知职责分层（YYYY-MM-DD 最终口径）
- **问题**: 之前在"main 全推"和"agent 自推"之间反复摇摆
- **影响**: 全体 agent
- **结论**:
  - 各 agent 自推**职能群**（best-effort）：开始 / 进度 / 完成 / 失败
  - **不推监控群** — 监控群由 main 在终态/异常时统一推送
  - Owner DM 只发 4 类：确认门控、BLOCKED/FAILURE、最终结果、长任务摘要
  - 完成通知必须附摘要，不能只发 done
- **状态**: ✅

#### 多步骤任务必发 4 类通知（YYYY-MM-DD）
- **问题**: 多步骤只在后台执行，owner 无法获知状态
- **影响**: main / 执行外部操作的 agent
- **结论**: 开始 / 关键进度 / 错误阻塞 / 完成结果
- **状态**: ✅

### 架构类

#### 文件语义固定，数量可增长（YYYY-MM-DD 最终口径）
- **问题**: 曾经把"文件收口"误当成架构目标，过度收口 sub-agent 文件
- **影响**: 全体 agent
- **结论**:
  - sub-agent 从最小骨架启动：`SOUL.md` + `IDENTITY.md` + `AGENTS.md` + `memory/`
  - `HEARTBEAT.md` / `TOOLS.md` / `MEMORY.md` / `BOOTSTRAP.md` 按真实使用自然长出
  - 服务对象信息默认收敛到 `AGENTS.md` 的"服务对象"段，不再默认恢复独立 `USER.md`
  - 不做 blanket trimming，只做主语纠偏
- **状态**: ✅

#### 协作产物走协作目录（YYYY-MM-DD）
- **问题**: 各 agent 把协作产物存私有 `reports/`，其他 agent 读不到
- **影响**: 全体 agent
- **结论**: 流水线协作交付物统一放 `intel/collaboration/{业务线}/`，agent 自留记录走 `memory/`
- **状态**: ✅

#### 配置文件主语必须清晰（YYYY-MM-DD）
- **问题**: sub-agent 的 `USER.md` 写成了 agent 自己的背景
- **影响**: 全体 sub-agent
- **结论**:
  - `IDENTITY.md` = 名片
  - `SOUL.md` = 人格与边界
  - `AGENTS.md` = 执行手册（含服务对象段）
  - `MEMORY.md` = 长期伤疤
- **状态**: ✅

#### TOOLS 与 MEMORY 不混装（YYYY-MM-DD）
- **问题**: 恢复 `TOOLS.md` / `MEMORY.md` 时容易混装
- **影响**: 全体 agent
- **结论**: `TOOLS.md` 只放环境坑；`MEMORY.md` 只放高代价长期伤疤
- **状态**: ✅

### 环境类

#### Skills 目录位置（YYYY-MM-DD）
- **结论**: 项目特定 → `<project-skills-path>`；通用工具 → `<workspace-skills-path>`
- **状态**: ✅

#### TODO 目录位置（YYYY-MM-DD）
- **结论**: `<todo-path>`，不放 workspace
- **状态**: ✅

---

## 通用原则（从纠偏中沉淀）

### 执行
- 知道规则就执行，不问"要我…吗？"
- 遇到障碍先解决，再汇报
- 执行前查记忆查坑

### 边界
- 每个 agent 只做本职，不越位
- Main 是编排者，不是执行者
- Review 只审查，不编排

### 通知
- 职能群：agent 自推（best-effort）
- 监控群：main 只在终态/异常推
- Owner DM：确认门控 / BLOCKED / 最终结果 / 长任务摘要

### 记忆
- 踩坑即记，不用问
- Text > Brain

---

## 历史纠偏（已失效 / 被覆盖）

### ❌ YYYY-MM-DD <旧标题>
- **失效原因**: <原因>
- **Superseded by**: <新口径>

---

**最后更新**: YYYY-MM-DD
