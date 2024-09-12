#!/bin/bash
cd $HOME

#Install Docker
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install docker to server... \e[0m" && sleep 1
echo ''
curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh
