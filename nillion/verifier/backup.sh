#!/bin/bash
PROJECT_NAME="Nillion"
PROJECT_DIR="nillion"
PROJECT_SUB_DIR="verifier"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


sudo apt install zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/$PROJECT_DIR/$PROJECT_SUB_DIR
cp $HOME/$PROJECT_DIR/$PROJECT_SUB_DIR/credentials.json $BACKUP_DIR/$PROJECT_DIR/$PROJECT_SUB_DIR
cd $BACKUP_DIR
zip -r $HOME/$BACKUP_DIR.zip $PROJECT_DIR
cd $HOME
