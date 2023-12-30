#!/bin/bash
# Auto Install FiveM Script
# =====================================================================================
# Author:   Ma3lich#7006
# =====================================================================================
# =====================================================================================
# Root Force

# Supported systems:
supported="Ubuntu (20.04)"
COLOR1='\033[0;32m'     # green color
COLOR2='\033[0;31m'     # red color
COLOR3='\33[0;33m'
NC='\033[0m'            # no color

if [ "$(id -u)" != "0" ]; then
    printf "${RED}ERROR: Tx-FiveM does not have root access. ⛔️\\n" 1>&2
    printf "\\n"
    exit 1
fi
printf "${COLOR1}   ©️ Copyright All rights reserved TXHOST ©️ \\n"
printf "${COLOR2}  💻 Supported Systems: $supported 💻\\n"
printf "${NC}\\n"
sleep 5

#############################################################################
# Prerequisite Installation
echo -e "${YELLOW} Installing prerequisites for a FiveM server! \\n"
sleep 1
apt update
apt upgrade -y
apt install bash curl wget nload htop sudo neofetch -y
wget https://raw.githubusercontent.com/TxHost/assets/main/vps/.bashrc
source .bashrc
rm /etc/motd
cd /etc/
wget https://raw.githubusercontent.com/TxHost/assets/main/vps/motd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart ssh
apt install lsb-release apt-transport-https ca-certificates bash xz-utils git screen -y
sleep 2

# Installation of 5436
echo -e "${YELLOW} Installing the latest artifact for FiveM server \\n"
sleep 1
echo -e "${CYAN} Starting the installation of version 5436 for FiveM server!"
cd /home/
mkdir -p fivem
cd /home/fivem
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5436-1984c3e2a7b968f2772a90920b56473b9995f5e3/fx.tar.xz
tar xvfJ fx.tar.xz
sed -i '1irm -r cache' run.sh
rm fx.tar.xz
sleep 2

# Installation of SYSTEMCTL
echo
printf "${YELLOW} Do you want to have system commands to start your FiveM server? ❓  [Y/n]\\n"
read reponse
if [[ "$reponse" == "Y" || "$reponse" == "y" ]]; then
    printf "${CYAN} Starting technology to start your FiveM server!"
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/TxHost/Tx-Fivem/master/fivem.service
    systemctl enable fivem.service
    sleep 2
    cd /usr/bin/
    wget https://raw.githubusercontent.com/TxHost/Tx-FiveM/master/tx-start.sh
    chmod +x tx-start
    cd
fi
sleep 2

# Installation of MARIADB
echo
printf "${YELLOW} Do you want to create an automatic installation of MariaDB? ❓ [Y/n]\\n"
read reponse
if [[ "$reponse" == "Y" || "$reponse" == "y" ]]; then
    printf "${CYAN} Starting the installation of MariaDB for FiveM server!"
    apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    add-apt-repository -y ppa:chris-lea/redis-server
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
    apt update -y
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update -y
    sudo apt-get install php-mbstring php-gettext
    sudo apt -y install php7.4
    apt install -y php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-client mariadb-server apache2 tar unzip git
    php -v
fi
sleep 2

echo -n -e "${GREEN} What is the name of your database? ❓ ${YELLOW}(tx_base)${reset}: "
read -r DBNAME
if [[ "$DBNAME" == "" ]]; then
    DBNAME="tx_base"
fi
sleep 2

echo -n -e "${GREEN} What is the database user? ❓ ${YELLOW}(txhost)${reset}: "
read -r DBUSER
if [[ "$DBUSER" == "" ]]; then
    DBUSER="txhost"
fi
sleep 2

echo -n -e "${GREEN} What is the database user's password? ❓ ${YELLOW}(txhost) ${reset}: "
read -s -r DBPASS
if [[ "$DBPASS" == "" ]]; then
    DBUSER="txhost"
fi

# Installation of PHPMYADMIN
echo
printf "${YELLOW} Do you want to create an automatic installation of PHPMYADMIN? ❓ [Y/n]\\n"
read reponse
if [[ "$reponse" == "Y" || "$reponse" == "y" ]]; then
    printf "${CYAN} Starting the installation of PHPMYADMIN!"
    apt install phpmyadmin -y
    sudo service apache2 restart
    ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin
fi

echo -e "${YELLOW} Configuring the user"
echo "Enter the MySQL root password"
sleep 2
mysql -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';"
mysql -e "CREATE DATABASE ${DBNAME};"
mysql -p -e "GRANT ALL PRIVILEGES ON * . * TO '${DBUSER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

sleep 3

printf "${COLOR1}✔️ Installation is complete! \\n"
printf "${COLOR3}❤️ TxHost Website: https://txhost.fr/ \\n"
printf "${COLOR3}❤️ TxHost Discord: https://discord.txhost.fr/ \\n"
printf "${COLOR3}❤️ TxHost Github: https://github.com/TxHost/ \\n"
printf "${NC}\\n"
sleep 1
printf "${COLOR1}✔️ MySQL Summary \\n"
printf "${COLOR4}🌐 phpMyAdmin link: http://$(hostname -I)/phpmyadmin/ \\n"
printf "${COLOR4}👤 MySQL Database Username: ${DBUSER}\\n"
printf "${COLOR4}👤 MySQL Database Connection Password: ${DBPASS} \\n"
printf "${NC}\\n"
sleep 1
printf "${COLOR2}✔️ Summary on creating your server! \\n"
printf "${COLOR2}🌐 TxAdmin link: http://$(hostname -I):40120/ \\n"
printf "${COLOR2}💻 Folder Path: /home/fivem \\n"
printf "${COLOR2}⚠️ Do not delete run.sh and alpine\\n"
printf "${NC}\\n"

sleep 10
echo
printf "${YELLOW} Do you want to start your FiveM server? ❓ [Y/n]\\n"
read reponse
if [[ "$reponse" == "Y" || "$reponse" == "y" ]]; then
    printf "${CYAN} Starting your FiveM server!"
    sudo iptables -A INPUT -p tcp --dport 40120 -j ACCEPT
    sudo netfilter-persistent save
    sudo netfilter-persistent reload
    cd /home/fivem
    wget https://raw.githubusercontent.com/TxHost/assets/main/fivem/server.cfg
    bash /home/fivem/run.sh
fi
