# 06 常见问题排查（Troubleshooting）

## 1) 无法启动 / 提示缺少 `.env`

现象：

- `start.bat` 或 `start.sh` 报错提示缺少 `.env`

处理：

- 从模板复制：

```bash
copy .env.example .env
```

或：

```bash
cp .env.example .env
```

## 2) 页面打不开（无法访问 `http://localhost:15678`）

检查项：

- Docker Desktop 是否在运行
- 容器是否启动成功：

```bash
docker compose ps
```

- 端口是否被占用（尤其是 15678）
- 查看 n8n 日志：

```bash
docker compose logs -f n8n
```

## 3) runners 相关：任务不执行 / runners 连不上

重点检查：

- `.env` 中 `N8N_RUNNERS_AUTH_TOKEN` 是否已设置为强密码（不要留默认示例）
- `N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0` 是否存在（否则容器间不可达）
- `N8N_RUNNERS_TASK_BROKER_URI` 是否为 `http://n8n:5679`

建议操作：

```bash
docker compose logs -f n8n-runners
```

如果你改了 runners 依赖或配置，重建：

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

## 4) 我改了 `.env` 但没有生效

说明：

- compose 在启动/重建时读取 `.env`；如果只是 `restart`，不会重新 build，但环境变量通常会随容器重建才更新。

建议：

```bash
docker compose --env-file .env up -d --remove-orphans
```

必要时加 `--build`。

