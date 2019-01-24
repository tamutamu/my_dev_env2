#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)


sudo apt -y install libcairo2-dev libxinerama-dev libxdo-dev

tmp=$(mktemp -d --suffix=.my_dev)
pushd ${tmp}

git clone https://github.com/jordansissel/keynav.git
cd keynav
sudo make && sudo make install

popd
rm -rf ${tmp}


ln -s ${CURDIR}/../.dotfiles/.keynavrc ~/.keynavrc

mkdir /opt/scripts/keynav
ln -s ${CURDIR}/conf/start_keynav.sh /opt/scripts/keynav/
