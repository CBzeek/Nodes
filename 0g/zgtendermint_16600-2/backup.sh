#!/bin/bash
PROJECT_NAME="0G"
PROJECT_DIR=".0gchain"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


sudo apt install rsync zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/0gchain/config/ $BACKUP_DIR/0gchain/data/
cp $HOME/$PROJECT_DIR/data/*.json $BACKUP_DIR/0gchain/data/
rsync -av --exclude='data' --exclude='log' $HOME/$PROJECT_DIR/ $BACKUP_DIR/0gchain/

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR

