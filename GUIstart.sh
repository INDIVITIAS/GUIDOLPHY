#!/bin/bash

# Запрос имени пользователя
read -p "Введите имя нового пользователя (по умолчанию: exuser): " username
username=${username:-exuser}

# Запрос пароля для пользователя
read -sp "Введите пароль для пользователя $username (по умолчанию: ex@Pass9999): " password
password=${password:-ex@Pass9999}

# Создание пользователя
adduser --quiet --disabled-password --gecos "" $username
echo "$username:$password" | chpasswd

# Добавление пользователя в группу sudo и adm
usermod -aG sudo,adm $username

# Обновление системы
apt-get update && apt-get upgrade -y

# Установка необходимых пакетов
apt-get install -y ubuntu-desktop mmv htop stacer gnome-software xrdp wget

# Удаление ненужной политики
rm /usr/share/polkit-1/actions/org.freedesktop.color.policy

# Изменение настроек xrdp
sed -i 's/3389/53579/g' /etc/xrdp/xrdp.ini
sed -i 's/#Port 22/Port 53572/g' /etc/ssh/sshd_config

# Настройка firewall
ufw allow 53572 && ufw allow 53579 && ufw enable && ufw status numbered

# Скачивание файла Dolphin Anty
echo "Скачиваем и устанавливаем Dolphin Anty..."
wget -O /tmp/dolphin-anty-linux-x86_64-latest.AppImage https://app.dolphin-anty-mirror3.net/anty-app/dolphin-anty-linux-x86_64-latest.AppImage

# Проверка успешности скачивания
if [ -f /tmp/dolphin-anty-linux-x86_64-latest.AppImage ]; then
    echo "Файл успешно загружен."
    chmod +x /tmp/dolphin-anty-linux-x86_64-latest.AppImage
else
    echo "Ошибка при загрузке файла Dolphin Anty. Пожалуйста, проверьте интернет-соединение или URL."
    exit 1
fi

# Создание ярлыка на рабочем столе
echo -e "[Desktop Entry]\nName=Dolphin Anty\nExec=/tmp/dolphin-anty-linux-x86_64-latest.AppImage\nIcon=dolphin\nTerminal=false\nType=Application" > /home/$username/Desktop/DolphinAnty.desktop
chmod +x /home/$username/Desktop/DolphinAnty.desktop
chown $username:$username /home/$username/Desktop/DolphinAnty.desktop

# Уведомление об успешной установке и перезагрузке
echo "Dolphin Anty успешно установлен. Ярлык добавлен на рабочий стол."
echo "Перезагрузка системы через 10 секунд..."
sleep 10
reboot
