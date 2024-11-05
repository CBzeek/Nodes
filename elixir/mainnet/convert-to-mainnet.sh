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
docker pull elixirprotocol/validator --platform linux/amd64


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Change $PROJECT_NAME node configuration files... \e[0m" && sleep 1
echo ""
sed -i 's/ENV=testnet-3/ENV=prod/' $HOME/.elixir/validator.env


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Start $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker run -d \
  --env-file $HOME/.elixir/validator.env \
  --platform linux/amd64 \
  --name elixir \
  -p 17690:17690 \
  elixirprotocol/validator

  
