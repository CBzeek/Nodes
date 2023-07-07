#!/bin/bash
PROJECT_NAME="massa"

cd $HOME

VERSION=$(curl https://api.github.com/repos/massalabs/massa/releases/latest 2>null | jq -r '.name')
BACKUP_DIR=$HOME/${PROJECT_NAME}_backup_$(date +%F-%R)


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl stop massad


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Backup $PROJECT_NAME configuration files... \e[0m" && sleep 1
echo ''
rsync -av --exclude='massa-node/storage' --exclude='massa-client/massa-client' --exclude='massa-node/massa-node' $HOME/massa/ $BACKUP_DIR
rm -rf "$HOME/massa/massa-client/massa-client" "$HOME/massa/massa-node/massa-node"


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME binaries to version ${VERSION}... \e[0m" && sleep 1
echo ''
wget -O "massa_${VERSION}_release_linux.tar.gz" "https://github.com/massalabs/massa/releases/download/${VERSION}/massa_${VERSION}_release_linux.tar.gz"


chmod +x massa-client
chmod +x massa-node

mv massa-client $HOME/massa/massa-client
mv massa-node $HOME/massa/massa-node


echo ''
echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl restart massad

massa_node_info
