#!/bin/bash
cd $HOME

echo ''
echo -e "\e[1m\e[32m### Updating packages... \e[0m" && sleep 1
echo ''
sudo apt update && sudo apt upgrade -y

echo ''
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ''
sudo apt install lz4 -y

echo ''
echo -e "\e[1m\e[32m### Stopping okp4 service... \e[0m" && sleep 1
echo ''
sudo systemctl stop okp4d

echo ''
echo -e "\e[1m\e[32m### Updating okp4 snapshot... \e[0m" && sleep 1
echo ''
cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book

rm -rf $HOME/.okp4d/data 
rm -rf $HOME/.okp4d/wasm

SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/okp4-testnet/ | egrep -o ">okp4-nemeton.*\.tar.lz4" | tr -d ">")
curl https://snapshots2-testnet.nodejumper.io/okp4-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.okp4d

mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json

echo ''
echo -e "\e[1m\e[32m### Starting okp4 service... \e[0m" && sleep 1
echo ''
sudo systemctl restart okp4d
