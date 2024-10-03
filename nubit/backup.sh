#!/bin/bash
PROJECT_NAME="Nubit"
PROJECT_FOLDER=".nubit-light-nubit-alphatestnet-1"
BACKUP_DIR=$HOME/backup_$(date +%F--%H-%M)/

sudo apt install rsync zip -y

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/nubit-light-nubit-alphatestnet-1/
mkdir -p $BACKUP_DIR/nubit-node/
rsync -av  $HOME/$PROJECT_FOLDER/keys $BACKUP_DIR/nubit-light-nubit-alphatestnet-1/
cp $HOME/nubit-node/mnemonic.txt $BACKUP_DIR/nubit-node

zip -r $BACKUP_DIR.zip $HOME/$BACKUP_DIR
