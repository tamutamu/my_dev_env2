#!/bin/bash -eu

### Vars
ZABBIX_SERVER_IP=192.168.33.10


### yum update
sudo yum -y install epel-release
sudo yum -y update


### Install Zabbix-Agent
sudo rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
sudo yum -y install zabbix-agent
sudo yum -y install zabbix-get


### Configure zabbix agent.

# Get Hostname
sudo sed -i.bak \
    -e "s/\(^Server\)=.*$/\1=${ZABBIX_SERVER_IP}/" \
    -e "s/\(^ServerActive\)=.*$/\1=${ZABBIX_SERVER_IP}/" \
    -e "s/\(^Hostname\)=.*$/\1=$(hostname)/" \
  /etc/zabbix/zabbix_agentd.conf

### Process Restart.
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
