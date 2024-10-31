#!/bin/bash
PROJECT_NAME="Ritual"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
cd $HOME/infernet-container-starter

# Change the node’s image to the latest version (today, this is 1.2.0 but be sure to check for the latest version).
sed -i '/infernet-node\:1.2.0/c\    image\: ritualnetwork\/infernet-node\:1.4.0' $HOME/infernet-container-starter/deploy/docker-compose.yaml

# Stop container
docker-compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml down

# Restart docker container
docker restart infernet-anvil
docker restart hello-world
docker restart infernet-node
docker restart deploy-fluentbit-1
docker restart deploy-redis-1

