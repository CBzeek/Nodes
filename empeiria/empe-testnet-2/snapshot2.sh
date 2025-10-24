#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="Empeiria"


# Stop node
print_header "Stopping $PROJECT_NAME node..."
sudo systemctl stop emped


# Download snapshot
print_header "Downloading $PROJECT_NAME node snapshot..."

cd $HOME
rm -rf $HOME/.empe-chain/data/application.db
cp $HOME/.empe-chain/data/priv_validator_state.json $HOME/.empe-chain/priv_validator_state.json.backup
emped tendermint unsafe-reset-all --home $HOME/.empe-chain --keep-addr-book
LATEST_SNAPSHOT=$(curl -s  https://server-1.itrocket.net/testnet/empeiria/ | grep -oE 'empeiria_[0-9-]+_([0-9]+)_snap\.tar\.lz4' | sort -t'_' -k3 -n | tail -1)
curl -S https://server-1.itrocket.net/testnet/empeiria/$LATEST_SNAPSHOT | lz4 -dc - | tar -xf - -C $HOME/.empe-chain
mv $HOME/.empe-chain/priv_validator_state.json.backup $HOME/.empe-chain/data/priv_validator_state.json
rm -f ./$LATEST_SNAPSHOT


# Restart node
print_header "Restarting $PROJECT_NAME node..."
sudo systemctl restart emped
