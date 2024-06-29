#!/bin/bash
PROJECT_NAME="0G"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''
# Stop and disable 0g service
sudo systemctl stop ogd && sudo systemctl disable ogd

# Backup your priv_validator_key.json file
cd $HOME
rm -rf $HOME/backup-update
mkdir -p $HOME/backup-update/config
mkdir -p $HOME/backup-update/keyring-test
cp $HOME/.0gchain/config/priv_validator_key.json $HOME/backup-update/config
cp $HOME/.0gchain/keyring-test/* $HOME/backup-update/keyring-test
cp $HOME/.0gchain/* $HOME/backup-update

# Change network
sed -i 's/zgtendermint_16600-1/zgtendermint_16600-2/' $HOME/.bash_profile

# Delete your 0g chain
rm -rf $HOME/0g-chain/ $HOME/.0gchain

# Install new node
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/install.sh')

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restore $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

# Stop 0g service
sudo systemctl stop ogd

# Backup your priv_validator_key.json file
cd $HOME
cp $HOME/backup-update/config/priv_validator_key.json $HOME/.0gchain/config
cp $HOME/backup-update/keyring-test/* $HOME/.0gchain/keyring-test
cp $HOME/backup-update/* $HOME/.0gchain

rm -rf $HOME/backup-update

# Restart 0g service
sudo systemctl restart ogd

