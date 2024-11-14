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

# Deploy container
project=hello-world make deploy-container

# Check docker
docker container ls

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Configure $PROJECT_NAME node... \e[0m" && sleep 1
echo ""

read -p "Enter your private key (example: 0x123....123): " PRIVATE_KEY

# Backup config
cp $HOME/infernet-container-starter/deploy/config.json $HOME/infernet-container-starter/deploy/config.json.backup
cp $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/projects/hello-world/container/config.json.backup

# RPC
yq -i '.chain.rpc_url = "https://mainnet.base.org/"' $HOME/infernet-container-starter/deploy/config.json

# Private Key
PRIV=$PRIVATE_KEY yq -i '.chain.wallet.private_key = strenv(PRIV)' $HOME/infernet-container-starter/deploy/config.json

# Registry address
yq -i '.chain.registry_address = "0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"' $HOME/infernet-container-starter/deploy/config.json

# Trail head blocks
yq -i '.chain.trail_head_blocks = 3' $HOME/infernet-container-starter/deploy/config.json

# Snapshot settings
yq -i '.chain.snapshot_sync.sleep = 3' $HOME/infernet-container-starter/deploy/config.json
yq -i '.chain.snapshot_sync.starting_sub_id = 160000' $HOME/infernet-container-starter/deploy/config.json
yq -i '.chain.snapshot_sync.batch_size = 800' $HOME/infernet-container-starter/deploy/config.json
yq -i '.chain.snapshot_sync.sync_period = 30' $HOME/infernet-container-starter/deploy/config.json

# Copy config
cp -f $HOME/infernet-container-starter/deploy/config.json $HOME/infernet-container-starter/projects/hello-world/container/config.json



