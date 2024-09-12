#!/bin/bash
cd $HOME

#Install Docker
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Ununstall Docker from server... \e[0m" && sleep 1
echo ''
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
