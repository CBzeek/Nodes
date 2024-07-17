#!/bin/bash
PROJECT_NAME="Farcaster"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Change $PROJECT_NAME node RPC... \e[0m" && sleep 1
echo ""
read -p "Enter RPC for Ethereum Mainnet: " RPC_ETH
read -p "Enter RPC for Optimism Mainnet: " RPC_OPT

echo $RPC_ETH
echo $RPC_OPT

sed -i.bak -e "s|ETH_MAINNET_RPC_URL=.*|ETH_MAINNET_RPC_URL=$RPC_ETH|" $HOME/hubble/env
sed -i.bak -e "s|OPTIMISM_L2_RPC_URL=.*|OPTIMISM_L2_RPC_URL=$RPC_ETH|" $HOME/hubble/env
