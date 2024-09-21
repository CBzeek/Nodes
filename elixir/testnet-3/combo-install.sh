#!/bin/bash
PROJECT_NAME="Elixir"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install docker... \e[0m" && sleep 1
echo ''
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/elixir/testnet-3/install.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Show $PROJECT_NAME node logs... \e[0m" && sleep 1
echo ""
docker logs -f elixir
