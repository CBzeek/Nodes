#!/bin/bash
PROJECT_NAME="Nillion"
PROJECT_DIR="nillion/verifier"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

sudo apt install zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/$PROJECT_DIR
cp $HOME/$PROJECT_DIR/credentials.json $BACKUP_DIR/$PROJECT_DIR

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR
