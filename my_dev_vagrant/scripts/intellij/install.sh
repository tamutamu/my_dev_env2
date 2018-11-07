#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)

pushd ${CURDIR}
rm -f ~/.ideavimrc
ln -s ${CURDIR}/../.dotfiles/.ideavimrc ~/.ideavimrc
popd
