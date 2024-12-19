#!/bin/bash
PROJECT_NAME="Elixir"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker kill elixir
docker rm elixir

source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/elixir/testnet-3/run.sh')
