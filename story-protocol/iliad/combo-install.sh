#!/bin/bash
PROJECT_NAME="Story Protocol"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install Tools... \e[0m" && sleep 1
echo ''
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/install.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Show $PROJECT_NAME node logs... \e[0m" && sleep 1
echo ""
sudo journalctl -u story -f -o cat
