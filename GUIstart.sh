#!/bin/bash

# Обновляем систему
sudo apt-get update -y
sudo apt-get upgrade -y

# Устанавливаем графический интерфейс Ubuntu Desktop
sudo apt-get install ubuntu-desktop -y

# Устанавливаем зависимые пакеты
sudo apt-get install wget curl unzip -y

# Устанавливаем Firefox (если нужно)
sudo apt-get install firefox -y

# Устанавливаем Stacer (если нужно)
sudo apt-get install stacer -y

# Устанавливаем xrdp для удаленного доступа
sudo apt-get install xrdp -y

# Устанавливаем браузер Dolphin Any
echo "Скачиваем Dolphin Any Browser..."
wget -O dolphin-anty-latest.AppImage "https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage"

# Даем права на выполнение файла
chmod +x dolphin-anty-latest.AppImage

# Запускаем приложение Dolphin Any (в фоне)
./dolphin-anty-latest.AppImage &

# Настроим xrdp для автоматической работы с графическим интерфейсом
echo "Настроим xrdp для автоматического старта с рабочим столом..."

# Установим lightdm (если не установлен) для автоматической загрузки графической среды
sudo apt-get install lightdm -y

# Настроим систему для загрузки в графический интерфейс по умолчанию
sudo systemctl enable lightdm

# Перезапускаем xrdp
sudo systemctl restart xrdp

# Отключаем root пользователя (опционально)
sudo passwd --delete --lock root

# Перезагружаем сервер, чтобы все настройки вступили в силу
echo "Скрипт завершен. Перезагружаем сервер..."
sudo reboot
