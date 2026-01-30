ARG RUNNERS_BASE_IMAGE=n8nio/runners:latest
FROM ${RUNNERS_BASE_IMAGE}

# 可扩展 runners 镜像：
# - 通过 build args 安装额外依赖（默认不安装）
# - 可覆盖 launcher 配置文件（/etc/n8n-task-runners.json）

USER root

# Optional extra deps (space-separated), e.g.
#   --build-arg JS_DEPS="moment uuid"
#   --build-arg PY_DEPS="numpy pandas"
ARG JS_DEPS="moment uuid"
ARG PY_DEPS="numpy pandas"

RUN set -eux; \
  if [ -n "$JS_DEPS" ]; then \
    cd /opt/runners/task-runner-javascript && pnpm add $JS_DEPS; \
  fi; \
  if [ -n "$PY_DEPS" ]; then \
    cd /opt/runners/task-runner-python && uv pip install $PY_DEPS; \
  fi

# Default launcher config (you can edit this file in repo)
COPY n8n_runners/n8n-task-runners.json /etc/n8n-task-runners.json

USER runner
