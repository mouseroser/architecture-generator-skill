---
name: architecture-generator
description: 为 OpenClaw 实例生成、验证、导出、导入和升级完整架构。支持一键初始化、架构迁移、版本升级和模板管理。
---

# Architecture Generator

为 OpenClaw 实例生成和管理完整架构的顶层 skill。

## When This Skill Triggers

使用本 skill 当：
- 初始化新的 OpenClaw 实例
- 验证现有架构是否符合最佳实践
- 导出架构配置用于备份或迁移
- 导入架构配置到新机器
- 升级架构到最新版本
- 使用架构模板快速搭建

## Architecture Overview

```
workspace/
├── SOUL.md                    # Main agent 人格
├── IDENTITY.md                # Main agent 快速参考
├── AGENTS.md                  # 根级行为规则
├── USER.md                    # 关于用户
├── MEMORY.md                  # Main agent 长期记忆
├── HEARTBEAT.md               # 自愈检查
├── TOOLS.md                   # 工具配置
├── MEMORY-ARCHITECTURE.md     # 记忆架构说明
├── shared-context/
│   ├── THESIS.md              # 当前世界观
│   ├── FEEDBACK-LOG.md        # 跨 agent 纠正
│   └── SIGNALS.md             # 追踪趋势
├── intel/
│   ├── DAILY-INTEL.md         # 每日情报
│   └── collaboration/         # 多 agent 协作
├── agents/
│   ├── coding/
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   └── HEARTBEAT.md
│   ├── review/
│   ├── test/
│   └── ...
├── memory/
│   ├── YYYY-MM-DD.md          # 每日日志
│   └── archive/               # 归档
├── scripts/
│   ├── layer1-compress-check.sh
│   └── layer2-health-check.sh
└── skills/
    ├── agent-config-generator/
    ├── memory-architecture-manager/
    └── architecture-generator/
```

## Required Read

执行前必读：
1. `references/architecture-spec.md` - 完整架构规范
2. `references/template-library.md` - 架构模板库
3. `~/.openclaw/workspace/AGENTS.md` - 当前配置（如果存在）

## Usage

### 初始化新实例

```
使用 architecture-generator skill 初始化新实例
```

### 验证现有架构

```
使用 architecture-generator skill 验证架构
```

### 导出架构配置

```
使用 architecture-generator skill 导出架构
```

### 导入架构配置

```
使用 architecture-generator skill 导入架构 from <snapshot-file>
```

### 升级架构版本

```
使用 architecture-generator skill 升级架构到 v2.6
```

### 使用模板

```
使用 architecture-generator skill 使用模板 <template-name>
```

## Operations

### 1. Initialize（初始化）

**目的**: 为新的 OpenClaw 实例创建完整架构

**步骤**:

#### Step 1: 检查现有架构
```bash
# 检查是否已有架构
if [ -f ~/.openclaw/workspace/AGENTS.md ]; then
    echo "⚠️ 架构已存在，是否覆盖？"
    # 等待确认
fi
```

#### Step 2: 创建目录结构
```bash
mkdir -p ~/.openclaw/workspace/{shared-context,intel/collaboration,agents,memory/archive,scripts,skills}
```

#### Step 3: 生成根级文件
- `SOUL.md` - 从模板生成
- `IDENTITY.md` - 从模板生成
- `AGENTS.md` - 从模板生成
- `USER.md` - 交互式收集信息
- `MEMORY.md` - 从模板生成
- `HEARTBEAT.md` - 从模板生成
- `TOOLS.md` - 从模板生成
- `MEMORY-ARCHITECTURE.md` - 从模板生成

#### Step 4: 生成 shared-context/
- `THESIS.md` - 从模板生成
- `FEEDBACK-LOG.md` - 从模板生成
- `SIGNALS.md` - 从模板生成

#### Step 5: 生成 intel/
- `DAILY-INTEL.md` - 从模板生成
- `collaboration/` - 创建目录

#### Step 6: 调用 agent-config-generator
```
使用 agent-config-generator skill 为以下 agent 生成配置：
- coding
- review
- test
- gemini
- notebooklm
- brainstorming
- docs
- wemedia
- nano-banana
- monitor-bot
- claude
- openai
```

#### Step 7: 调用 memory-architecture-manager
```
使用 memory-architecture-manager skill 初始化三层记忆架构
```

#### Step 8: 创建维护脚本
- `scripts/layer1-compress-check.sh`
- `scripts/layer2-health-check.sh`

#### Step 9: 创建 Cron 任务
- layer2-health-check（每天 02:00）
- memory-quality-audit（每天 03:00）
- daily-memory-report（每天 05:00）
- layer1-compress-check（每周日 04:00）
- MEMORY.md 维护（每周日 22:00）
- memory-archive-weekly-sync（每周日 23:00）

#### Step 10: 生成初始化报告
```markdown
# 初始化报告

## 创建的目录
- workspace/
- shared-context/
- intel/
- agents/ (12 个 agent)
- memory/
- scripts/
- skills/

## 创建的文件
- 8 个根级文件
- 3 个 shared-context/ 文件
- 36 个 agent 配置文件（12 agents × 3 files）
- 2 个维护脚本

## 创建的 Cron 任务
- 6 个自动化任务

## 下一步
1. 编辑 USER.md 填写用户信息
2. 编辑 SOUL.md 定义 agent 人格
3. 运行验证：使用 architecture-generator skill 验证架构
```

**输出**: 初始化报告 + 架构验证结果

---

### 2. Validate（验证）

**目的**: 验证架构是否完整且符合最佳实践

**检查项**:

#### 根级文件验证
- ✅ SOUL.md 存在且非空
- ✅ IDENTITY.md 存在且非空
- ✅ AGENTS.md 存在且包含 "Every Session" 规则
- ✅ USER.md 存在且包含用户信息
- ✅ MEMORY.md 存在
- ✅ HEARTBEAT.md 存在
- ✅ TOOLS.md 存在
- ✅ MEMORY-ARCHITECTURE.md 存在

#### 目录结构验证
- ✅ shared-context/ 存在
- ✅ intel/ 存在
- ✅ agents/ 存在
- ✅ memory/ 存在
- ✅ scripts/ 存在
- ✅ skills/ 存在

#### shared-context/ 验证
- ✅ THESIS.md 存在
- ✅ FEEDBACK-LOG.md 存在
- ✅ SIGNALS.md 存在

#### Agent 配置验证
```
调用 agent-config-generator skill 验证所有 agent 配置
```

#### 记忆系统验证
```
调用 memory-architecture-manager skill 验证记忆架构
```

#### Cron 任务验证
- ✅ layer2-health-check 存在且启用
- ✅ memory-quality-audit 存在且启用
- ✅ daily-memory-report 存在且启用
- ✅ layer1-compress-check 存在且启用
- ✅ MEMORY.md 维护存在且启用
- ✅ memory-archive-weekly-sync 存在且启用

#### 单写者原则验证
- ✅ AGENTS.md 包含单写者原则说明
- ✅ shared-context/ 文件所有权明确
- ✅ intel/ 文件所有权明确

**输出**: 验证报告（通过/失败/警告）

---

### 3. Export（导出）

**目的**: 导出架构配置用于备份或迁移

**步骤**:

#### Step 1: 收集架构信息
```json
{
  "version": "2.6",
  "timestamp": "2026-03-12T16:10:00+08:00",
  "workspace": "~/.openclaw/workspace",
  "agents": [
    "coding", "review", "test", "gemini", "notebooklm",
    "brainstorming", "docs", "wemedia", "nano-banana",
    "monitor-bot", "claude", "openai"
  ],
  "cron_tasks": [
    "layer2-health-check",
    "memory-quality-audit",
    "daily-memory-report",
    "layer1-compress-check",
    "MEMORY.md 维护",
    "memory-archive-weekly-sync"
  ]
}
```

#### Step 2: 导出文件列表
```json
{
  "root_files": [
    "SOUL.md", "IDENTITY.md", "AGENTS.md", "USER.md",
    "MEMORY.md", "HEARTBEAT.md", "TOOLS.md",
    "MEMORY-ARCHITECTURE.md"
  ],
  "shared_context": [
    "THESIS.md", "FEEDBACK-LOG.md", "SIGNALS.md"
  ],
  "intel": [
    "DAILY-INTEL.md"
  ],
  "agents": {
    "coding": ["SOUL.md", "IDENTITY.md", "HEARTBEAT.md"],
    "review": ["SOUL.md", "IDENTITY.md", "HEARTBEAT.md"],
    ...
  }
}
```

#### Step 3: 生成快照文件
```bash
# 创建快照目录
mkdir -p ~/.openclaw/snapshots/

# 生成快照
tar -czf ~/.openclaw/snapshots/architecture-$(date +%Y%m%d-%H%M%S).tar.gz \
  -C ~/.openclaw/workspace \
  --exclude='memory/*.md' \
  --exclude='memory/archive/*' \
  .
```

#### Step 4: 生成元数据
```json
{
  "snapshot_id": "architecture-20260312-161000",
  "version": "2.6",
  "timestamp": "2026-03-12T16:10:00+08:00",
  "file_count": 50,
  "size": "2.3 MB",
  "checksum": "sha256:abc123..."
}
```

**输出**: 快照文件路径 + 元数据

---

### 4. Import（导入）

**目的**: 从快照恢复架构到新机器

**步骤**:

#### Step 1: 验证快照
```bash
# 检查快照文件
if [ ! -f "$snapshot_file" ]; then
    echo "❌ 快照文件不存在"
    exit 1
fi

# 验证 checksum
sha256sum -c "$snapshot_file.sha256"
```

#### Step 2: 解压快照
```bash
# 备份现有架构（如果存在）
if [ -d ~/.openclaw/workspace ]; then
    mv ~/.openclaw/workspace ~/.openclaw/workspace.backup-$(date +%Y%m%d-%H%M%S)
fi

# 解压快照
tar -xzf "$snapshot_file" -C ~/.openclaw/workspace
```

#### Step 3: 调整路径
```bash
# 更新所有文件中的路径引用
find ~/.openclaw/workspace -type f -name "*.md" -exec sed -i '' 's|/old/path|/new/path|g' {} \;
```

#### Step 4: 重新创建 Cron 任务
```
读取快照中的 Cron 任务配置
重新创建所有 Cron 任务
```

#### Step 5: 验证导入
```
调用 architecture-generator skill 验证架构
```

**输出**: 导入报告 + 验证结果

---

### 5. Upgrade（升级）

**目的**: 升级架构到最新版本

**支持的升级路径**:
- v2.5 → v2.6
- v2.4 → v2.6
- v2.3 → v2.6

**步骤**:

#### Step 1: 检测当前版本
```bash
# 从 AGENTS.md 读取版本信息
current_version=$(grep "星链流水线 v" ~/.openclaw/workspace/AGENTS.md | head -1 | sed 's/.*v\([0-9.]*\).*/\1/')
```

#### Step 2: 备份当前架构
```
调用 architecture-generator skill 导出架构
```

#### Step 3: 执行升级脚本
```bash
# v2.5 → v2.6 升级
if [ "$current_version" = "2.5" ]; then
    # 1. 更新 review agent 配置（不再编排）
    # 2. 更新 AGENTS.md（v2.6 规则）
    # 3. 更新 Cron 任务
    # 4. 更新 shared-context/FEEDBACK-LOG.md
fi
```

#### Step 4: 验证升级
```
调用 architecture-generator skill 验证架构
```

#### Step 5: 生成升级报告
```markdown
# 升级报告

## 升级路径
v2.5 → v2.6

## 变更内容
- Review agent 不再编排其他 agent
- 更新 AGENTS.md 规则
- 新增 Cron 任务

## 备份位置
~/.openclaw/snapshots/architecture-20260312-161000.tar.gz

## 验证结果
✅ 所有检查通过
```

**输出**: 升级报告 + 验证结果

---

### 6. Template（模板）

**目的**: 使用预定义模板快速搭建架构

**可用模板**:

1. **minimal** - 最小架构
   - 只有 main agent
   - 基础记忆系统
   - 适合个人使用

2. **standard** - 标准架构（默认）
   - 12 个 agent
   - 三层记忆架构
   - 完整 Cron 任务
   - 适合大多数场景

3. **enterprise** - 企业架构
   - 20+ agent
   - 高级记忆系统
   - 完整监控和告警
   - 适合团队使用

4. **custom** - 自定义模板
   - 基于现有架构创建
   - 支持模板继承

**步骤**:

#### Step 1: 选择模板
```bash
# 列出可用模板
ls ~/.openclaw/skills/architecture-generator/templates/
```

#### Step 2: 加载模板
```bash
# 读取模板配置
template_config=$(cat templates/$template_name/config.json)
```

#### Step 3: 应用模板
```
根据模板配置调用 Initialize 功能
```

**输出**: 初始化报告

---

## Integration with Other Skills

### agent-config-generator
- Initialize 时调用生成 agent 配置
- Validate 时调用验证 agent 配置

### memory-architecture-manager
- Initialize 时调用初始化记忆系统
- Validate 时调用验证记忆系统

---

## Examples

### 示例 1: 初始化新实例

```
使用 architecture-generator skill 初始化新实例

输出:
✅ 创建目录结构（7 个目录）
✅ 生成根级文件（8 个文件）
✅ 生成 shared-context/（3 个文件）
✅ 生成 agent 配置（12 agents × 3 files）
✅ 创建维护脚本（2 个脚本）
✅ 创建 Cron 任务（6 个任务）

🎉 架构初始化完成！

下一步:
1. 编辑 USER.md 填写用户信息
2. 编辑 SOUL.md 定义 agent 人格
3. 运行验证
```

### 示例 2: 验证架构

```
使用 architecture-generator skill 验证架构

输出:
✅ 根级文件: 通过 (8/8)
✅ 目录结构: 通过 (6/6)
✅ shared-context/: 通过 (3/3)
✅ Agent 配置: 通过 (12/12)
✅ 记忆系统: 通过 (3/3)
✅ Cron 任务: 通过 (6/6)
✅ 单写者原则: 通过

整体评分: 100/100（优秀）
```

### 示例 3: 导出架构

```
使用 architecture-generator skill 导出架构

输出:
✅ 收集架构信息
✅ 导出文件列表
✅ 生成快照文件
✅ 生成元数据

快照已保存:
~/.openclaw/snapshots/architecture-20260312-161000.tar.gz

元数据:
- 版本: v2.6
- 文件数: 50
- 大小: 2.3 MB
- Checksum: sha256:abc123...
```

### 示例 4: 导入架构

```
使用 architecture-generator skill 导入架构 from ~/.openclaw/snapshots/architecture-20260312-161000.tar.gz

输出:
✅ 验证快照
✅ 备份现有架构
✅ 解压快照
✅ 调整路径
✅ 重新创建 Cron 任务
✅ 验证导入

🎉 架构导入完成！

验证结果: 100/100（优秀）
```

### 示例 5: 升级架构

```
使用 architecture-generator skill 升级架构到 v2.6

输出:
✅ 检测当前版本: v2.5
✅ 备份当前架构
✅ 执行升级脚本
  - 更新 review agent 配置
  - 更新 AGENTS.md 规则
  - 更新 Cron 任务
✅ 验证升级

🎉 架构升级完成！

升级路径: v2.5 → v2.6
备份位置: ~/.openclaw/snapshots/architecture-20260312-161000.tar.gz
验证结果: 100/100（优秀）
```

---

## Notes

- 初始化前会检查是否已有架构，避免覆盖
- 导出时会排除 memory/ 中的日志文件（太大）
- 导入时会自动调整路径引用
- 升级时会自动备份当前架构
- 所有操作都会生成详细报告

## Version History

- v1.0 (2026-03-12): 初始版本
  - 支持初始化、验证、导出、导入、升级、模板
  - 集成 agent-config-generator 和 memory-architecture-manager
