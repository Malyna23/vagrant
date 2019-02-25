#!/usr/bin/bash

sudo yum -y update 

#Install web-server(Apache2)
sudo yum -y install httpd 
sudo systemctl start httpd.service      
sudo systemctl enable httpd.service

#Install DB (MariaDB)
sudo yum -y install mariadb-server
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service  
sudo mysql -e"CREATE USER 'mykola'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -e"CREATE DATABASE dbname;"
sudo mysql -e"GRANT ALL PRIVILEGES ON dbname.* TO 'mykola'@'localhost';"
sudo mysql -e"FLUSH PRIVILEGES;"
sudo mysql -e"SET GLOBAL innodb_file_format = 'BARRACUDA';"
sudo mysql -e"SET GLOBAL innodb_large_prefix = 'ON';"
sudo mysql -e"SET GLOBAL innodb_file_per_table = 'ON';"


#Install php7.2
sudo yum -y install epel-release
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72
sudo yum -y update
sudo yum -y install php php-mysql php-xml php-xmlrpc php-gd php-intl php-mbstring php-soap php-zip php-opcache php-cli
sudo systemctl restart httpd.service


#Install moodle 3.6
sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
tar -zxvf moodle-latest-36.tgz
sudo cp -R moodle /var/www/html
sudo /usr/bin/php /var/www/html/moodle/admin/cli/install.php --wwwroot=http://192.168.56.2/moodle --dataroot=/var/moodledata --dbtype=mariadb --dbname=dbname --dbuser=mykola --dbpass=123456 --fullname="Moodle" --adminpass=1Qaz2wsx$  --shortname="Moodle" --non-interactive --agree-license
sudo chmod a+r /var/www/html/moodle/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata
