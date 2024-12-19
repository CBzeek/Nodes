#!/bin/bash
PROJECT_NAME="Ritual"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing Foundry node... \e[0m" && sleep 1
echo ""
## Install Foundry
cd
mkdir foundry
cd foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup


# Install the necessary dependencies  
cd ~/infernet-container-starter/projects/hello-world/contracts
rm -rf lib/forge-std
rm -rf lib/infernet-sdk
forge install --no-commit foundry-rs/forge-std
forge install --no-commit ritual-net/infernet-sdk
cd ../../../

