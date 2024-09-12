#!/bin/bash
PROJECT_NAME="Elixir"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
#update
#sudo apt update
#sudo apt install curl git jq build-essential lz4 unzip tar mc chrony htop ncdu nload screen -y 


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node params... \e[0m" && sleep 1
echo ""
read -p "Enter node moniker: " MONIKER
read -p "Enter ETH address to receive/claim rewards: " REWARDS_ADDRESS
read -p "Enter validator private key: " PRIVATE_KEY

rm -rf $HOME/.elixir
mkdir $HOME/.elixir && cd $HOME/.elixir

sudo tee $HOME/.elixir/validator.env > /dev/null <<EOF
ENV=testnet-3
STRATEGY_EXECUTOR_DISPLAY_NAME=$MONIKER
STRATEGY_EXECUTOR_BENEFICIARY=$REWARDS_ADDRESS
SIGNER_PRIVATE_KEY=$PRIVATE_KEY
EOF


