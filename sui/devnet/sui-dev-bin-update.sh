#!/bin/bash
cd $HOME

PROJECT_NAME="sui"

#Stop service
echo ''
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
systemctl stop suid

#Erase data
echo ''
echo -e "\e[1m\e[32m### Erasing $PROJECT_NAME data... \e[0m" && sleep 1
echo ''
rm -rf /var/sui/db/* /var/sui/genesis.blob $HOME/sui
mkdir -p /var/sui/db

#Update bin and genesis
echo ''
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME binaries and genesis... \e[0m" && sleep 1
echo ''
#wget -O sui-node https://github.com/MystenLabs/sui/releases/download/devnet-0.14.1/sui-node
wget -O sui-node https://github.com/MystenLabs/sui/releases/download/devnet-0.15.0/sui-node
#wget -O sui https://github.com/MystenLabs/sui/releases/download/devnet-0.14.1/sui
wget -O sui https://github.com/MystenLabs/sui/releases/download/devnet-0.15.0/sui

chmod +x sui-node
chmod +x sui

mv sui-node /usr/local/bin/
mv sui /usr/local/bin/

wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

#Restart service 
echo ''
echo -e "\e[1m\e[32m### Starting$PROJECT_NAME service... \e[0m" && sleep 1
echo ''
systemctl restart suid
