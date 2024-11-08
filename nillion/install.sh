#!/bin/bash
PROJECT_NAME="Nillion"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install dependencies... \e[0m" && sleep 1
echo ""
sudo apt update
sudo apt install curl git jq mc screen lz4 htop -y


source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')

docker --version

docker container run --rm hello-world


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Download $PROJECT_NAME node docker image... \e[0m" && sleep 1
echo ""
docker pull nillion/verifier:v1.0.1


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Initialise $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
mkdir -p nillion/verifier
docker run -v $HOME/nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise

