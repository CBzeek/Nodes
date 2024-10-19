#!/bin/bash
PROJECT_NAME="Ritual"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Clone Ritual's repository
git clone https://github.com/ritual-net/infernet-container-starter
cd infernet-container-starter

# Deploy container
#project=hello-world make deploy-container


# Detach
#project=hello-world make deploy-container
