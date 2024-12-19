#!/bin/bash
PROJECT_NAME="Ritual"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""

docker-compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml down
docker-compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml up -d
