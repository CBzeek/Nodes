#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop $PROJECT_BIN


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
# download new binary
wget https://github.com/artela-network/artela/releases/download/v0.4.9-rc9/artelad_0.4.9_rc9_Linux_amd64.tar.gz
tar -xzvf artelad_0.4.9_rc9_Linux_amd64.tar.gz
rm artelad_0.4.9_rc9_Linux_amd64.tar.gz
mv -f ./artelad $(which artelad)


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/artela/artela_11822-1/snaphot.sh')
