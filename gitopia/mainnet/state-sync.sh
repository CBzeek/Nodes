#!/bin/bash
PROJECT_NAME="Gitopia"


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### $PROJECT_NAME state sync configuration... \e[0m" && sleep 1
echo ''

sudo systemctl stop gitopiad

cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book

SNAP_RPC="https://gitopia.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i \
  -e 's|^enable *=.*|enable = true|' \
  -e 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' \
  -e 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' \
  -e 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' \
  $HOME/.gitopia/config/app.toml

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl restart gitopiad
