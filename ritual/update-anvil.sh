#!/bin/bash
PROJECT_NAME="Ritual"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Configure $PROJECT_NAME node setings... \e[0m" && sleep 1
echo ""

# Backup config
cp $HOME/infernet-container-starter/deploy/docker-compose.yaml $HOME/infernet-container-starter/deploy/docker-compose.yaml.bak

# Infernet node image version
yq -i '.services.infernet-anvil.command = "--host 0.0.0.0 --port 3000 --load-state infernet_deployed.json -b 1 --prune-history"' docker-compose.yaml

# Restart
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/ritual/restart.sh')
