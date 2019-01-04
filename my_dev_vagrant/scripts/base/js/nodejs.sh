#!/bin/bash -eu

sudo apt -y install nodejs npm

sudo npm cache clean
sudo npm -g install n

sudo n stable
sudo ln -sf /usr/local/bin/node /usr/bin/node

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.profile
source ~/.profile
