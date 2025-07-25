#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

cd $HOME

#Install Software
print_header "Install dependencies..."
sudo apt update
sudo apt install curl -y


#Install Docker
print_header "Install Docker to server..."
curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh
