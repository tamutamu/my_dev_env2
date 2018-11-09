#!/bin/bash


sudo apt -y install apache2
sudo a2enmod ssl

sudo systemctl stop apache2
sudo systemctl disable apache2
