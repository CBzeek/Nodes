#!/bin/bash
# Variables
PROJECT_NAME="Pipe Network"
VERSION="v0.2.8"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

### Menu - Install Node
install_node() {
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  # sudo apt install iptables make gcc automake autoconf nvme-cli libssl-dev libleveldb-dev tar clang bsdmainutils ncdu openssl -y
  sudo apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev tar clang bsdmainutils ncdu unzip libleveldb-dev lz4 screen bc fail2ban -y
  
  print_header "Installing $PROJECT_NAME node..."

  # create folder to be used for download cache
  mkdir -p $HOME/.pipe/download_cache
  cd $HOME/.pipe

  # download the compiled pop binary
  wget -O pop "https://dl.pipecdn.app/$VERSION/pop"
  #curl -L -o pop "https://dl.pipecdn.app/v0.2.5/pop"
  
  # assign executable permission to pop binary
  chmod +x pop

  echo ""
  read -p "Enter your public Solana address: " SOLANA_ADDRESS

  read -p "Enter the amount of RAM, in GB: " RAM

  read -p "Enter the amount of max-disk, in GB: " DISK

# Create systemd service file
sudo tee /etc/systemd/system/popd.service > /dev/null << EOF
[Unit]
Description=Pipe Network Node Service
After=network.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=$HOME/.pipe/pop \
    --ram $RAM \
    --pubKey $SOLANA_ADDRESS \
    --max-disk $DISK \
    --cache-dir $HOME/.pipe/download_cache \
    --no-prompt
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=pop-node
WorkingDirectory=$HOME/.pipe

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl enable popd
  sudo systemctl start popd

}


### Menu - Node logs
node_logs() {
  print_header "$PROJECT_NAME node logs..."
  sudo journalctl -u popd -f -o cat
}

### Menu - Node status
node_status() {
  print_header "$PROJECT_NAME node status..."
  cd $HOME/.pipe && ./pop --status
}

### Menu - Node points
node_points() {
  print_header "$PROJECT_NAME node points..."
  cd $HOME/.pipe && ./pop --points
}

### Menu - Node generate referral code
node_generate_referral() {
  print_header "$PROJECT_NAME node generate referral code..."
  cd $HOME/.pipe && ./pop --gen-referral-route
}

### Menu - Node singup by referral code
node_singup_by_referral() {
  print_header "$PROJECT_NAME node generate referral code..."
  echo ""
  read -p "Enter referral code: " REF_CODE
  cd $HOME/.pipe && ./pop --signup-by-referral-route $REF_CODE
}


### Menu - Update Node
node_update() {
  print_header "Restarting $PROJECT_NAME node..."
  node_stop

  cd $HOME/.pipe
  wget -O pop "https://dl.pipecdn.app/$VERSION/pop"
  chmod +x pop

  node_restart
}


### Menu - Restart Node
node_restart() {
  print_header "Restarting $PROJECT_NAME node..."
  sudo systemctl restart popd
}

### Menu - Stop Node
node_stop() {
  print_header "Stopping $PROJECT_NAME node..."
  sudo systemctl stop popd
}

### Menu - Delete Node
node_delete() {
  print_header "Deleting $PROJECT_NAME node..."
  sudo systemctl disable popd.service
  sudo systemctl stop popd.service
  cd $HOME
  sudo rm -rf $HOME/.pipe
}


################
### Main #######
################
while true; do
  echo ""
  echo -e "${B_GREEN}###############################"
  echo -e "### ${B_YELLOW}$PROJECT_NAME Node Menu: ${B_GREEN}###"
  echo -e "${B_GREEN}###############################${NO_COLOR}"
  echo "1. Install Node"
  echo "2. Check Node logs"
  echo "3. Check Node status"
  echo "4. Check Node point"
  echo "5. Genegate referral code"
  echo "6. Singup by referral code"
  echo "7. Update Node"  
  echo "8. Restart Node"  
  echo "9. Stop Node"
  echo "0. Delete Node"
  echo "e. Exit"
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node ;;
    2) node_logs ;;
    3) node_status ;;
    4) node_points ;;
    5) node_generate_referral ;;
    6) node_singup_by_referral ;; 
    7) node_update ;;
    8) node_restart ;;
    9) node_stop ;;
    0) node_delete ;;
    e) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
