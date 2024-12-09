#!/bin/bash
PROJECT_NAME="0G"
PROJECT_FOLDER=".0gchain"
BACKUP_DIR=$HOME/backup_$(date +%F--%H-%M)/0G/

sudo apt install rsync -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''
cd $HOME
mkdir -p $BACKUP_DIR/config/
cp -r $HOME/$PROJECT_FOLDER/config/priv_validator_key.json $BACKUP_DIR/config/
rsync -av --exclude='*/' $HOME/$PROJECT_FOLDER/ $BACKUP_DIR
