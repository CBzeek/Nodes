#!/bin/bash
PROJECT_NAME="Ritual"


# Install Docker
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/ritual/docker.sh')
docker run hello-world

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Clone Ritual's repository
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter
cd infernet-container-starter
sed -i 's/docker compose/docker-compose/' $HOME/infernet-container-starter/Makefile

# Configure node
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/ritual/configure-node.sh')

# Deploy container
#project=hello-world make deploy-container
docker-compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml up -d

# Check docker
docker container ls



