#!/bin/bash

START_TIME=$SECONDS

# Обновляем ссылки и устанавливаем Ruby с необходимыми пакетами
apt update -qq
apt install -y ruby-full ruby-bundler build-essential

# Проверяем, что Ruby установился
if [[ $(ruby -v) == *"ruby 2."* ]]; then
  echo "[debug] Ruby installed succesfully"
else
  echo "[debug] Something went wrong! Ruby hasnt hasnt called by name!"
fi

# Проверяем, что Bundler установился
if [[ $(bundler -v) == *"Bundler version"* ]]; then
  echo "[debug] Bundler installed succesfully"
else
  echo "[debug] Something went wrong! Bundler hasnt called by name!"
fi
# shellcheck disable=SC2004
ELAPSED_TIME=$(($SECONDS - $START_TIME))
# shellcheck disable=SC2004
echo -e "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n"
echo "------------------------------------------------"
echo "Installed Ruby version is:  $(ruby -v)"
echo "Installed Bundler version is:  $(bundler -v)"
