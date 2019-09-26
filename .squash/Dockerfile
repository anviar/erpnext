FROM debian:buster-slim
COPY site_config.j2 /tmp/
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_HOST
ARG SQUASH_DOMAIN
RUN set -x && \
    apt-get update && apt-get install -y git python3-pip python3 nodejs npm wget redis-server cron default-mysql-client && \
    # curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs && \
    git clone https://github.com/frappe/bench --depth 1 && pip3 install -e ./bench && \
    pip3 install j2cli && \
    npm install -g yarn && \
    wget -O /tmp/wkhtmltox.tar.xz https://github.com/frappe/wkhtmltopdf/raw/master/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar -xf /tmp/wkhtmltox.tar.xz -C /tmp && \
    mv /tmp/wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
    chmod +x /usr/local/bin/wkhtmltopdf && \
    useradd -ms /bin/bash frappe
USER frappe
RUN set -x && cd /home/frappe && \
    git clone https://github.com/frappe/frappe --depth 1 && \
    bench init --frappe-path ~/frappe frappe-bench && \
    # cd ~/frappe-bench && bench update --reset --force && \
    cd ~/frappe-bench/apps/frappe && yarn
WORKDIR /home/frappe/frappe-bench
RUN set -x && \
    sed -i 's/watch:/# watch:/g' Procfile && \
    sed -i 's/schedule:/# schedule:/g' Procfile && \
    sed -i 's/socketio:/# socketio:/g' Procfile && \
    sed -i 's/redis_socketio:/# redis_socketio:/g' Procfile && \
    bench get-app erpnext https://github.com/frappe/erpnext && \
    bench set-mariadb-host ${MYSQL_HOST} && \
    wget -q http://build.erpnext.com/20171108_190013_955977f8_database.sql.gz
CMD set -x && \
    # bench new-site ${SQUASH_DOMAIN} \
    #     --db-name ${MYSQL_DATABASE} \
    #     --mariadb-root-username root \
    #     --mariadb-root-password ${MYSQL_ROOT_PASSWORD} \
    #     --admin-password ${ADMIN_PASSWORD} \
    #     --install-app erpnext && \
    mkdir ~/frappe-bench/sites/${SQUASH_DOMAIN} && \
    j2 /tmp/site_config.j2 >~/frappe-bench/sites/${SQUASH_DOMAIN}/site_config.json && \
    # bench --site ${SQUASH_DOMAIN} --force restore 20171108_190013_955977f8_database.sql.gz &&\
    bench --site ${SQUASH_DOMAIN} reinstall --yes && \
    bench --site ${SQUASH_DOMAIN} install-app erpnext && \
    bench start
