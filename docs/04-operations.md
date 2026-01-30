# 04 运维（备份 / 迁移 / 升级）

## 数据目录（非常重要）

本项目将宿主机 `./.n8n` 挂载到容器 `/home/node/.n8n`：

- 这里通常包含：数据库、凭据、加密密钥、日志等运行态数据
- **该目录属于敏感数据**，请勿提交到 Git（本仓库 `.gitignore` 已默认忽略）

## 备份

### 备份策略（推荐）

- 定期备份整个 `./.n8n/` 目录
- 备份文件应加密存储（尤其是多人协作/生产环境）

### 备份注意事项

- 不要随意删除/更换 `./.n8n/` 中的加密相关配置（例如 `encryptionKey`），否则历史凭据可能无法解密

## 迁移

迁移到新机器/新路径：

1. 在新机器准备好仓库代码
2. 复制旧机器的 `./.n8n/` 到新机器同一路径（仓库根目录下）
3. 复制旧机器的 `.env`（或重新生成并确保 token 等关键项一致）
4. 启动：`start.bat` 或 `start.sh`

## 升级

本仓库使用：

- `n8nio/n8n:nightly`（主服务）
- `n8nio/runners:latest`（runners 基础镜像，默认）

升级建议：

- 尽量固定到更稳定/可复现的版本（例如 `n8nio/n8n:<version>`），避免 nightly 带来的不确定性
- 升级前先备份 `./.n8n/`

常用命令：

```bash
docker compose --env-file .env pull
docker compose --env-file .env up -d --remove-orphans
```

如果 runners 也有变更（或你修改了依赖），加上 `--build`：

```bash
docker compose --env-file .env up -d --build --remove-orphans
```

## 查看运行状态与日志

```bash
docker compose ps
docker compose logs -f n8n
docker compose logs -f n8n-runners
```

