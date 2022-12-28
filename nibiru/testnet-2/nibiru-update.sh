#!/bin/bash
cd $HOME

PROJECT_NAME="nibid"

VERSION=$(curl https://api.github.com/repos/NibiruChain/nibiru/releases/latest 2>null | jq -r '.name')


echo ''
echo -e "\e[1m\e[32m### Stopping ${PROJECT_NAME} service... \e[0m" && sleep 1
echo ''
systemctl stop ${PROJECT_NAME}


echo ''
echo -e "\e[1m\e[32m### Installing ${PROJECT_NAME} version ${VERSION}... \e[0m" && sleep 1
echo ''
rm -rf $HOME/nibiru
cd $HOME
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout ${VERSION}
make build
sudo mv ./build/nibid /usr/local/bin/


echo ''
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl restart nibid
