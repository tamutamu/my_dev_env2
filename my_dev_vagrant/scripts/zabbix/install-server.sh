#!/bin/bash -eu


### Vars
MYSQL_ROOT_PASS=P@ssword1
MYSQL_ZABBIX_PASS=P@ssword1


### yum update
sudo yum -y install epel-release
sudo yum -y update


### Add remi repo.
sudo rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
sudo rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm


### MySQL8.0
sudo yum -y install enablerepo=remi,remi-php72 mysql-community-devel
sudo yum -y install enablerepo=remi,remi-php72 mysql-community-server

sudo sed -i.bak -e 's/^# \(default-authentication-plugin=mysql_native_password\)/\1/' /etc/my.cnf

sudo systemctl restart mysqld
sudo systemctl enable mysqld

### Get Mysql Defualt password.
init_passwd=$(grep password /var/log/mysqld.log | awk '{idx=match($0, "root@localhost.*$"); sub1=substr($0, idx); split(sub1, ar, " "); print ar[2]}')
sudo mysqladmin -p${init_passwd} password ${MYSQL_ROOT_PASS}

sudo mysql_secure_installation -p${MYSQL_ROOT_PASS} -D


### Install Zabbix
sudo rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-web-japanese
sudo yum -y install zabbix-agent
sudo yum -y install zabbix-get
sudo localedef -f UTF-8 -i ja_JP ja_JP

### Setting Database.
sudo mysql -uroot -p${MYSQL_ROOT_PASS}  << EOT
CREATE DATABASE zabbix character set utf8 collate utf8_bin;
CREATE USER zabbix@localhost IDENTIFIED BY '${MYSQL_ZABBIX_PASS}';
GRANT ALL ON zabbix.* TO zabbix@localhost;
EOT

pushd $(find /usr/share/doc/ -name 'zabbix-server-mysql-*')
  zcat create.sql.gz | mysql -uzabbix -p${MYSQL_ZABBIX_PASS} zabbix
popd

sudo sed -i.bak -e "s/^# DBPassword=/DBPassword=${MYSQL_ZABBIX_PASS}/" /etc/zabbix/zabbix_server.conf
sudo sed -i.bak \
  -e "s/<IfModule mod_php5.c>/<IfModule mod_php7.c>/" \
  -e "s@# php_value date.timezone Europe/Riga@php_value date.timezone Asia/Tokyo@" \
 /etc/httpd/conf.d/zabbix.conf


### Configure PHP
sudo sed -i.bak \
  -e 's/^\(post_max_size =\) .*/\1 16M/' \
  -e 's/^\(max_execution_time =\) .*/\1 300M/' \
  -e 's/^\(max_input_time =\) .*/\1 300M/' \
  -e 's@^;\(date.timezone =\).*@\1 "Asia/Tokyo"@' \
 /etc/php.ini


### Process Restart.
sudo systemctl restart zabbix-server
sudo systemctl enable zabbix-server

sudo systemctl restart httpd
sudo systemctl enable httpd

sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
