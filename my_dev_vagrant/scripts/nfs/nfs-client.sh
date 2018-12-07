#!/bin/bash
set -euo pipefail

echo "Install NFS Client." 

CURDIR=$(cd $(dirname $0); pwd)
. ./var.conf

### Install
yum -y install nfs-utils nfs-utils-lib
echo "${NFS_SERVER_IP}:/ /mnt/nfs nfs4 defaults 0 0" >> /etc/fstab

mkdir /mnt/nfs
mount /mnt/nfs
