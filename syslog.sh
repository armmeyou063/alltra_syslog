#!/bin/bash
local=`pwd`


# ==================================================================================================================================
# INSTALL DEFAULT 
# ==================================================================================================================================
echo "=============================================================================="
echo "Start install Alltra Syslog."
echo "Do you want to install Alltra Syslog?"
echo "yes : I want to install Alltra Syslog."
echo "no : I don't want to install Alltra Syslog."
echo "Please choose you want answer ?"
echo "=============================================================================="
read start
if [ "$start" == "y" ] || [ "$start" == "yes" ] || [ "$start" == "YES" ]
then
echo "=============================================================================="
echo "Part 1 Install Common file."
echo "=============================================================================="

echo "=============================================================================="
echo "Install Net-tools."
echo "=============================================================================="
sudo apt install net-tools -y
echo "=============================================================================="
echo "Complete."
echo "=============================================================================="

echo "=============================================================================="
echo "UPDATE OS."
echo "=============================================================================="
sudo apt update -y
echo "=============================================================================="
echo "Complete."
echo "=============================================================================="

echo "=============================================================================="
echo "UPGRADE OS."
echo "=============================================================================="
sudo apt upgrade -y
echo "=============================================================================="
echo "Complete."
echo "=============================================================================="

echo "=============================================================================="
echo "My SQL-Server."
echo "=============================================================================="
sudo apt install mysql-server -y
echo "=============================================================================="
echo "Complete."
echo "=============================================================================="

echo "=============================================================================="
echo "Install PHP MYADMIN."
echo "=============================================================================="
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
sudo sed -i 's,^max_execution_time =.*$,max_execution_time = 60,' /etc/php/7.4/apache2/php.ini
sudo sed -i 's,^upload_max_filesize =.*$,upload_max_filesize = 80M,' /etc/php/7.4/apache2/php.ini
sudo sed -i 's,^max_file_uploads =.*$,max_file_uploads = 200,' /etc/php/7.4/apache2/php.ini
sudo sed -i 's,^post_max_size =.*$,post_max_size = 80M,' /etc/php/7.4/apache2/php.ini
systemctl restart apache2
echo "=============================================================================="
echo "Complete."
echo "=============================================================================="
echo "=============================================================================="
echo "=============================================================================="
echo "Part 2 GIT Clone"
echo "=============================================================================="
echo "=============================================================================="
echo "Do you want to Git Clone Data ?"
echo "yes : I want to Git Clone Data. "
echo "no : I don't want to Git Clone Data."
echo "=============================================================================="
echo "Please choose you want answer ?"
echo "=============================================================================="
read git
if [ "$git" == "y" ] || [ "$git" == "yes" ] || [ "$git" == "YES" ]
then
echo "=============================================================================="
echo "Dowload Git Clone Alltra Syslog."
echo "Please input username and  password for git clone."
echo "=============================================================================="
sudo git clone  https://gitlab.com/alltra/alltra-log.git
echo "=============================================================================="
echo "Complete"
echo "=============================================================================="
else
echo "=============================================================================="
echo "No Git clone data."
echo "=============================================================================="
fi

# ==================================================================================================================================
# INSTALL MYSQL
# ==================================================================================================================================
echo "============================================================================="
echo "Part 3  Install MYSQL"
echo "============================================================================="
echo "Do you want to Configure MYSQL ? "
echo "yes : I want to configure mysql."
echo "no : I don't want to configure mysql."
echo "=============================================================================="
echo "Please choose you want answer ?"
echo "=============================================================================="
read database
if [ "$database" == "y" ] || [ "$database" == "yes" ] || [ "$database" == "YES" ]
then
echo "Please input create  user for  database."
read user
echo "Please input create Password for  database"
echo "**** Password should character @,!,123,A,a. ****"
read password
sudo mysql -e "CREATE USER '"$user"'@'localhost' IDENTIFIED BY '"$password"';"
sudo mysql -e  "ALTER USER '"$user"'@'localhost' IDENTIFIED WITH mysql_native_password BY '"$password"';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '"$user"'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e "SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));"
echo "=============================================================================="
echo "CREATE USER Complete."
echo "=============================================================================="
echo "=============================================================================="
echo "=============================================================================="
echo "Create database."
echo "=============================================================================="
sudo mysql -e 'CREATE DATABASE alltranectec  COLLATE utf8mb4_general_ci;'
echo "=============================================================================="
echo "Complete"
echo "=============================================================================="
else
echo "=============================================================================="
echo "No Configure MYSQL."
echo "=============================================================================="
fi

echo "============================================================================="
echo "Part 4  Import Database File."
echo "============================================================================="
echo "=============================================================================="
echo "Do you want to import database."
echo "yes : I want to import database."
echo "no : I don't want to import database."
echo "Please choose you want answer ?"
echo "=============================================================================="
read  import
if [ "$import" ==  "y" ] || [ "$import" == "yes" ] || [ "$import" == "YES" ]
then
sudo mysql -u alltra -p alltranectec < $local/alltra-log/alltranectec2.sql
echo "Please input Password database for Import file."
echo "=============================================================================="
echo "Complete"
echo "=============================================================================="
else
echo "=============================================================================="
echo "No I don't import."
echo "=============================================================================="
fi


# ==================================================================================================================================
# INSTALL COMMONS
# ==================================================================================================================================
echo "============================================================================="
echo "Part 5  Install Package"
echo "============================================================================="
echo "=============================================================================="
echo "Do you want to Install package ?"
echo "yes : I want to install Package."
echo "no : I don't want to install package."
echo "Please choose you want answer ?"
echo "=============================================================================="
read  package
if [ "$package" == "y" ] || [ "$package" == "yes" ] ||[ "$package" == "YES" ] 
then
sudo apt install python3-pip -y
sudo apt install sysstat -y
sudo apt install syslog-ng -y
sudo pip3 install mysql-connector-python 
sudo pip3 install  secure-smtplib
sudo apt install nodejs -y
sudo apt install npm -y
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs -y
Sudo apt install npm -y
node -v
npm install forever -g
npm install pm2 -g 
timedatectl set-timezone 'Asia/Bangkok'
sudo touch /etc/syslog-ng/apache2.conf
echo   'source source3{file("/var/log/apache2/access.log");};''destination dest3{network("127.0.0.1" port(514));};''log{source(source3);destination(dest3);};' > /etc/syslog-ng/apache2.conf
cp  $local/alltra-log/syslog-ng.conf /etc/syslog-ng/
systemctl restart syslog-ng
loggen -D -i -I 10 -r 100 -s 150 127.0.0.1 514
cp  $local/alltra-log/python/alltra.py  /var/log/alltra
sed -i 's/alltra1234/P@ssw0rd/' $local/alltra-log/app.js
sed -i 's/database="alltra"/database="alltranectec/' /var/log/alltra/alltra.py
sed -i 's/rHCBGz4BnmYw@/P@ssw0rd/' /var/log/alltra/alltra.py
echo "=============================================================================="
echo "Complete"
echo "=============================================================================="
else
echo "=============================================================================="
echo "No don't Install package"
echo "=============================================================================="
fi

echo "============================================================================="
echo "Part 6  Start app."
echo "============================================================================="
echo "=============================================================================="
echo "if you want Start app ?"
echo "yes : I want to start app."
echo "no : I don't to start app."
echo "Please choose want to answer ?"
echo "=============================================================================="
read  work
if [ "$work" == "y" ] || [ "$work" == "yes" ] || [ "$work" == "YES" ]
then
echo "Start app."
forever start $local/alltra-log/app.js
pm2 start /var/log/alltra/alltra.py --name alltra --interpreter python3
pm2 save
else
echo "No start app."
forever restart $local/alltra-log/app.js
pm2 restart /var/log/alltra/alltra.py --name alltra --interpreter python3
pm2 save
fi

echo "=============================================================================="
echo "================================ END ========================================="
echo "=============================================================================="
else
echo "NO Start install Alltra Syslog."
fi
# ================================================================================================================================
# ==================================================== END ======================================================================
# ================================================================================================================================
