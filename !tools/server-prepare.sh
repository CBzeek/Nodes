#!/bin/bash
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
sudo apt install curl mc git jq screen lz4 htop zip unzip -y
