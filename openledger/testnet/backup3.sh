#!/bin/bash
# Variables
PROJECT_NAME="OpenLedger"
PROJECT_DIR=".config/opl"
CHAIN_ID="testnet"
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
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_NAME}-${CHAIN_ID}-backup/${PROJECT_DIR}/keystore/

cp -ra $HOME/$PROJECT_DIR/* $HOME/$BACKUP_DIR/${PROJECT_NAME}-${CHAIN_ID}-backup/${PROJECT_DIR}

cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip ${PROJECT_NAME}-${CHAIN_ID}-backup

cd $HOME
