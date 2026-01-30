# 03 External Task Runners

本仓库采用 **External Task Runners** 模式：

- **`n8n` 主容器**：只跑 n8n（Node.js），不在主容器里安装 Python/额外 JS 依赖
- **`n8n-runners` 容器**：负责执行任务（可按需扩展依赖）

这样做的好处：

- 主容器更精简、更安全，升级/维护成本更低
- 任务执行环境可独立扩展（尤其是 Python 依赖）

## 关键通信与鉴权

### 1) 鉴权 token

`N8N_RUNNERS_AUTH_TOKEN` 是 n8n 与 runners 的共享密钥：

- 必须设置强密码
- 两侧必须一致（本项目通过同一份 `.env` 注入给两个服务）

### 2) broker 可达性

如果 broker 只监听 `127.0.0.1`，在容器网络里会导致 `n8n-runners` 无法连接。

因此模板中设置了：

- `N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0`

## 扩展 runners 依赖（推荐方式）

`n8n_runners/Dockerfile` 支持通过 build args 安装依赖：

- **JS 依赖**：在 `task-runner-javascript` 中执行 `pnpm add`
- **Python 依赖**：在 `task-runner-python` 中执行 `uv pip install`

### 方式 A：通过 `.env` 覆盖（推荐）

编辑 `.env`：

- `RUNNERS_JS_DEPS=moment uuid`
- `RUNNERS_PY_DEPS=numpy pandas`

然后重新 build：

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

### 方式 B：直接改 `docker-compose.yml` 的默认值

`docker-compose.yml` 中对 build args 有默认值（便于开箱即用）。如果你希望把依赖“写死”在仓库中，直接改 compose 即可。

## 常见问题

- **runners 不工作 / 任务不执行**
  - 检查 `N8N_RUNNERS_AUTH_TOKEN` 是否已设置且一致
  - 检查 `N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0`
  - 重新构建 runners：`docker compose --env-file .env up -d --build --remove-orphans`

