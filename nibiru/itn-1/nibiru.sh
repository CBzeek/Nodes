#!/bin/bash
cd $HOME

PROJECT_NAME="nibid"

echo ''
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
source <(wget -O- https://api.nodes.guru/nibiru.sh)
source $HOME/.bash_profile

echo ''
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME wallet.. \e[0m" && sleep 1
echo ''
nibid keys add wallet
