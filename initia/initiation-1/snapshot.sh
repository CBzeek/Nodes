#!/bin/bash
PROJECT_NAME="Initia"


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop initiad

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''

#shapshot
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
#rm -rf $HOME/.initia/data
#curl -L https://snapshots.kzvn.xyz/initia/initiation-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
#curl -L https://snapshots-testnet.nodejumper.io/initia-testnet/initia-testnet_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.initia
#curl -L https://snapshots.kjnodes.com/initia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
#curl -L https://initia-testnet-snapshots.f5nodes.com/initiation-1_468826.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
#curl -L https://files3.blacknodes.net/initiatestnet/initiation-1_475946.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
#wget -O latest_snapshot.tar.lz4 https://files3.blacknodes.net/initiatestnet/initiation-1_475946.tar.lz4
wget -O latest_snapshot.tar.lz4 https://storage.crouton.digital/testnet/initia/snapshots/initia_latest.tar.lz4
lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.initia
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
rm -f ./initia-testnet_latest.tar.lz4


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart initiad
