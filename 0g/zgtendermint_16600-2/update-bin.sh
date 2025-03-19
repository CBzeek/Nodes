#!/bin/bash
PROJECT_NAME="0G"
VERSION="v0.5.1"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''
# Stop 0g service
sudo systemctl stop ogd

# Backup your priv_validator_key.json file
cd $HOME
rm -rf $HOME/backup-update
mkdir -p $HOME/backup-update/config
mkdir -p $HOME/backup-update/keyring-test
cp $HOME/.0gchain/config/priv_validator_key.json $HOME/backup-update/config
cp $HOME/.0gchain/keyring-test/* $HOME/backup-update/keyring-test
cp $HOME/.0gchain/* $HOME/backup-update


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node... \e[0m" && sleep 1
echo ""

#Delete old release
rm -f 0gchaind-linux-v*

if [ -n "$1" ]
then
    if [ $1 = "v0.3.2" ]
    then
        wget https://github.com/0glabs/0g-chain/releases/download/v0.3.2/0gchaind-linux-v0.3.2
        sudo chmod +x ./0gchaind-linux-v0.3.2
        sudo mv ./0gchaind-linux-v0.3.2 $(which 0gchaind)
    fi
    
    if [ $1 = "v0.3.1" ]
    then
        wget https://github.com/0glabs/0g-chain/releases/download/v0.3.1/0gchaind-linux-v0.3.1
        sudo chmod +x ./0gchaind-linux-v0.3.1
        sudo mv ./0gchaind-linux-v0.3.1 $(which 0gchaind)
    fi

    if [ $1 = "v0.2.5" ]
    then
        # build new binary
        cd && rm -rf 0g-chain
        git clone https://github.com/0glabs/0g-chain
        cd 0g-chain
        git checkout v0.2.5
        make install
#        git clone -b v0.2.5 https://github.com/0glabs/0g-chain.git
    fi

else
    wget https://github.com/0glabs/0g-chain/releases/download/$VERSION/0gchaind-linux-$VERSION
    sudo chmod +x ./0gchaind-linux-$VERSION
    sudo mv ./0gchaind-linux-$VERSION $(which 0gchaind)
fi

#check Version
0gchaind version


#Restart node
sudo systemctl restart ogd

#update Snapshot
#source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/snapshot.sh')

