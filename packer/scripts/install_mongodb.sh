#!/bin/sh

# Добавляем репозиторий монги в сурсы
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Обновляем ссылки и устанавливаем mongodb
apt update
apt install -y mongodb-org

# Запускаем сервис и добавляем его в автозапуск
systemctl start mongod
systemctl enable --now mongod
STATUS=$(systemctl status mongod)

# Проверяем, что сервис активен и добавлен в автозапуск ОС
# shellcheck disable=SC2039
if [[ $STATUS == *"active (running)"* ]]; then
  echo "[debug] MongoDB is active and running"
else
  echo "[debug] Something went wrong! MongoDB is not running"
fi
# shellcheck disable=SC2039
if [[ $STATUS == *"enabled"* ]]; then
  echo "[debug] MongoDB is enabled and will start at boot"
else
  echo "[debug] Something went wrong! MongoDB is not enabled"
fi
