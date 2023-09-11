#!/bin/bash

# shellcheck disable=SC2034
START_TIME=$SECONDS

# Установка git
apt-get update
apt-get install -y git

# Клонирование репозитория
mkdir /opt/puma && \
cd /opt/puma && \
git clone -b monolith https://github.com/express42/reddit.git

# Установка зависимостей и запуск приложения
# shellcheck disable=SC2164
cd reddit && bundle install

cat > /etc/systemd/system/puma.service << EOF
[Unit]
Description=Puma HTTP Server
After=network.target
[Service]
Type=simple
WorkingDirectory=/opt/puma/reddit
ExecStart=/usr/local/bin/puma
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
[Install]
WantedBy=multi-user.target
EOF
chmod 664 /etc/systemd/system/puma.service
systemctl daemon-reload && systemctl enable puma && systemctl start puma

# shellcheck disable=SC2004
ELAPSED_TIME=$(($SECONDS - $START_TIME))
# shellcheck disable=SC2004
echo -e "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n"
echo "------------------------------------------------"
echo "Software is active"
