#!/usr/bin/env bash
set -euo pipefail

# Always run from the directory where this script lives (repo root).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure .n8n directory exists and has correct ownership for container user (uid:gid 1000:1000).
N8N_DATA_DIR=".n8n"
if [[ ! -d "$N8N_DATA_DIR" ]]; then
  mkdir -p "$N8N_DATA_DIR"
fi

# Get current owner uid:gid (GNU stat on Linux, BSD stat on macOS).
get_uid_gid() {
  if stat -c '%u:%g' "$1" >/dev/null 2>&1; then
    stat -c '%u:%g' "$1"
    return 0
  fi
  if stat -f '%u:%g' "$1" >/dev/null 2>&1; then
    stat -f '%u:%g' "$1"
    return 0
  fi
  return 1
}

CURRENT_UID_GID="$(get_uid_gid "$N8N_DATA_DIR" || true)"
if [[ "$CURRENT_UID_GID" != "1000:1000" ]]; then
  echo "[INFO] 修正 $N8N_DATA_DIR 权限：当前=$CURRENT_UID_GID 期望=1000:1000"
  if chown -R 1000:1000 "$N8N_DATA_DIR" >/dev/null 2>&1; then
    :
  elif command -v sudo >/dev/null 2>&1; then
    sudo chown -R 1000:1000 "$N8N_DATA_DIR"
  else
    echo "[ERROR] 无法 chown -R 1000:1000 $N8N_DATA_DIR（需要 root/sudo 权限）"
    exit 1
  fi
fi

ENV_FILE="${ENV_FILE:-.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] 未找到 $ENV_FILE。请从 .env.example 复制一份："
  echo "        cp .env.example .env"
  exit 1
fi

# Export variables defined in .env to current process env, so docker/compose can use them.
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

docker compose --env-file "$ENV_FILE" up -d --build --remove-orphans