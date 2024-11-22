#!/bin/bash

# Обновление системы
apt-get update && apt-get upgrade -y

# Установка графического интерфейса и RDP
apt-get install -y ubuntu-desktop xrdp lightdm

# Установка браузера Dolphin Anty
wget -O /tmp/dolphin-anty-linux-x86_64-latest.AppImage "https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage"
chmod +x /tmp/dolphin-anty-linux-x86_64-latest.AppImage

# Создание рабочего стола ярлыка (если нужно)
echo "[Desktop Entry]
Version=1.0
Name=Dolphin Anty
Comment=Dolphin Anty Browser
Exec=/tmp/dolphin-anty-linux-x86_64-latest.AppImage
Icon=application-default-icon
Terminal=false
Type=Application
Categories=Network;X-Desktop-App-Install;" > /usr/share/applications/dolphin-anty.desktop

# Установка зависимостей для графического интерфейса
apt-get install -y --no-install-recommends \
  xorg xserver-xorg-core \
  dbus-x11 \
  x11-xserver-utils \
  openbox

# Перезапуск сервисов для применения изменений
systemctl restart lightdm

# Информация для пользователя
echo "Dolphin Anty успешно установлен. Чтобы запустить Dolphin Anty, выполните команду:"
echo "/tmp/dolphin-anty-linux-x86_64-latest.AppImage"
echo "или найдите его в меню приложений вашего графического интерфейса."
echo "Перезагрузите сервер, чтобы завершить настройку и применить изменения."
