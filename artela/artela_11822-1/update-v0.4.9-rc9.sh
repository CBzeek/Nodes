#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop $PROJECT_BIN


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
# make binary
cd && rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.9-rc9
make install

# download new binary
#wget https://github.com/artela-network/artela/releases/download/v0.4.9-rc9/artelad_0.4.9_rc9_Linux_amd64.tar.gz
#tar -xzvf artelad_0.4.9_rc9_Linux_amd64.tar.gz
#rm artelad_0.4.9_rc9_Linux_amd64.tar.gz
#mv -f ./artelad $(which artelad)


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart $PROJECT_BIN



