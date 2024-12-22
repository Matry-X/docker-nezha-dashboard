FROM debian

WORKDIR /dashboard

RUN apt-get update && \
    apt-get install -y cron iproute2 git openssl sed sqlite3 supervisor unzip uuid-runtime wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_amd64.tar.gz && \
    tar -xz -f caddy_2.8.4_linux_amd64.tar.gz && rm caddy_2.8.4_linux_amd64.tar.gz LICENSE README.md && \
    wget -q https://github.com/cloudflare/cloudflared/releases/download/2024.12.2/cloudflared-linux-amd64 && \
    mv cloudflared-linux-amd64 cloudflared && \
    wget -q https://github.com/nezhahq/agent/releases/download/v1.2.0/nezha-agent_linux_amd64.zip && \
    unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip && mv nezha-agent agent && \
    wget -q https://github.com/nezhahq/nezha/releases/download/v1.3.0/dashboard-linux-amd64.zip && \
    unzip dashboard-linux-amd64.zip && rm dashboard-linux-amd64.zip && mv dashboard-linux-amd64 dashboard

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 8008

ENTRYPOINT ["./entrypoint.sh"]
