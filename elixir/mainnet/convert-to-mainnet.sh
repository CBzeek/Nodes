#!/bin/bash
PROJECT_NAME="Elixir"

source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/elixir/mainnet/backup.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Get $PROJECT_NAME node docker image... \e[0m" && sleep 1
echo ""
docker pull elixirprotocol/validator --platform linux/amd64


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Change $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ""
cp $HOME/.elixir/validator.env $HOME/.elixir/validator-mainnet.env
sed -i 's/ENV=testnet-3/ENV=prod/' $HOME/.elixir/validator-mainnet.env


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Start $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker run -d \
  --env-file $HOME/.elixir/validator-mainnet.env \
  --platform linux/amd64 \
  --name elixir-mainnet \
  -p 27690:17690 \
  elixirprotocol/validator

  
