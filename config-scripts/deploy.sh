#!/bin/sh

# Обновляем ссылки и устанавливаем git
sudo apt update
sudo apt install -y git

# Клоним репозиторий
# shellcheck disable=SC2164
mkdir /home/olexasha/git_repos && cd /home/olexasha/git_repos
git clone -b monolith https://github.com/express42/reddit.git

# Деплой сервера
cd reddit && bundle install
puma -d

# Проверяем, что сервер запущен и выводим его порт в случае успеха
# shellcheck disable=SC2009
PORT=$(ps aux | grep puma | grep -v grep | sed -n 's/.*:\([0-9]\{1,\}\).*/\1/p')
# shellcheck disable=SC2039
if [[ -n "$PORT" ]]; then
	echo "[debug] Puma is running on port $PORT"
else
	echo "[debug] Puma is not running"
fi
