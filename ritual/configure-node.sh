#!/bin/bash
PROJECT_NAME="Ritual"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Configure $PROJECT_NAME node setings... \e[0m" && sleep 1
echo ""

read -p "Enter your Private Key (example: 0x123....123): " PRIVATE_KEY

# Backup config
cp $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/projects/hello-world/container/config.json.bak
cp $HOME/infernet-container-starter/deploy/docker-compose.yaml $HOME/infernet-container-starter/deploy/docker-compose.yaml.bak
cp $HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol $HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol.bak
cp $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile.bak

# RPC
yq -i '.chain.rpc_url = "https://mainnet.base.org/"' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Private Key
PRIV=$PRIVATE_KEY yq -i '.chain.wallet.private_key = strenv(PRIV)' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Registry address
yq -i '.chain.registry_address = "0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Trail head blocks
yq -i '.chain.trail_head_blocks = 3' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Snapshot settings
yq -i '.chain.snapshot_sync.sleep = 3' $HOME/infernet-container-starter/projects/hello-world/container/config.json
yq -i '.chain.snapshot_sync.starting_sub_id = 160000' $HOME/infernet-container-starter/projects/hello-world/container/config.json
#yq -i '.chain.snapshot_sync.batch_size = 800' $HOME/infernet-container-starter/projects/hello-world/container/config.json
yq -i '.chain.snapshot_sync.batch_size = 50' $HOME/infernet-container-starter/projects/hello-world/container/config.json
yq -i '.chain.snapshot_sync.sync_period = 30' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Remove docker section
yq -i 'del(.docker)' $HOME/infernet-container-starter/projects/hello-world/container/config.json

# Copy config
cp -f $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/deploy

# Infernet node image version
yq -i '.services.node.image = "ritualnetwork/infernet-node:1.4.0"' $HOME/infernet-container-starter/deploy/docker-compose.yaml
yq -i '.services.infernet-anvil.command = "--host 0.0.0.0 --port 3000 --load-state infernet_deployed.json -b 1 --prune-history"' docker-compose.yaml

# Deploy.s.sol
sed -i "s/address registry *=.*/address registry = 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170;/" $HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol

# Makefile
sed -i "s/sender *:=.*/sender := ${PRIVATE_KEY}/" $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile
sed -i "s/RPC_URL *:=.*/RPC_URL := https:\/\/mainnet.base.org/" $HOME/infernet-container-starter/projects/hello-world/contracts/Makefile

