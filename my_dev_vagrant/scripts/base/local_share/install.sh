#!/bin/bash
set -euo pipefail

CURDIR=$(cd $(dirname $0); pwd)
pushd ${CURDIR}


### Desktop launcher.
mkdir -p ~/.local/share
ln -s ${MY_DEV_BASE_PATH}/.dotfiles/share/applications/ ~/.local/share/


popd
