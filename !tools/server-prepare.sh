#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

print_header() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### ${B_YELLOW}$1"
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
}

cd $HOME

#Ubuntu update and upgrade
print_header "Updating and Upgrading server..."
sudo apt update && sudo apt upgrade -y


#Install software
print_header "Installing dependencies to server..."
sudo apt install curl mc git jq screen lz4 build-essential htop zip unzip wget rsync snapd -y
sudo snap install yq
