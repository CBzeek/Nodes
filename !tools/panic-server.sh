#!/bin/bash
cd $HOME

PROJECT_NAME="PANIC by Simply VC"

#Ubuntu update and upgrade
echo '#############################################################'
echo -e "\e[1m\e[32m### Updating and Upgrading server... \e[0m" && sleep 1
echo ''
sudo apt update && sudo apt upgrade -y

#Install software
echo '#############################################################'
echo -e "\e[1m\e[32m### Installing dependencies for $PROJECT_NAME... \e[0m" && sleep 1
echo ''
# Install Git
sudo apt install -y curl git

# Install docker and docker-compose
curl -sSL https://get.docker.com/ | sh
sudo apt install docker-compose -y

echo '#############################################################'
echo -e "\e[1m\e[32m### Installing dependencies for $PROJECT_NAME... \e[0m" && sleep 1
echo ''
# Clone the panic repository and navigate into it
git clone https://github.com/SimplyVC/panic
cd panic

# This will access the .env file on your terminal (to exit Ctrl + X - Y - Enter)
IP=$(wget -qO- eth0.me)
echo '#############################################################'
echo -e "\e[1m\e[32m### Configure IP ${IP} to UI_ACCESS_IP (to exit Ctrl + X - Y - Enter)... \e[0m" && sleep 10
echo ''
nano .env

echo '#############################################################'
echo -e "\e[1m\e[32m### Running $PROJECT_NAME... \e[0m" && sleep 1
echo ''
docker-compose up -d --build


