#!/bin/bash

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

cd $HOME

#Ubuntu update and upgrade
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updating and Upgrading server... \e[0m"
echo '' && sleep 1
sudo apt update && sudo apt upgrade -y


#Install software
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies to server... \e[0m"
echo '' && sleep 1
sudo apt install curl mc git jq screen lz4 build-essential htop zip unzip wget rsync snapd -y
sudo snap install yq
