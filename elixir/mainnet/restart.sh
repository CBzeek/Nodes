#!/bin/bash
PROJECT_NAME="Elixir"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
docker kill elixir-mainnet
docker rm elixir-mainnet

docker run -d \
  --env-file $HOME/.elixir/validator-mainnet.env \
  --platform linux/amd64 \
  --name elixir-mainnet \
  --restart unless-stopped \
  -p 27690:17690 \
  elixirprotocol/validator
