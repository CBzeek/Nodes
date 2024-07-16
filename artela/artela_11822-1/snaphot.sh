#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop $PROJECT_BIN


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
rm -rf $HOME/.artelad/data/application.db 
sleep 1
cp $HOME/.artelad/data/priv_validator_state.json $HOME/.artelad/priv_validator_state.json.backup
artelad tendermint unsafe-reset-all --home $HOME/.artelad --keep-addr-book
curl "https://snapshots-testnet.nodejumper.io/artela-testnet/artela-testnet_latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.artelad"
mv $HOME/.artelad/priv_validator_state.json.backup $HOME/.artelad/data/priv_validator_state.json


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart $PROJECT_BIN
