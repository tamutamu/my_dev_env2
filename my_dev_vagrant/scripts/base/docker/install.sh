#!/bin/bash


CURDIR=$(cd $(dirname $0); pwd)

### Install docker-ce.
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update

sudo apt -y install docker-ce

### Config
sudo cp -rf ${CURDIR}/config/systemd/docker.service.d /etc/systemd/system/
sudo cp -rf ${CURDIR}/config/etc/default/docker /etc/default/
sudo cp -rf ${CURDIR}/config/etc/docker/daemon.json /etc/docker/

sudo systemctl restart docker.service
sudo docker info



### Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.20.0/docker-compose-`uname -s`-`uname -m` \
	-o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
