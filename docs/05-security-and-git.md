# 05 安全与 Git（必读）

## 敏感信息清单

请把以下内容视为敏感信息：

- **`.env`**：包含鉴权 token、可能的 API Key 等
- **`./.n8n/`**：n8n 运行态数据目录（数据库、凭据、`encryptionKey`、日志等）

> 例如：`./.n8n/config` 中包含 `encryptionKey`，一旦泄露，风险很高。

## Git 忽略策略

本仓库根目录提供 `.gitignore`，默认忽略：

- `./.n8n/`
- `.env`、`.env.*`（允许提交 `.env.example` / `.env.template`）
- 常见日志与缓存

## 我不小心提交了 `.env` 或 `.n8n/` 怎么办？

### 1) 先确保 `.gitignore` 已生效

确认根目录已有 `.gitignore`。

### 2) 从 Git 索引移除（不删除本地文件）

```bash
git rm -r --cached .n8n
git rm --cached .env
git commit -m "chore: stop tracking runtime/secrets"
```

### 3) 如果敏感信息已经进了历史（更严格）

如果 `.env`、token、或 `.n8n/config` 曾经被推送到远端，建议：

- **立即轮换**：更换 `N8N_RUNNERS_AUTH_TOKEN` 等全部相关密钥
- 再考虑进行 Git 历史清理（这通常需要团队协作与强制推送，需谨慎）

## 最佳实践

- **永远不要**把真实密钥写进仓库
- 用 `.env.example` 交付“配置模板”，用 `.env` 保存真实值
- 备份 `./.n8n/` 时也要按敏感数据处理（加密、权限、审计）

