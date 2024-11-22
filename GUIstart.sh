#!/bin/bash

# Убедимся, что скрипт запускается от имени root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root."
  exit
fi

# Запрос имени пользователя
read -p "Введите имя нового пользователя (по умолчанию: exuser): " USERNAME
USERNAME=${USERNAME:-exuser}

# Запрос пароля пользователя
read -sp "Введите пароль для пользователя $USERNAME (по умолчанию: ex@Pass9999): " PASSWORD
PASSWORD=${PASSWORD:-ex@Pass9999}
echo

# Создание пользователя
echo "Создаём пользователя $USERNAME с указанным паролем..."
adduser --quiet --disabled-password --gecos "" "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo,adm "$USERNAME"

# Обновление и установка необходимых пакетов
echo "Обновляем систему и устанавливаем необходимые пакеты..."
apt-get update -y && apt-get upgrade -y
apt-get install -y ubuntu-desktop mmv htop stacer gnome-software xrdp

# Удаление проблемного файла
echo "Удаляем файл org.freedesktop.color.policy..."
rm -f /usr/share/polkit-1/actions/org.freedesktop.color.policy

# Настройка порта xrdp
echo "Изменяем порт xrdp на 53579..."
sed -i 's/3389/53579/g' /etc/xrdp/xrdp.ini

# Настройка SSH на другой порт
echo "Изменяем порт SSH на 53572..."
sed -i 's/#Port 22/Port 53572/g' /etc/ssh/sshd_config
systemctl restart sshd

# Настройка брандмауэра
echo "Настраиваем брандмауэр..."
ufw allow 53572
ufw allow 53579
ufw --force enable

# Установка Dolphy Browser
echo "Скачиваем и устанавливаем Dolphy Browser..."
wget -q -O /usr/local/bin/dolphin-anty https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage
chmod +x /usr/local/bin/dolphin-anty

# Создание ярлыка для Dolphy Browser на рабочем столе
DESKTOP_FILE="/home/$USERNAME/Desktop/Dolphy.desktop"
echo "Создаём ярлык для Dolphy Browser на рабочем столе..."
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Dolphy Browser
Exec=/usr/local/bin/dolphin-anty
Icon=application-default-icon
Terminal=false
EOF
chmod +x "$DESKTOP_FILE"
chown "$USERNAME:$USERNAME" "$DESKTOP_FILE"

# Завершение работы скрипта
echo -e "\n####################################"
echo "Настройка завершена!"
echo "Данные для подключения через RDP:"
echo " - IP-адрес сервера: $(curl -s ifconfig.me)"
echo " - Порт RDP: 53579"
echo " - Пользователь: $USERNAME"
echo " - Пароль: $PASSWORD"
echo "Автоматическая перезагрузка сервера через 10 секунд..."
echo "####################################"
sleep 10
reboot
