#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)

pushd /opt/scripts/
sudo rm -rf py-backup
git clone https://github.com/tamutamu/py-backup.git
pushd py-backup
python setup.py install
popd
popd

sudo cp ${CURDIR}/conf/personal_backup.sh /opt/scripts/py-backup/

sudo chmod +x /opt/scripts/py-backup/personal_backup.sh

# Execute backup script when os shutdown.
sudo cp ${CURDIR}/conf/personal_backup.service /etc/systemd/system/

sudo systemctl enable personal_backup.service
