#!/bin/bash
PROJECT_NAME="Ritual"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
cd $HOME/infernet-container-starter

# Change the node’s image to the latest version (today, this is 1.2.0 but be sure to check for the latest version).
sed -i '/infernet-node\:1.2.0/c\    image\: ritualnetwork\/infernet-node\:1.4.0' $HOME/infernet-container-starter/deploy/docker-compose.yaml

# Restart
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/ritual/restart.sh')
