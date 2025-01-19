#!/bin/bash
PROJECT_NAME="Ritual"


# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Configure $PROJECT_NAME node contract... \e[0m" && sleep 1
echo ""

read -p "Enter your Contract Address (example: 0x123....123): " CONTRACT

# Backup config
cp $HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol $HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol.bak

# CallContract.s.sol
sed -i "s/SaysGM saysGm *=.*/SaysGM saysGm = SaysGM(${CONTRACT});/" $HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol
