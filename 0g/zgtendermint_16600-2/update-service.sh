#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="0G"



echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Stop $PROJECT_NAME node service..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
# Stop 0g service
sudo systemctl stop ogd
rm -f /etc/systemd/system/ogd.service



echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Create $PROJECT_NAME node service..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
#service file
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=OG Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=$(which 0gchaind) start --home $HOME/.0gchain
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF



echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Starting $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
#restart service and start node
sudo systemctl daemon-reload
sudo systemctl enable ogd
sudo systemctl start ogd
