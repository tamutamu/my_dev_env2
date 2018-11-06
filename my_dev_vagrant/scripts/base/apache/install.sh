#!/bin/bash


sudo apt -y install apache2
sudo a2enmod ssl

systemctl stop apache2
systemctl disable apache2
