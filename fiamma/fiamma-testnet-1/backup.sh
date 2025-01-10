#!/bin/bash
# Variables
PROJECT_NAME="Fiamma"
PROJECT_DIR=".fiamma"
CHAIN_ID="tesnet-1"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

sudo apt install zip -y


echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Backup $PROJECT_NAME node configuration files..."
echo -e "${NO_COLOR}" && sleep 1
echo ""

cd $HOME
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/config/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/data/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/keyring-test/

cp -r $HOME/$PROJECT_DIR/config/ $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/config/addrbook.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/config/genesis.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/config/*.toml

cp $HOME/$PROJECT_DIR/data/priv_validator_state.json $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/data/

cp $HOME/$PROJECT_DIR/keyring-test/* $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/fiamma/keyring-test/

cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip ${PROJECT_DIR}-${CHAIN_ID}-backup

cd $HOME
