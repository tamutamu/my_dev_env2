#!/bin/bash
set -euo pipefail

echo "Install NFS Server." 

CURDIR=$(cd $(dirname $0); pwd)
. ./var.conf

### Install
yum -y install nfs-utils nfs-utils-lib

mkdir /var/exports
echo '/var/exports  *(rw,all_squash,fsid=0,crossmnt)' >> /etc/exports
exportfs -r
exportfs -v

systemctl enable nfs-server
systemctl restart nfs-server
