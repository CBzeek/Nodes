#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

cd $HOME

#Install Software
print_header "Install dependencies..."
sudo apt update


#Install Redis
print_header "Install Redis to server..."
sudo apt install redis-server -y
