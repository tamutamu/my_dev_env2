#!/bin/bash

mkdir -p /vagrant/backups/personal/

py-backup -r 10 -s /home/tamutamu/ -d /vagrant/backups/personal/ \
  -e "\/home\/tamutamu\/\.m2.*$" \
  -e "\/home\/tamutamu\/\.pyenv.*$" \
  -e "\/home\/tamutamu\/\.rbenv.*$" \
  -e "\/home\/tamutamu\/\.cache.*$" \
  -e "\/home\/tamutamu\/\.gem.*$"
