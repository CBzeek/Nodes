#!/bin/bash
PROJECT_NAME="Story Protocol"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node bin... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/update-bin.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Get $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ""
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/snapshot.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Show $PROJECT_NAME node logs... \e[0m" && sleep 1
echo ""
sudo journalctl -u story -f -o cat
