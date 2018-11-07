#!/bin/bash
set -euo pipefail


CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}

sudo apt -y install squid
sudo cp ${CURDIR}/config/squid.conf /etc/squid/


sudo systemctl enable squid.service
sudo systemctl restart squid.service

popd
