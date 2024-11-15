#!/bin/bash
PROJECT_NAME="Elixir"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
docker kill elixir-mainnet
docker rm elixir-mainnet

source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/elixir/mainnet/run.sh')
