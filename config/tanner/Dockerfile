FROM python:3.8-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libssl-dev libffi-dev git \
    && rm -rf /var/lib/apt/lists/*

# Instalar Tanner direto do GitHub
RUN pip install --no-cache-dir git+https://github.com/mushorg/tanner.git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8090

ENV REDIS_HOST=tanner-redis
ENV REDIS_PORT=6379

ENTRYPOINT ["/entrypoint.sh"]
