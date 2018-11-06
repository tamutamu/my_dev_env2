#!/bin/bash -eu

pushd /tmp
rm -rf /tmp/lxd_manager
git clone https://github.com/tamutamu/lxd_manager.git
pushd lxd_manager
./install_lxd.sh
popd
popd
