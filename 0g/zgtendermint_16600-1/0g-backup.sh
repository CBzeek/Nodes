#!/bin/bash
PROJECT_NAME="0G"
BACKUP_DIR=$HOME/${PROJECT_NAME}_backup_$(date +%F--%R)

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir $BACKUP_DIR/config

#rsync -av --exclude='data' --exclude='wasm' $HOME/.okp4d/ $BACKUP_DIR
#rsync -av $HOME/.0gchain/ --exclude='data' $HOME/backup
