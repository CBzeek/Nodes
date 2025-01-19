#!/bin/bash
# Variables
PROJECT_NAME="OpenLedger"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


# Install denepdencies
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
sudo apt install ubuntu-desktop xrdp docker.io -y
sudo systemctl start gdm
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp
sudo systemctl start docker
sudo systemctl enable docker


echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Installing $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
# Install binary 
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb

echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Starting $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
# Start node
openledger-node --no-sandbox 
