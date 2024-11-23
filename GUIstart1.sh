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

# Принудительный запуск Firefox для создания профиля
su - $username -c "firefox --headless & sleep 5; pkill firefox"

# Настройка вкладок для Firefox
firefox_profile_dir="/home/$username/.mozilla/firefox"
default_profile=$(find "$firefox_profile_dir" -name "*.default*" -type d | head -n 1)

if [ -n "$default_profile" ]; then
    echo "user_pref(\"browser.startup.homepage\", \"https://dolphin-anty.com/a/2127109/INDIVITIAS|https://incogniton.com/aff/113505/|https://share.adspower.net/INDIVITIAS|https://www.databasemart.com/?aff_id=043edcb53ec74d3f80aafc2ac322742d|https://dashboard.proxywing.com/billing/aff.php?aff=321|https://dark.shopping/?p=78029\");" >> "$default_profile/prefs.js"
    echo "user_pref(\"browser.startup.page\", 1);" >> "$default_profile/prefs.js"
    chown -R $username:$username "$firefox_profile_dir"
else
    echo "Не удалось настроить профиль Firefox."
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
