#!/bin/bash

# shellcheck disable=SC2034
START_TIME=$SECONDS

# Установка git, если его нет
if ! command -v git &> /dev/null
then
    apt-get update
    apt-get install -y git
fi

# Клонирование репозитория
git clone -b monolith https://github.com/express42/reddit.git /home/

# Установка зависимостей и запуск приложения
# shellcheck disable=SC2164
cd /home/reddit && bundle install

if ! systemctl is-active --quiet puma.service
then
    # Создание юнита для systemd
    tee /etc/systemd/system/puma.service > /dev/null <<EOF
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/reddit
ExecStart=/usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    # Перезагрузка systemd
    systemctl daemon-reload

    # Включение и запуск сервиса
    systemctl enable puma
    systemctl start puma
fi

# Проверка статуса сервиса
systemctl status puma
# shellcheck disable=SC2004
ELAPSED_TIME=$(($SECONDS - $START_TIME))
# shellcheck disable=SC2004
echo -e "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n"
echo "------------------------------------------------"
# shellcheck disable=SC2009
ps aux | grep puma
echo
echo "Software is active"
