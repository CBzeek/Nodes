#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

cd $HOME

#Ubuntu update and upgrade
print_header "Updating and Upgrading server..."
sudo apt update && sudo apt upgrade -y


#Install software
print_header "Installing dependencies to server..."
sudo apt install curl mc git jq screen lz4 build-essential htop zip unzip wget rsync ufw snapd -y
sudo snap install yq
