#!/bin/bash
PROJECT_NAME="Nubit"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Showing $PROJECT_NAME node pubkey... \e[0m" && sleep 1
echo ""
echo "** PUBKEY **"
$HOME/nubit-node/bin/nkey list --keyring-dir $HOME/.nubit-light-nubit-alphatestnet-1/keys/ --output json | jq -r '.[].pubkey' | jq -r '.key'
echo ""
