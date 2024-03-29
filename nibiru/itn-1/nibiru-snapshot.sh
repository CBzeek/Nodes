#!/bin/bash
PROJECT_NAME="nibid"

cd $HOME

echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl stop nibid


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Erasing data... \e[0m" && sleep 1
echo ''
rm -rf $HOME/.nibid/data/application.db && sleep 5


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Install dependencies... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME snapshot... \e[0m" && sleep 1
echo ''
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
rm -rf $HOME/.nibid/data

curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl start nibid
