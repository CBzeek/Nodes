#!/bin/bash
# Variables
PROJECT_NAME="Aztec"
WORK_DIR=".aztec"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

print_header "Update $PROJECT_NAME node..."

# Home directory
cd $HOME

# Stop node service
sudo systemctl stop aztecd

# Remove old bin
rm -rf $HOME/.aztec/bin

# Install node
bash -i <(curl -s https://install.aztec.network)

# Start node service
sudo systemctl start aztecd
