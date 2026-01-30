# 01 快速开始（Quickstart）

## 前置依赖

- Docker Desktop（包含 Docker Engine + Docker Compose）

## 首次运行

### 1) 生成 `.env`

仓库提供了模板：`.env.example`。

Windows：

```bash
copy .env.example .env
```

Linux/macOS：

```bash
cp .env.example .env
```

然后编辑 `.env`，至少修改：

- `N8N_RUNNERS_AUTH_TOKEN`：把示例值替换成强密码（n8n 与 runners 两侧要一致）

### 2) 启动

Windows：

```bash
.\start.bat
```

Linux/macOS：

```bash
./start.sh
```

### 3) 访问

默认访问地址：`http://localhost:15678`

> `docker-compose.yml` 将宿主机端口 `15678` 映射到容器 `5678`。

## 日常操作

### 停止

Windows：

```bash
.\stop.bat
```

Linux/macOS：

```bash
./stop.sh
```

### 重启（不重新构建镜像）

Windows：

```bash
.\restart.bat
```

Linux/macOS：

```bash
./restart.sh
```

### 重新构建并启动（当你改了 runners 依赖等）

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

