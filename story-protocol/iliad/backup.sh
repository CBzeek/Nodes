#!/bin/bash
PROJECT_NAME="Story Protocol"
PROJECT_DIR=".story"
CHAIN_ID="iliad"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

sudo apt install zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/geth/$CHAIN_ID/geth/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/config/
mkdir -p $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/data/

cp -r $HOME/$PROJECT_DIR/story/config/ $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/config/addrbook.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/config/genesis.json
rm -f $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/config/*.toml

cp $HOME/$PROJECT_DIR/story/data/priv_validator_state.json $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/story/data/

cp $HOME/$PROJECT_DIR/geth/$CHAIN_ID/geth/jwtsecret $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/geth/$CHAIN_ID/geth/
cp $HOME/$PROJECT_DIR/geth/$CHAIN_ID/geth/nodekey $HOME/$BACKUP_DIR/${PROJECT_DIR}-${CHAIN_ID}-backup/geth/$CHAIN_ID/geth/

cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip ${PROJECT_DIR}-${CHAIN_ID}-backup
