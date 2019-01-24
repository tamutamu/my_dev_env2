#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


pushd /tmp

rm -rf /tmp/xkeysnail
git clone https://github.com/mooz/xkeysnail.git

pushd xkeysnail
pip install .
popd

ln -s ${CURDIR}/../.dotfiles/.xkeysnail ~/

sudo mkdir -p /opt/scripts/xkeysnail/
sudo cp ${CURDIR}/config/start_xkeysnail.sh /opt/scripts/xkeysnail/


## Setting input/uinput permission.
echo 'KERNEL=="uinput", GROUP="tamutamu"' | sudo tee /etc/udev/rules.d/40-udev-xkeysnail.rules
echo 'KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="tamutamu"' | sudo tee /etc/udev/rules.d/99-input.rules

popd
