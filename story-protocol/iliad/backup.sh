#!/bin/bash
PROJECT_NAME="Story Protocol"
PROJECT_DIR=".story"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

sudo apt install zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $HOME/$BACKUP_DIR/geth/iliad/geth/
mkdir -p $HOME/$BACKUP_DIR/story/config/ $HOME/$BACKUP_DIR/story/data/

cp -r $HOME/$PROJECT_DIR//story/config/ $HOME/$BACKUP_DIR/story/
rm -f $HOME/$BACKUP_DIR/story/config/addrbook.json
rm -f $HOME/$BACKUP_DIR/story/config/genesis.json
rm -f $HOME/$BACKUP_DIR/story/config/*.toml

cp $HOME/$PROJECT_DIR/story/data/priv_validator_state.json $HOME/$BACKUP_DIR/story/data/

cp $HOME/$PROJECT_DIR/geth/iliad/geth/jwtsecret $HOME/$BACKUP_DIR/geth/iliad/geth/
cp $HOME/$PROJECT_DIR/geth/iliad/geth/nodekey $HOME/$BACKUP_DIR/geth/iliad/geth/

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR
