#!/usr/bin/env bash

# required variables
ADMIN_SECRET=${ADMIN_SECRET:-'$2a$10$pGBH10RM.LDvQREgrz60G.cP77QlrIbQVRCJ3ygB2pwKMUN8GiucW'} # default password 'admin'
ARGO_DOMAIN=${ARGO_DOMAIN}
ARGO_TOKEN=${ARGO_TOKEN}

# applications version
CADDY_VERSION='2.8.4'
CLOUDFLARED_VERSION='2024.12.2'
AGENT_VERSION='1.2.0'
DASHBOARD_VERSION='1.3.0'
# https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_amd64.tar.gz
# https://github.com/cloudflare/cloudflared/releases/download/2024.12.2/cloudflared-linux-amd64
# https://github.com/nezhahq/agent/releases/download/v1.2.0/nezha-agent_linux_amd64.zip
# https://github.com/nezhahq/nezha/releases/download/v1.3.0/dashboard-linux-amd64.zip

# auto generated variables
DATA_DIR="$(pwd)/data"
WORK_DIR="$(pwd)"
CLIENT_SECRET="$(openssl rand -base64 24 | sed 's/[\+\/]/q/g')"
JWT_SECRETKEY="$(openssl rand -base64 768 | sed -e ':a;N;s/\n//g;ta' -e 's/[\+\/]/q/g')"
AGENT_UUID="$(uuidgen)"

# first run
if [ ! -s /etc/supervisor/conf.d/damon.conf ]; then

    ## execute permission
    chmod +x $WORK_DIR/{agent,caddy,cloudflared,dashboard,*.sh}

    ## dashboard, sqlite, agent configuration
    if [ ! -e ${DATA_DIR}/config.yaml ]; then
        # copy dashboard yaml template
        cp ${DATA_DIR}/template/config.dashboard.yml ${DATA_DIR}/config.yaml
        # replace secret key
        sed -e "s#-secret-key-1024-#$JWT_SECRETKEY#" -e "s#-secret-key-32-#$CLIENT_SECRET#" -i ${DATA_DIR}/config.yaml
    fi

    if [ ! -e ${DATA_DIR}/config.agent.yml ]; then
        # copy agent yaml template
        cp ${DATA_DIR}/template/config.agent.yml ${DATA_DIR}/config.agent.yml
        # replace secret key
        sed -e "s#-uuid-#$AGENT_UUID#" -e "s#-secret-key-32-#$CLIENT_SECRET#" -i ${DATA_DIR}/config.agent.yml
    fi
    # install agent
    ${WORK_DIR}/agent service -c ${DATA_DIR}/config.agent.yml install

    if [ ! -e ${DATA_DIR}/sqlite.db ]; then
        # copy template db file
        cp ${DATA_DIR}/template/sqlite.db ${DATA_DIR}/sqlite.db
        # update admin password
        sqlite3 ${DATA_DIR}/sqlite.db "UPDATE users SET password='$ADMIN_SECRET' WHERE username='admin'"
        # update local Agent uuid
        sqlite3 ${DATA_DIR}/sqlite.db "UPDATE servers SET uuid='$AGENT_UUID' WHERE id='1'"
    fi
    AGENT_CMD="$WORK_DIR/agent service -c ${DATA_DIR}/config.agent.yml start"
    DASHBOARD_CMD="$WORK_DIR/dashboard"

    ## caddy
    CADDY_CMD="$WORK_DIR/caddy run --config $DATA_DIR/Caddyfile --watch"

    ## cloudflared
    CLOUDFLARED_CMD="$WORK_DIR/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token $ARGO_TOKEN"

    ## supervisor
    ### copy template
    cp ${DATA_DIR}/template/damon.conf /etc/supervisor/conf.d/damon.conf
    ### replace commands
    sed -e "s#-caddy-cmd-#$CADDY_CMD#g" \
        -e "s#-dashboard-cmd-#$DASHBOARD_CMD#g" \
        -e "s#-agent-cmd-#$AGENT_CMD#g" \
        -e "s#-cloudflared-cmd-#$CLOUDFLARED_CMD#g" \
        -i /etc/supervisor/conf.d/damon.conf

fi

# RUN agent
$WORK_DIR/agent service -c ${DATA_DIR}/config.agent.yml start
# RUN supervisor
supervisord -c /etc/supervisor/supervisord.conf