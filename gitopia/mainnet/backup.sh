#!/bin/bash
PROJECT_NAME="Gitopia"
PROJECT_DIR=".gitopia"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

sudo apt install rsync zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/gitopia/data/
cp $HOME/$PROJECT_DIR/data/*.json $BACKUP_DIR/gitopia/data/
rsync -av --exclude='data' --exclude='log' $HOME/$PROJECT_DIR/ $BACKUP_DIR/gitopia/
rm -f $BACKUP_DIR/gitopia/config/genesis.json

cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip gitopia
cd $HOME
