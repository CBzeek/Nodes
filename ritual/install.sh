#!/bin/bash
PROJECT_NAME="Ritual"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Clone Ritual's repository
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter
cd infernet-container-starter
sed -i 's/docker compose/docker-compose/' $HOME/infernet-container-starter/Makefile

# Deploy container
project=hello-world make deploy-container

