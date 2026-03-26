FROM python:3.8-slim

# Dependências
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libssl-dev libffi-dev curl \
    && rm -rf /var/lib/apt/lists/*

# Instalar Snare via pip
RUN pip install --no-cache-dir snare

# Criar diretório de páginas e copiar página falsa
RUN mkdir -p /opt/snare/pages

COPY pages/ /opt/snare/pages/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENV TANNER_HOST=10.10.0.96
ENV SNARE_PORT=80

ENTRYPOINT ["/entrypoint.sh"]
