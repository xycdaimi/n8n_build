# n8n_build（n8n Docker 部署 + External Runners）

这个仓库用于**用 Docker Compose 部署 n8n**，并启用 **External Task Runners**：

- **`n8n` 主容器**：只负责 n8n 本体（更稳定/更安全）
- **`n8n-runners` 容器**：负责执行 JS/Python 等任务（可扩展依赖）
- **`dist/` 覆盖 editor UI**：compose 会把 `./dist` 只读挂载到容器内的 editor-ui dist 目录

## 快速开始

### 前置依赖

- **Docker Desktop**（包含 Docker Engine + Docker Compose）
- Windows 用户建议开启 WSL2（非必须，但更稳）

### 1) 准备 `.env`

仓库已提供模板：`.env.example`

Windows（PowerShell / CMD）：

```bash
copy .env.example .env
```

Linux/macOS：

```bash
cp .env.example .env
```

然后打开 `.env`，至少修改：

- **`N8N_RUNNERS_AUTH_TOKEN`**：把 `change-this-to-a-real-secret` 改成真实强密码（n8n 与 runners 必须一致）

### 2) 启动

Windows：

```bash
.\start.bat
```

Linux/macOS：

```bash
./start.sh
```

启动后访问：`http://localhost:15678`

> 端口映射在 `docker-compose.yml`：宿主 `15678 -> 容器 5678`，以及调试用 `15679 -> 5679`（task broker）。

### 3) 停止 / 重启

停止：

```bash
.\stop.bat
```

或：

```bash
./stop.sh
```

重启（不重新 build）：

```bash
.\restart.bat
```

或：

```bash
./restart.sh
```

## 目录与数据持久化

- **`./.n8n/`**：n8n 运行数据目录（数据库、凭据、加密密钥、日志等）
  - `docker-compose.yml` 将其挂载到容器：`/home/node/.n8n`
  - **重要**：该目录包含敏感信息，已在 `.gitignore` 中默认忽略
- **`./dist/`**：用于覆盖 editor UI 的前端静态产物（以只读方式挂载到容器）

### 备份建议（强烈建议）

请把 `./.n8n/` 当作“数据盘”对待：

- 迁移/重装机器前备份整个 `./.n8n/`
- **不要更换/丢失**其中的加密相关配置，否则历史凭据可能无法解密

## 配置说明（`.env`）

仓库提供的 `.env.example` 已包含常用配置：

- **`N8N_DEFAULT_LOCALE`**：默认语言（示例为 `zh-CN`）
- **`N8N_PORT / N8N_HOST / N8N_LISTEN_ADDRESS`**：监听配置（容器内通常保持默认即可）
- **隐私/关闭上报**：
  - `N8N_DIAGNOSTICS_ENABLED=false`
  - `N8N_VERSION_NOTIFICATIONS_ENABLED=false`
  - `N8N_TEMPLATES_ENABLED=false`
- **External Runners（关键）**：
  - `N8N_RUNNERS_ENABLED=true`
  - `N8N_RUNNERS_MODE=external`
  - `N8N_RUNNERS_AUTH_TOKEN=...`（必须设置）
  - `N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0`（确保 runners 能连进来）
  - `N8N_RUNNERS_BROKER_PORT=5679`
  - `N8N_RUNNERS_TASK_BROKER_URI=http://n8n:5679`（runners 访问 n8n broker 的地址）

## 自定义 runners 依赖（Python / JS）

`n8n_runners/Dockerfile` 支持通过 build args 安装额外依赖：

- **JS 依赖**：安装到 task-runner-javascript（使用 `pnpm add`）
- **Python 依赖**：安装到 task-runner-python（使用 `uv pip install`）

在 `.env` 里设置（可选）：

- `RUNNERS_JS_DEPS=moment uuid`
- `RUNNERS_PY_DEPS=numpy pandas`

然后重新构建启动：

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

## 常见问题（Troubleshooting）

- **提示缺少 `.env`**
  - 解决：从 `.env.example` 复制生成 `.env`（见“快速开始”）
- **runners 连不上 / 任务不执行**
  - 检查：`N8N_RUNNERS_AUTH_TOKEN` 在 `n8n` 与 `n8n-runners` 两侧是否一致
  - 检查：`N8N_RUNNERS_BROKER_LISTEN_ADDRESS` 是否为 `0.0.0.0`
- **我不小心把 `.n8n/` 或 `.env` 提交到了 git**
  - 处理：先确保 `.gitignore` 已忽略，然后执行：

```bash
git rm -r --cached .n8n
git rm --cached .env
```

## 安全注意事项

- **不要提交**：`.env`、`./.n8n/`（包含密钥/凭据/数据库）
- **务必设置强密码**：`N8N_RUNNERS_AUTH_TOKEN`
