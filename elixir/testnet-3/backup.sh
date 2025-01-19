#!/bin/bash
PROJECT_NAME="Elixir"
PROJECT_DIR=".elixir"
BACKUP_DIR=backup_$(curl -s eth0.me)_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


sudo apt install zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/elixir/ 
cp $HOME/$PROJECT_DIR/* $BACKUP_DIR/elixir/

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR
