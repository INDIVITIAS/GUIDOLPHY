#!/bin/bash
set -e

# Устанавливаем графический интерфейс и браузер
echo "Обновление системы и установка необходимых пакетов..."
apt update && apt upgrade -y
apt install -y ubuntu-desktop xrdp lightdm wget curl software-properties-common

# Устанавливаем LightDM как дисплейный менеджер
echo "Выбор LightDM в качестве дисплейного менеджера..."
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
dpkg-reconfigure -f noninteractive lightdm

# Определение видеокарты и установка драйверов
echo "Определение видеокарты и установка драйверов..."
GPU=$(lspci | grep -E "VGA|3D|Display" || true)

if echo "$GPU" | grep -i "NVIDIA"; then
    echo "Обнаружена NVIDIA. Устанавливаем драйверы..."
    apt install -y nvidia-driver-525
elif echo "$GPU" | grep -i "AMD"; then
    echo "Обнаружена AMD. Устанавливаем драйверы..."
    apt install -y xserver-xorg-video-amdgpu
elif echo "$GPU" | grep -i "Intel"; then
    echo "Обнаружена Intel. Устанавливаем драйверы..."
    apt install -y xserver-xorg-video-intel
else
    echo "Не удалось определить видеокарту. Устанавливаем универсальные драйверы..."
    apt install -y xserver-xorg-video-vesa
fi

# Установка Dolphin Anty
echo "Скачивание и установка браузера Dolphin Anty..."
wget -O /opt/dolphin-anty.AppImage https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage
chmod +x /opt/dolphin-anty.AppImage

# Автоматический запуск Dolphin Anty после входа
echo "Добавление автозапуска Dolphin Anty..."
cat <<EOF > /etc/xdg/autostart/dolphin-anty.desktop
[Desktop Entry]
Type=Application
Exec=/opt/dolphin-anty.AppImage
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Dolphin Anty
EOF

# Настройка RDP
echo "Настройка RDP..."
systemctl enable xrdp
systemctl start xrdp
ufw allow 3389/tcp

echo "Установка завершена. Перезагрузите сервер, чтобы применить изменения."
