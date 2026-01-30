#!/usr/bin/env bash
set -euo pipefail

# Always run from the directory where this script lives (repo root).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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