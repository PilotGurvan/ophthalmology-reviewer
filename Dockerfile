FROM python:3.12-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN pip install --no-cache-dir "mistralai-agents[koyeb]>=1.1.2,<1.2"

COPY main.py ./
RUN useradd --create-home --shell /usr/sbin/nologin agent \
 && chown -R agent:agent /app

ENV AGENTS_SDK_IDLE_TIMEOUT_SECONDS=86400 \
    AGENTS_SDK_LIFETIME_LIMIT_SECONDS=604800 \
    AGENTS_SDK_EXECUTION_TIMEOUT_SECONDS=691200

USER agent
CMD ["agents", "run-worker"]