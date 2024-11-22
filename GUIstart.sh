#!/bin/bash

# Обновляем систему
sudo apt-get update -y
sudo apt-get upgrade -y

# Устанавливаем графический интерфейс
sudo apt-get install ubuntu-desktop -y

# Устанавливаем зависимые пакеты
sudo apt-get install wget curl unzip -y

# Устанавливаем Firefox (если нужно)
sudo apt-get install firefox -y

# Устанавливаем приложение Stacer (если нужно)
sudo apt-get install stacer -y

# Устанавливаем xrdp для удаленного доступа
sudo apt-get install xrdp -y

# Добавляем xrdp пользователя
sudo adduser xrdpuser
sudo usermod -aG sudo,adm xrdpuser
sudo su xrdpuser

# Устанавливаем браузер Dolphin Any
echo "Скачиваем Dolphin Any Browser..."
wget -O dolphin-anty-latest.AppImage "https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage"

# Даем права на выполнение файла
chmod +x dolphin-anty-latest.AppImage

# Запускаем приложение
./dolphin-anty-latest.AppImage &

# Устанавливаем xrdp для удаленного рабочего стола (если не установлено)
sudo apt-get install xrdp -y

# Перезапускаем xrdp
sudo systemctl restart xrdp

# Завершаем установку
echo "Установка завершена. Используйте xrdp для удаленного доступа."
