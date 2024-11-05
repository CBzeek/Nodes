#!/bin/bash
PROJECT_NAME="Elixir"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install dependencies... \e[0m" && sleep 1
echo ""
sudo apt update
sudo apt install curl git jq mc screen lz4 htop -y

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Set $PROJECT_NAME node params... \e[0m" && sleep 1
echo ""
read -p "Enter node moniker: " MONIKER
read -p "Enter ETH address to receive/claim rewards: " REWARDS_ADDRESS
read -p "Enter validator private key: " PRIVATE_KEY

rm -rf $HOME/.elixir
mkdir $HOME/.elixir && cd $HOME/.elixir

sudo tee $HOME/.elixir/validator-mainnet.env > /dev/null <<EOF
ENV=prod
STRATEGY_EXECUTOR_DISPLAY_NAME=$MONIKER
STRATEGY_EXECUTOR_BENEFICIARY=$REWARDS_ADDRESS
SIGNER_PRIVATE_KEY=$PRIVATE_KEY
EOF


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Download $PROJECT_NAME node docker image... \e[0m" && sleep 1
echo ""
docker pull elixirprotocol/validator --platform linux/amd64


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Start $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker run -d \
  --env-file $HOME/.elixir/validator.env \
  --platform linux/amd64 \
  --name elixir-mainnet \
  -p 17690:17690 \
  elixirprotocol/validator
