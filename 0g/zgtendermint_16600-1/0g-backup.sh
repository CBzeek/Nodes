#!/bin/bash
PROJECT_NAME="0G"
BACKUP_DIR=$HOME/backup_$(date +%F--%R)

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ''

cd $HOME
mkdir -p $BACKUP_DIR/.0gchain/config/
cp -r $HOME/.0gchain/config/priv_validator_key.json $BACKUP_DIR/.0gchain/config/
