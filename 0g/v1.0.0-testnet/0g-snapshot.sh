#!/bin/bash
PROJECT_NAME="0G"


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
wget -O latest_snapshot.tar.lz4 https://rpc-zero-gravity-testnet.trusted-point.com/latest_snapshot.tar.lz4


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop ogd

cp $HOME/.evmosd/data/priv_validator_state.json $HOME/.evmosd/priv_validator_state.json.backup

evmosd tendermint unsafe-reset-all --home $HOME/.evmosd --keep-addr-book

lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.evmosd

mv $HOME/.evmosd/priv_validator_state.json.backup $HOME/.evmosd/data/priv_validator_state.json
rm -f ./latest_snapshot.tar.lz4

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd

