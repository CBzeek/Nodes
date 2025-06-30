#!/bin/bash
# Variables
PROJECT_NAME="Empeiria"
PROJECT_DIR=".empe-chain"
CHAIN_ID="empe-testnet-2"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

print_header "Backup $PROJECT_NAME node configuration files..."

sudo apt install zip -y

cd $HOME
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/config/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/data/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/keyring-test/

cp -r $HOME/$PROJECT_DIR/config/ $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/config/addrbook.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/config/genesis.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/config/*.toml

cp $HOME/$PROJECT_DIR/data/*.json $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/data/

cp $HOME/$PROJECT_DIR/keyring-test/* $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/${PROJECT_DIR}/keyring-test/

cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip ${PROJECT_DIR}-${CHAIN_ID}-backup

cd $HOME
