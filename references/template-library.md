# Template Library

OpenClaw 架构模板库。

---

## 可用模板

### 1. minimal - 最小架构

**适用场景**:
- 个人使用
- 快速原型
- 学习 OpenClaw

**包含内容**:
- ✅ Main agent 配置（SOUL.md, IDENTITY.md, USER.md, MEMORY.md, HEARTBEAT.md）
- ✅ 基础记忆系统（memory/）
- ✅ 基础 Cron 任务（2 个）
- ❌ 无 sub-agents
- ❌ 无 shared-context/
- ❌ 无 intel/

**文件数量**: ~10 个文件

**初始化时间**: ~1 分钟

**使用方式**:
```
使用 architecture-generator skill 使用模板 minimal
```

---

### 2. standard - 标准架构（默认）

**适用场景**:
- 大多数使用场景
- 完整功能
- 推荐使用

**包含内容**:
- ✅ Main agent 配置
- ✅ 12 个 sub-agents（coding, review, test, etc.）
- ✅ 三层记忆架构
- ✅ shared-context/（THESIS.md, FEEDBACK-LOG.md, SIGNALS.md）
- ✅ intel/（DAILY-INTEL.md, collaboration/）
- ✅ 完整 Cron 任务（6 个）
- ✅ 维护脚本（2 个）

**文件数量**: ~50 个文件

**初始化时间**: ~5 分钟

**使用方式**:
```
使用 architecture-generator skill 初始化新实例
```
或
```
使用 architecture-generator skill 使用模板 standard
```

---

### 3. enterprise - 企业架构

**适用场景**:
- 团队使用
- 高级功能
- 完整监控

**包含内容**:
- ✅ Main agent 配置
- ✅ 20+ sub-agents（包括 standard 的 12 个 + 额外 agent）
- ✅ 三层记忆架构 + 高级功能
- ✅ shared-context/ + 扩展
- ✅ intel/ + 团队协作
- ✅ 完整 Cron 任务（10+ 个）
- ✅ 维护脚本（5+ 个）
- ✅ 监控和告警
- ✅ 性能优化

**额外 agent**:
- analytics - 数据分析者
- security - 安全审计者
- performance - 性能优化者
- deployment - 部署管理者
- backup - 备份管理者
- notification - 通知管理者
- scheduler - 任务调度者
- logger - 日志管理者

**文件数量**: ~100 个文件

**初始化时间**: ~10 分钟

**使用方式**:
```
使用 architecture-generator skill 使用模板 enterprise
```

---

### 4. custom - 自定义模板

**适用场景**:
- 特殊需求
- 基于现有架构
- 模板继承

**创建方式**:
```
使用 architecture-generator skill 创建自定义模板 from 当前架构
```

**使用方式**:
```
使用 architecture-generator skill 使用模板 custom/<template-name>
```

---

## 模板对比

| 维度 | minimal | standard | enterprise |
|------|---------|----------|------------|
| **Main agent** | ✅ | ✅ | ✅ |
| **Sub-agents** | ❌ | 12 个 | 20+ 个 |
| **记忆系统** | 基础 | 三层 | 三层 + 高级 |
| **shared-context/** | ❌ | ✅ | ✅ + 扩展 |
| **intel/** | ❌ | ✅ | ✅ + 团队 |
| **Cron 任务** | 2 个 | 6 个 | 10+ 个 |
| **维护脚本** | 0 个 | 2 个 | 5+ 个 |
| **监控告警** | ❌ | 基础 | 完整 |
| **文件数量** | ~10 | ~50 | ~100 |
| **初始化时间** | ~1 分钟 | ~5 分钟 | ~10 分钟 |
| **适用场景** | 个人/学习 | 大多数场景 | 团队/企业 |

---

## 模板详细配置

### minimal 模板

```json
{
  "name": "minimal",
  "version": "1.0",
  "description": "最小架构，适合个人使用",
  "agents": ["main"],
  "memory": {
    "layers": 1,
    "auto_capture": false,
    "auto_compress": false
  },
  "cron_tasks": [
    "daily-memory-report",
    "MEMORY.md 维护"
  ],
  "scripts": [],
  "shared_context": false,
  "intel": false
}
```

### standard 模板

```json
{
  "name": "standard",
  "version": "2.6",
  "description": "标准架构，推荐使用",
  "agents": [
    "main", "coding", "review", "test",
    "gemini", "notebooklm", "brainstorming",
    "docs", "wemedia", "nano-banana",
    "monitor-bot", "claude", "openai"
  ],
  "memory": {
    "layers": 3,
    "auto_capture": true,
    "auto_compress": true,
    "auto_sync": true
  },
  "cron_tasks": [
    "layer2-health-check",
    "memory-quality-audit",
    "daily-memory-report",
    "layer1-compress-check",
    "MEMORY.md 维护",
    "memory-archive-weekly-sync"
  ],
  "scripts": [
    "layer1-compress-check.sh",
    "layer2-health-check.sh"
  ],
  "shared_context": true,
  "intel": true
}
```

### enterprise 模板

```json
{
  "name": "enterprise",
  "version": "2.6",
  "description": "企业架构，适合团队使用",
  "agents": [
    "main", "coding", "review", "test",
    "gemini", "notebooklm", "brainstorming",
    "docs", "wemedia", "nano-banana",
    "monitor-bot", "claude", "openai",
    "analytics", "security", "performance",
    "deployment", "backup", "notification",
    "scheduler", "logger"
  ],
  "memory": {
    "layers": 3,
    "auto_capture": true,
    "auto_compress": true,
    "auto_sync": true,
    "advanced_features": true
  },
  "cron_tasks": [
    "layer2-health-check",
    "memory-quality-audit",
    "daily-memory-report",
    "layer1-compress-check",
    "MEMORY.md 维护",
    "memory-archive-weekly-sync",
    "security-audit",
    "performance-check",
    "backup-check",
    "deployment-check"
  ],
  "scripts": [
    "layer1-compress-check.sh",
    "layer2-health-check.sh",
    "security-audit.sh",
    "performance-check.sh",
    "backup-check.sh"
  ],
  "shared_context": true,
  "intel": true,
  "monitoring": true,
  "alerting": true
}
```

---

## 模板选择指南

### 选择 minimal 如果：
- ✅ 你是 OpenClaw 新手
- ✅ 只需要基础功能
- ✅ 个人使用
- ✅ 快速原型

### 选择 standard 如果：
- ✅ 你需要完整功能
- ✅ 需要多 agent 协作
- ✅ 需要自动化
- ✅ 大多数使用场景

### 选择 enterprise 如果：
- ✅ 团队使用
- ✅ 需要高级功能
- ✅ 需要完整监控
- ✅ 需要性能优化

### 选择 custom 如果：
- ✅ 有特殊需求
- ✅ 需要基于现有架构
- ✅ 需要模板继承

---

## 模板升级路径

```
minimal → standard → enterprise
   ↓         ↓           ↓
custom ← custom ← custom
```

**升级方式**:
```
使用 architecture-generator skill 升级架构到 standard
使用 architecture-generator skill 升级架构到 enterprise
```

---

## 创建自定义模板

### Step 1: 导出当前架构
```
使用 architecture-generator skill 导出架构
```

### Step 2: 创建模板配置
```json
{
  "name": "my-custom-template",
  "version": "1.0",
  "description": "我的自定义模板",
  "base_template": "standard",
  "agents": [...],
  "memory": {...},
  "cron_tasks": [...],
  "scripts": [...],
  "shared_context": true,
  "intel": true
}
```

### Step 3: 保存模板
```bash
mkdir -p ~/.openclaw/skills/architecture-generator/templates/my-custom-template/
cp config.json ~/.openclaw/skills/architecture-generator/templates/my-custom-template/
```

### Step 4: 使用模板
```
使用 architecture-generator skill 使用模板 my-custom-template
```

---

## 模板维护

### 更新模板
```
使用 architecture-generator skill 更新模板 <template-name>
```

### 删除模板
```
使用 architecture-generator skill 删除模板 <template-name>
```

### 列出所有模板
```
使用 architecture-generator skill 列出所有模板
```

---

**最后更新**: 2026-03-12 16:12
**维护者**: main (小光)
**可用模板**: minimal, standard, enterprise, custom
