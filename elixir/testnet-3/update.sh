#!/bin/bash
PROJECT_NAME="Elixir"

source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/elixir/testnet-3/backup.sh')

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Delete $PROJECT_NAME node old docker image... \e[0m" && sleep 1
echo ""
docker kill elixir
docker rm elixir

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Get $PROJECT_NAME node docker image... \e[0m" && sleep 1
echo ""
docker pull elixirprotocol/validator:testnet --platform linux/amd64

source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/elixir/testnet-3/run.sh')
