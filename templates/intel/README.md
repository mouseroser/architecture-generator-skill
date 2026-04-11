# intel/ - 情报层

> 用于存放 agent 间协作产物和情报信息。

---

## 目录结构

```
intel/
├── README.md           # 本文件
└── collaboration/      # 各流水线协作产物
    └── <pipeline-name>/  # 按业务线组织
```

---

## 核心原则

### 1. 单写者原则
- 每个子目录只允许一个 agent 写入
- 其他 agent 只读
- 避免并发写入冲突

### 2. 协作产物走 intel/collaboration/
- 流水线协作交付物统一放 `intel/collaboration/{业务线}/`
- Agent 自留记录走 `memory/`
- 不在 agent 私有目录存放协作产物

### 3. 文件命名规范
- 使用描述性文件名
- 包含日期时使用 `YYYY-MM-DD` 格式
- 避免空格，使用 `-` 或 `_` 分隔

---

## 使用场景

根据实际业务需求，在 `collaboration/` 下创建对应的业务线目录，例如：
- 开发流水线协作产物
- 研究/方案流水线协作产物
- 内容运营流水线协作产物

每个业务线目录下按 agent 职责或工作阶段组织子目录。

---

**维护者**：architecture-generator skill
