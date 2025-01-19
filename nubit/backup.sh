#!/bin/bash
PROJECT_NAME="Nubit"
PROJECT_DIR=".nubit-light-nubit-alphatestnet-1"
BACKUP_DIR=backup_$(date +%F--%H-%M-%S)

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


sudo apt install rsync zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $HOME/$BACKUP_DIR/nubit-light-nubit-alphatestnet-1/
mkdir -p $HOME/$BACKUP_DIR/nubit-node/
rsync -av  $HOME/$PROJECT_DIR/keys $HOME/$BACKUP_DIR/nubit-light-nubit-alphatestnet-1/
cp $HOME/nubit-node/mnemonic.txt $HOME/$BACKUP_DIR/nubit-node

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR
