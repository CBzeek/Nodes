#!/bin/bash
cd $HOME

PROJECT_NAME="nibid"

echo ''
echo -e "\e[1m\e[32m### Updating packages... \e[0m" && sleep 1
echo ''
sudo apt update && sudo apt upgrade -y

echo ''
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ''
sudo apt install lz4 -y

echo ''
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl stop nibid

echo ''
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME snapshot... \e[0m" && sleep 1
echo ''
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book

rm -rf $HOME/.nibid/data 

SNAP_NAME=$(curl -s https://snapshots3-testnet.nodejumper.io/nibiru-testnet/ | egrep -o ">nibiru-testnet-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots3-testnet.nodejumper.io/nibiru-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.nibid

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json

echo ''
echo -e "\e[1m\e[32m### Starting okp4 service... \e[0m" && sleep 1
echo ''
sudo systemctl restart nibid
