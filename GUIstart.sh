#!/bin/bash

# --- Установка необходимых компонентов с минимальным вводом от пользователя ---

# Проверяем root-доступ
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт нужно запускать с правами root."
    exit 1
fi

# Запрос имени пользователя и пароля
read -p "Введите имя нового пользователя (по умолчанию: exuser): " username
username=${username:-exuser}
username=$(echo "$username" | tr '[:upper:]' '[:lower:]') # Преобразуем имя пользователя в lowercase
read -sp "Введите пароль для пользователя $username (по умолчанию: ex@Pass9999): " password
password=${password:-ex@Pass9999}
echo ""

# Создаём пользователя
echo "Создаём пользователя $username с указанным паролем..."
useradd -m -s /bin/bash "$username" || { echo "Ошибка создания пользователя!"; exit 1; }
echo "$username:$password" | chpasswd || { echo "Ошибка установки пароля!"; exit 1; }
usermod -aG sudo,adm "$username"

# Обновляем систему и устанавливаем необходимые пакеты
echo "Обновляем систему и устанавливаем необходимые пакеты..."
apt-get update && apt-get upgrade -y
apt-get install -y ubuntu-desktop mmv htop stacer gnome-software xrdp

# Удаляем конфликтующий файл polkit
rm -f /usr/share/polkit-1/actions/org.freedesktop.color.policy

# Настройка портов для XRDP и SSH
echo "Настраиваем порты XRDP и SSH..."
sed -i 's/3389/53579/g' /etc/xrdp/xrdp.ini
sed -i 's/#Port 22/Port 53572/g' /etc/ssh/sshd_config
ufw allow 53572 && ufw allow 53579
ufw --force enable

# Создаём файл .xsession для рабочего стола GNOME
echo "gnome-session" > /home/$username/.xsession
chown $username:$username /home/$username/.xsession

# Устанавливаем Dolphy браузер
echo "Устанавливаем Dolphin Anty браузер..."
curl -fsSL https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage -o /home/$username/DolphinAnty.AppImage
chmod +x /home/$username/DolphinAnty.AppImage
ln -s /home/$username/DolphinAnty.AppImage /home/$username/Desktop/DolphinAnty
chown $username:$username /home/$username/DolphinAnty.AppImage /home/$username/Desktop/DolphinAnty

# Перезапускаем службы
echo "Перезапускаем службы XRDP и SSH..."
systemctl restart xrdp
systemctl restart ssh

# Сообщение об успешной установке
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
