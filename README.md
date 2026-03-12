# Architecture Generator

为 OpenClaw 实例生成和管理完整架构的顶层 skill。

## 快速开始

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
使用 architecture-generator skill 使用模板 standard
```

---

## 核心功能

### 1. Initialize（初始化）
为新的 OpenClaw 实例创建完整架构。

**包含**:
- ✅ 创建目录结构（7 个目录）
- ✅ 生成根级文件（8 个文件）
- ✅ 生成 shared-context/（3 个文件）
- ✅ 生成 agent 配置（12 agents × 3 files）
- ✅ 创建维护脚本（2 个脚本）
- ✅ 创建 Cron 任务（6 个任务）

### 2. Validate（验证）
验证架构是否完整且符合最佳实践。

**检查项**:
- ✅ 根级文件完整性
- ✅ 目录结构完整性
- ✅ Agent 配置完整性
- ✅ 记忆系统完整性
- ✅ Cron 任务配置
- ✅ 单写者原则

### 3. Export（导出）
导出架构配置用于备份或迁移。

**输出**:
- ✅ 快照文件（.tar.gz）
- ✅ 元数据（版本、文件数、大小、checksum）

### 4. Import（导入）
从快照恢复架构到新机器。

**功能**:
- ✅ 验证快照
- ✅ 备份现有架构
- ✅ 解压快照
- ✅ 调整路径
- ✅ 重新创建 Cron 任务

### 5. Upgrade（升级）
升级架构到最新版本。

**支持的升级路径**:
- v2.5 → v2.6
- v2.4 → v2.6
- v2.3 → v2.6

### 6. Template（模板）
使用预定义模板快速搭建架构。

**可用模板**:
- minimal - 最小架构（个人使用）
- standard - 标准架构（推荐）
- enterprise - 企业架构（团队使用）
- custom - 自定义模板

---

## 文件结构

```
architecture-generator/
├── SKILL.md                              # Skill 主文档
├── README.md                             # 本文件
└── references/
    ├── architecture-spec.md              # 完整架构规范
    └── template-library.md               # 架构模板库
```

---

## 与其他 Skills 的关系

### 协调关系

```
architecture-generator (顶层)
    ↓
    ├─ agent-config-generator (Agent 配置)
    └─ memory-architecture-manager (记忆系统)
```

**architecture-generator 调用其他 skills**:
- 初始化时调用 agent-config-generator 生成 agent 配置
- 初始化时调用 memory-architecture-manager 初始化记忆系统
- 验证时调用两者的验证功能

---

## 使用场景

### 场景 1: 新实例初始化
当你设置新的 OpenClaw 实例时，使用本 skill 一键初始化完整架构。

**优势**:
- ✅ 无需手动创建 50+ 个文件
- ✅ 保证架构一致性
- ✅ 自动配置所有 agent
- ✅ 自动创建 Cron 任务

### 场景 2: 架构迁移
当你需要将架构迁移到新机器时，使用导出/导入功能。

**优势**:
- ✅ 一键导出完整配置
- ✅ 自动调整路径
- ✅ 保留所有设置

### 场景 3: 架构升级
当新版本发布时，使用升级功能一键升级。

**优势**:
- ✅ 自动备份当前架构
- ✅ 安全升级
- ✅ 保留现有数据

### 场景 4: 模板使用
当你需要快速搭建特定类型的架构时，使用模板功能。

**优势**:
- ✅ 预定义配置
- ✅ 快速搭建
- ✅ 最佳实践

---

## 核心优势

### 1. 一键初始化
- ✅ 无需手动创建目录和文件
- ✅ 自动配置所有 agent
- ✅ 自动创建 Cron 任务
- ✅ 验证所有依赖

### 2. 保证一致性
- ✅ 基于模板生成
- ✅ 不会遗漏文件
- ✅ 符合最佳实践
- ✅ 单写者原则

### 3. 支持演进
- ✅ 架构版本管理
- ✅ 一键升级
- ✅ 保留现有数据
- ✅ 自动备份

### 4. 降低门槛
- ✅ 新用户友好
- ✅ 详细的文档
- ✅ 清晰的报告
- ✅ 错误提示

---

## 示例输出

### 初始化输出

```
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

### 验证输出

```
✅ 根级文件: 通过 (8/8)
✅ 目录结构: 通过 (6/6)
✅ shared-context/: 通过 (3/3)
✅ Agent 配置: 通过 (12/12)
✅ 记忆系统: 通过 (3/3)
✅ Cron 任务: 通过 (6/6)
✅ 单写者原则: 通过

整体评分: 100/100（优秀）
```

### 导出输出

```
✅ 收集架构信息
✅ 导出文件列表
✅ 生成快照文件
✅ 生成元数据

快照已保存:
~/.openclaw/snapshots/architecture-20260312-161200.tar.gz

元数据:
- 版本: v2.6
- 文件数: 50
- 大小: 2.3 MB
- Checksum: sha256:abc123...
```

---

## 模板对比

| 维度 | minimal | standard | enterprise |
|------|---------|----------|------------|
| **Sub-agents** | 0 个 | 12 个 | 20+ 个 |
| **记忆系统** | 基础 | 三层 | 三层 + 高级 |
| **Cron 任务** | 2 个 | 6 个 | 10+ 个 |
| **文件数量** | ~10 | ~50 | ~100 |
| **初始化时间** | ~1 分钟 | ~5 分钟 | ~10 分钟 |
| **适用场景** | 个人/学习 | 大多数场景 | 团队/企业 |

---

## 版本历史

- v1.0 (2026-03-12): 初始版本
  - 支持初始化、验证、导出、导入、升级、模板
  - 集成 agent-config-generator 和 memory-architecture-manager
  - 提供 3 个预定义模板（minimal, standard, enterprise）

---

**创建时间**: 2026-03-12 16:13
**维护者**: main (小光)
