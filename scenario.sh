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
sudo yum -y install php php-mysql php-xml php-xmlrpc php-gd php-intl php-mbstring php-soap php-zip php-opcache
sudo systemctl restart httpd.service


#Install moodle 3.6
sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
tar -zxvf moodle-latest-36.tgz
sudo cp -R moodle /var/www/html
sudo mkdir /var/moodledata
sudo chmod 777 /var/moodledata/
sudo touch /var/www/html/moodle/config.php
sudo chmod 777 /var/www/html/moodle/config.php
sudo echo "<?php  // Moodle configuration file

unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();
\$CFG->dbtype    = 'mariadb';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = 'dbname';
\$CFG->dbuser    = 'mykola';
\$CFG->dbpass    = '123456';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_general_ci',
);
\$CFG->wwwroot   = 'http://192.168.56.2/moodle';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');" > /var/www/html/moodle/config.php