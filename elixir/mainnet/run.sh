#!/bin/bash
PROJECT_NAME="Elixir"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Start $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker run -d \
  --env-file $HOME/.elixir/validator-mainnet.env \
  --platform linux/amd64 \
  --name elixir-mainnet \
  --restart unless-stopped \
  -p 27690:17690 \
  elixirprotocol/validator
