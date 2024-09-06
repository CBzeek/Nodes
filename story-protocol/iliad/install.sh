#!/bin/bash
PROJECT_NAME="Story Protocol"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
sudo apt-get update -y && sudo apt upgrade -y && sudo apt-get install make build-essential pkg-config libssl-dev unzip tar lz4 gcc git jq -y


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
source <(wget -qO- 'https://api.nodes.guru/story.sh')
