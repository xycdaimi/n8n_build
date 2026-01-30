#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ -f ".env" ]]; then
  set +e
  docker compose --env-file ".env" down --remove-orphans
  ec=$?
  set -e
else
  set +e
  docker compose down --remove-orphans
  ec=$?
  set -e
fi

# Force-remove the locally built runners image so next start will rebuild it
docker image rm -f n8n-runners-custom:local >/dev/null 2>&1 || true
exit $ec