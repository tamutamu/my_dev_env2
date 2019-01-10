#!/bin/bash -eu

sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
apt update
apt upgrade -y
apt install -y --force-yes  linux-headers-generic
