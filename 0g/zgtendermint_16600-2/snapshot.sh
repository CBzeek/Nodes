#!/bin/bash
PROJECT_NAME="0G"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop ogd

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
rm -rf $HOME/.0gchain/data/application.db 
sleep 1
cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
#0gchaind tendermint unsafe-reset-all --home $HOME/.0gchain --keep-addr-book
rm -rf $HOME/.0gchain/data

if [ -n "$1" ]
then
    if [ $1 = "591029" ]
    then
        wget -O latest_snapshot.tar.lz4 https://server-5.itrocket.net/testnet/og/og_2024-08-09_591029_snap.tar.lz4
    fi

    if [ $1 = "josephtran" ]
    then
        wget -O latest_snapshot.tar.lz4 https://vps4.josephtran.xyz/0g/0gchain_snapshot.lz4
    fi

    if [ $1 = "liveraven" ]
    then
        wget -O latest_snapshot.tar.lz4 http://snapshots.liveraven.net/snapshots/testnet/zero-gravity/zgtendermint_16600-2_latest.tar.lz4
    fi

    if [ $1 = "nodejumper" ]
    then
        wget -O latest_snapshot.tar.lz4 https://snapshots-testnet.nodejumper.io/0g-testnet/0g-testnet_latest.tar.lz4
    fi

else
    wget -O latest_snapshot.tar.lz4 http://snapshots.liveraven.net/snapshots/testnet/zero-gravity/zgtendermint_16600-2_latest.tar.lz4
#    wget -O latest_snapshot.tar.lz4 https://snapshot.validatorvn.com/0g/data.tar.lz4
fi

lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.0gchain
mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json
rm -f ./latest_snapshot.tar.lz4

#rm -rf $HOME/.evmosd/data/snapshots
#cp $HOME/.evmosd/data/priv_validator_state.json $HOME/.evmosd/priv_validator_state.json.backup
#evmosd tendermint unsafe-reset-all --home $HOME/.evmosd --keep-addr-book
#wget -O latest_snapshot.tar.lz4 https://rpc-zero-gravity-testnet.trusted-point.com/latest_snapshot.tar.lz4
#lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.evmosd
#mv $HOME/.evmosd/priv_validator_state.json.backup $HOME/.evmosd/data/priv_validator_state.json
#rm -f ./latest_snapshot.tar.lz4

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd
