#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="Empeiria"


sudo systemctl stop emped
cp $HOME/.empe-chain/data/priv_validator_state.json $HOME/.empe-chain/priv_validator_state.json.backup
rm -rf $HOME/.empe-chain/data $HOME/.empe-chain/wasm
curl https://server-5.itrocket.net/testnet/empeiria/empeiria_2025-06-28_5567891_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empe-chain
mv $HOME/.empe-chain/priv_validator_state.json.backup $HOME/.empe-chain/data/priv_validator_state.json
sudo systemctl restart emped
