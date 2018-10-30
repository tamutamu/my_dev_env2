#!/bin/bash -eux

echo '==> Updating list of repositories'
sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list.d/official-package-repositories.list
apt-get -y update

# Remove any pre-installed virtualbox packages
apt-get -y purge virtualbox*

echo '==> Performing dist-upgrade (all packages and kernel)'
apt-get -y dist-upgrade
