# GTMark

在 Cursor 中集成 5 个 Agent 框架的统一入口：

| 框架 | 用途 | 接入方式 |
|------|------|----------|
| [DeerFlow](https://github.com/bytedance/deer-flow) | 深度研究、子代理、沙箱 | Gateway `:8001` / Web `:2026` |
| [Prompt Optimizer](https://github.com/linshenkx/prompt-optimizer) | 提示词优化 | MCP HTTP |
| [ECC](https://github.com/affaan-m/ECC) | 技能 / 钩子 / 规则 | `.cursor/` 自动生效 |
| [Ruflo](https://github.com/ruvnet/ruflo) | 群体智能、跨会话记忆 | MCP stdio |
| [Letta](https://github.com/letta-ai/letta) | 长期记忆代理 | MCP stdio |

## 快速开始

```bash
# 1. 克隆本仓库
git clone https://github.com/ruancanghui-hub/GTMark.git
cd GTMark

# 2. 配置 API Key
cp .env.example .env
# 编辑 .env，填入 DEEPSEEK_API_KEY 等

# 3. 克隆并安装五个框架
bash scripts/setup-frameworks.sh

# 4. 一键启动服务
bash start.sh

# 5. Cursor → Settings → MCP → Reload
```

## 串联使用

### 写项目（推荐）

加载 skill **`gtmark-project-pipeline`**，在 Cursor 对话中：

```text
用 gtmark-project-pipeline 从零写项目：

项目名：MyApp
目标：【一句话描述】
要求：【技术栈、功能、测试等】
```

流水线：Prompt Optimizer → DeerFlow 调研 → 写代码 → Ruflo 沉淀 → Letta 长期记忆。

### 单任务串联

```text
用 agent-frameworks 串联五个框架：
1. prompt-optimizer 优化 prompt
2. deer-flow 深度调研
3. ruflo 存结论
4. letta 更新长期记忆代理

我的任务：【你的具体任务】
```

## 常用命令

```bash
bash start.sh                      # 启动 Prompt Optimizer + DeerFlow
bash stop.sh                       # 停止全部
bash scripts/health-check.sh       # 健康检查
```

## 目录结构

```
.cursor/          # MCP 配置、Skills、ECC hooks/rules
scripts/          # 安装、启动、MCP wrapper 脚本
integrations/     # 由 setup-frameworks.sh 克隆（gitignore）
.env.example      # 环境变量模板
```

## 说明

- **DeerFlow** 不是 MCP 服务，通过 http://localhost:2026 使用
- **Ruflo** 固定版本 `3.7.0-alpha.9`（`latest` 有已知 bug）
- 首次使用 DeerFlow 需访问 `/setup` 创建管理员账号
