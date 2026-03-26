FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev libffi-dev build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir opencanary

COPY opencanary.conf /root/.opencanary.conf

EXPOSE 21 23 80 443 3306 6379 8080

CMD ["opencanaryd", "--start"]
