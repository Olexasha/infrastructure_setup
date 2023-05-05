#!/bin/bash

# Обновляем ссылки и устанавливаем Ruby с необходимыми пакетами
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

# Проверяем, что Ruby установился
if [[ $(ruby -v) == *"ruby 2."* ]]; then
  echo "[debug] Ruby installed succesfully"
else
  echo "[debug] Something went wrong! Ruby hasnt installed!"
fi

# Проверяем, что Bundler установился
if [[ $(bundler -v) == *"Bundler version 1."* ]]; then
  echo "[debug] Bundler installed succesfully"
else
  echo "[debug] Something went wrong! Bundler hasnt installed!"
fi
