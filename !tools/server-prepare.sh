#!/bin/bash
cd $HOME

PROJECT_NAME="New server"

#Ubuntu update and upgrade
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating and Upgrading $PROJECT_NAME... \e[0m" && sleep 1
echo ''
sudo apt update && sudo apt upgrade -y

#Install software
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Installing dependencies to $PROJECT_NAME... \e[0m" && sleep 1
echo ''
sudo apt install -y curl mc git jq screen lz4 htop
