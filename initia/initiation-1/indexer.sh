#!/bin/bash
PROJECT_NAME="Initia"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop initiad

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Turn off $PROJECT_NAME node indexer... \e[0m" && sleep 1
echo ''
#indexer
rm -rf $HOME/.initia/data/snapshots
rm -rf $HOME/.initia/data/tx_index.db
sed -i "s/^indexer *=.*/indexer = \"null\"/" $HOME/.initia/config/config.toml
sed -i "s/^snapshot-interval *=.*/snapshot-interval = 0/" $HOME/.initia/config/app.toml

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart initiad
