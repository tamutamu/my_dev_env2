#!/bin/bash

CURDIR=$(cd $(dirname $0); pwd)

sudo add-apt-repository -y ppa:jasonpleau/rofi
sudo apt -y update
sudo apt -y install rofi

mkdir -p ~/.config
ln -s ${CURDIR}/config/rofi ~/.config/rofi
