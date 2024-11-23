#!/bin/bash

# Запрос имени пользователя и преобразование в lowercase
read -p "Введите имя нового пользователя (по умолчанию: exuser): " username
username=${username:-exuser}
username=$(echo "$username" | tr '[:upper:]' '[:lower:]') # Преобразуем имя пользователя в lowercase

# Запрос пароля для пользователя
read -sp "Введите пароль для пользователя $username (по умолчанию: ex@Pass9999): " password
password=${password:-ex@Pass9999}
echo ""

# Создание пользователя
adduser --quiet --disabled-password --gecos "" $username
echo "$username:$password" | chpasswd

# Добавление пользователя в группу sudo и adm
usermod -aG sudo,adm $username

# Обновление системы
apt-get update && apt-get upgrade -y

# Установка необходимых пакетов
apt-get install -y ubuntu-desktop mmv htop stacer gnome-software xrdp wget firefox

# Удаление ненужной политики
rm /usr/share/polkit-1/actions/org.freedesktop.color.policy

# Изменение настроек xrdp
sed -i 's/3389/53579/g' /etc/xrdp/xrdp.ini
sed -i 's/#Port 22/Port 53572/g' /etc/ssh/sshd_config

# Настройка firewall
ufw allow 53572 && ufw allow 53579 && ufw enable && ufw status numbered

# Настройка домашней страницы Firefox
firefox_profile="/home/$username/.mozilla/firefox"
default_profile=$(find "$firefox_profile" -name "*.default*" -type d 2>/dev/null | head -n 1)

if [ -n "$default_profile" ]; then
    echo "user_pref(\"browser.startup.homepage\", \"https://samba.com\");" >> "$default_profile/prefs.js"
else
    echo "Firefox профиля не найдено. Домашняя страница не настроена."
fi

# Уведомление об успешной установке
echo ""
echo "Установка завершена!"
echo "Вы можете подключиться через RDP-клиент, используя следующие данные:"
echo "  - Имя пользователя: $username"
echo "  - Пароль: $password"
echo "  - Порт XRDP: 53579"
echo "  - Порт SSH (при необходимости): 53572"
echo ""
echo "Автоматическая перезагрузка через 10 секунд..."
sleep 10
reboot
