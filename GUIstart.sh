#!/bin/bash

# Обновляем систему
apt update && apt upgrade -y

# Устанавливаем необходимые пакеты для графического интерфейса и RDP
apt install -y ubuntu-desktop xrdp lightdm wget unzip curl

# Настройка xrdp
systemctl enable xrdp
systemctl start xrdp

# Устанавливаем и настраиваем графический дисплейный менеджер lightdm
dpkg-reconfigure lightdm
systemctl restart lightdm

# Устанавливаем зависимости для работы с Dolphin Anty (AppImage)
wget https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage -P /tmp/
chmod +x /tmp/dolphin-anty-linux-x86_64-latest.AppImage

# Информируем пользователя о том, как запустить Dolphin Anty
echo "Dolphin Anty успешно установлен. Для его запуска выполните команду: /tmp/dolphin-anty-linux-x86_64-latest.AppImage"

# Сообщение о завершении работы скрипта
echo "Установка завершена. Пожалуйста, перезагрузите сервер для применения всех изменений."
