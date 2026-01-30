# 02 配置说明（`.env`）

本项目通过 `.env` 为 `docker compose` 提供环境变量。模板见仓库根目录 `.env.example`。

## 必改项（生产/多人协作必须）

- **`N8N_RUNNERS_AUTH_TOKEN`**
  - 用途：n8n 与 external runners 之间的鉴权
  - 要求：强密码；并确保 `n8n` 和 `n8n-runners` 两侧一致（本项目两侧都从同一份 `.env` 读取）

## n8n 基础配置

- **`N8N_DEFAULT_LOCALE`**：默认语言（示例：`zh-CN`）
- **`N8N_PORT`**：容器内监听端口（默认 `5678`，通常不需要改）
- **`N8N_HOST` / `N8N_LISTEN_ADDRESS`**：监听地址（默认 `0.0.0.0`）

> 对外访问端口由 `docker-compose.yml` 控制：默认 `15678:5678`。

## 隐私 / 关闭上报（建议保持）

- `N8N_DIAGNOSTICS_ENABLED=false`
- `N8N_VERSION_NOTIFICATIONS_ENABLED=false`
- `N8N_TEMPLATES_ENABLED=false`
- `EXTERNAL_FRONTEND_HOOKS_URLS=`（留空）
- `N8N_DIAGNOSTICS_CONFIG_FRONTEND=`（留空）
- `N8N_DIAGNOSTICS_CONFIG_BACKEND=`（留空）

## External Task Runners（重点）

启用 external runners 的关键变量：

- **`N8N_RUNNERS_ENABLED=true`**：开启 runners
- **`N8N_RUNNERS_MODE=external`**：使用外置模式
- **`N8N_RUNNERS_AUTH_TOKEN=...`**：鉴权 token（必改）
- **`N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0`**：让 broker 对其他容器可达（否则 runners 可能连不上）
- **`N8N_RUNNERS_BROKER_PORT=5679`**：broker 端口
- **`N8N_RUNNERS_TASK_BROKER_URI=http://n8n:5679`**
  - 含义：`n8n-runners` 访问 `n8n` 容器 broker 的地址
  - 注意：这里的 `n8n` 是 compose 网络内的服务名，不是宿主机 `localhost`

## runners 镜像构建参数（可选）

本仓库的 `n8n_runners/Dockerfile` 支持通过 build args 安装额外依赖；你可以在 `.env` 中定义：

- `RUNNERS_BASE_IMAGE`：runners 基础镜像（默认 `n8nio/runners:latest`）
- `RUNNERS_JS_DEPS`：JavaScript 依赖（空格分隔，如：`moment uuid`）
- `RUNNERS_PY_DEPS`：Python 依赖（空格分隔，如：`numpy pandas`）

改完后重建：

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

