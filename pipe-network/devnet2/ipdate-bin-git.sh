#!/bin/bash
# Variables
PROJECT_NAME="Pipe Network"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


# Stop node
print_header "Stopping $PROJECT_NAME node..."
sudo systemctl stop popd

# Update bin
print_header "Updating $PROJECT_NAME node..."
cd $HOME/.pipe
wget -O pop https://github.com/CBzeek/Nodes/raw/refs/heads/main/pipe-network/devnet2/pop
chmod +x pop

# Restart node
print_header "Restarting $PROJECT_NAME node..."
sudo systemctl restart popd

