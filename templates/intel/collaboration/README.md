# collaboration/ - 协作产物

> 各流水线的协作交付物存放目录。

---

## 目录结构

```
collaboration/
├── README.md               # 本文件
└── <pipeline-name>/        # 按业务线组织
    ├── README.md           # 该业务线说明
    └── <agent-or-stage>/   # 按 agent 职责或工作阶段组织
```

---

## 组织原则

### 1. 按业务线组织顶层目录
- 每个业务线一个目录
- 目录名使用描述性名称
- 例如：`dev-pipeline/`、`research-pipeline/`、`content-pipeline/`

### 2. 按 agent 职责或工作阶段组织子目录
- 每个子目录对应一个 agent 或一个工作阶段
- 明确单写者（一个子目录只允许一个 agent 写入）
- 其他 agent 只读

### 3. 每个业务线目录包含 README.md
- 说明该业务线的协作产物组织方式
- 列出单写者原则表（哪个目录由哪个 agent 负责）
- 说明消费者 agent 如何使用

---

## 单写者原则

| 目录 | 负责 agent | 说明 |
|------|-----------|------|
| `<pipeline-name>/<subdir>/` | `<agent-name>` | 该 agent 负责写入，其他 agent 只读 |

---

## 读取规则

- 消费者 agent 到对应目录读取
- 不在自己目录存放其他流水线的产物
- 保持目录职责清晰

---

**维护者**：architecture-generator skill
