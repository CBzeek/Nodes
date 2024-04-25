#!/bin/bash
PROJECT_NAME="0G"


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop ogd

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
wget -O $HOME/.evmosd/config/addrbook.json https://rpc-zero-gravity-testnet.trusted-point.com/addrbook.json


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd
