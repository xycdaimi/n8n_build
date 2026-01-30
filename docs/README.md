# 文档索引

本目录提供本仓库（n8n Docker 部署 + External Runners）的使用与运维文档。

## 建议阅读顺序

1. `01-quickstart.md`：首次启动、停止、重启与访问入口
2. `02-configuration.md`：`.env` 配置项说明（重点是 runners）
3. `03-runners.md`：External Task Runners 原理与扩展依赖（Python/JS）
4. `04-operations.md`：备份、迁移、升级、数据目录与日志
5. `05-security-and-git.md`：安全注意事项、`.gitignore`、误提交处理
6. `06-troubleshooting.md`：常见问题排查

## 关键结论（先记住这三条）

- **不要提交**：`.env` 与 `./.n8n/`（包含密钥、凭据、数据库）
- **务必设置**：`N8N_RUNNERS_AUTH_TOKEN`（n8n 与 runners 必须一致）
- **数据都在**：`./.n8n/`（迁移/重装前先备份它）

