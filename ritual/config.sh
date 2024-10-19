#!/bin/bash
PROJECT_NAME="Ritual"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Set $PROJECT_NAME node params... \e[0m" && sleep 1
echo ""
read -p "Enter validator private key: " PRIVATE_KEY

# Change $HOME/infernet-container-starter/deploy/config.json
sed -i '/rpc_url/c\        \"rpc_url\" : \"https://mainnet.base.org\",' $HOME/infernet-container-starter/deploy/config.json
sed -i '/registry_address/c\        \"registry_address\" : \"0x3B1554f346DFe5c482Bb4BA31b880c1C18412170\",' $HOME/infernet-container-starter/deploy/config.json
sed -i '/private_key/c\            \"private_key\" : \"${PRIVATE_KEY}",' $HOME/infernet-container-starter/deploy/config.json
sed -i '/sleep/c\            \"sleep\" : \"2",' $HOME/infernet-container-starter/deploy/config.json
sed -i '/batch_size/c\            \"batch_size\" : \"800",' $HOME/infernet-container-starter/deploy/config.json

# copy config to $HOME/infernet-container-starter/projects/hello-world/container/config.jsonv
cp $HOME/infernet-container-starter/deploy/config.json $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Change registry address to 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170
sed -i '/address registry =/c\        address registry = 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170;' $HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol

# Update sender’s address with your private key
# Change RPC_URL to https://mainnet.base.org/
sed -i '/sender \:=/c\sender \:= ${PRIVATE_KEY}' $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile
sed -i '/RPC_URL \:=/c\RPC_URL \:= https://mainnet.base.org' $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile

# Change the node’s image to the latest version (today, this is 1.2.0 but be sure to check for the latest version).
nano ~/infernet-container-starter/deploy/docker-compose.yaml
sed -i '/infernet-node\:1.0.0/c\    image\: ritualnetwork\/infernet-node\:1.2.0' $HOME/infernet-container-starter/deploy/docker-compose.yaml


# Restart docker container
docker restart infernet-anvil
docker restart hello-world
docker restart infernet-node
docker restart deploy-fluentbit-1
docker restart deploy-redis-1

# Verify
docker ps
