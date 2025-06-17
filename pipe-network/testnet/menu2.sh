#!/bin/bash
# Variables
PROJECT_NAME="Pipe Network"
VERSION="v0.3.2"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


### Menu - Install Node - Part 1
install_node_1() {
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install -y libssl-dev ca-certificates

  print_header "Installing $PROJECT_NAME node..."

# Network perfomance
sudo bash -c 'cat > /etc/sysctl.d/99-pipe.conf << EOL
net.ipv4.ip_local_port_range = 1024 65535
net.core.somaxconn = 65535
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
EOL'
  
  # Apply settings
  sudo sysctl -p /etc/sysctl.d/99-pipe.conf

  # Allow HTTP and HTTPS traffic
  sudo ufw allow 22
  sudo ufw allow 443/tcp
  sudo ufw allow 80/tcp
  sudo ufw enable
  
  sudo ufw status


  # create dir
  mkdir -p $HOME/.pipe
  mkdir -p $HOME/.pipe/logs

}  


### Menu - Install Node - Part 2
install_node_2() {

  # Unpack binary
  cd $HOME/.pipe
  tar -xzvf pop-v0.3.2-linux-x64.tar.gz
  rm pop-v0.3.2-linux-x64.tar.gz

  # Create config file
  ./pop create-config

# Create service file
sudo tee /etc/systemd/system/popd.service > /dev/null << EOF
[Unit]
Description=Pipe Network Node Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/.pipe
ExecStart=$HOME/.pipe/pop
Restart=always
RestartSec=5
LimitNOFILE=65535
StandardOutput=journal
StandardError=journal
SyslogIdentifier=pop-node
Environment=POP_CONFIG_PATH=$HOME/.pipe/config.json

[Install]
WantedBy=multi-user.target
EOF
 
  sudo systemctl daemon-reload
  sudo systemctl enable popd
}


### Menu - Start Node
node_start() {
  print_header "Starting $PROJECT_NAME node..."
  sudo systemctl start popd
}


### Menu - Node logs
node_logs() {
  print_header "$PROJECT_NAME node logs..."
  sudo journalctl -u popd -f --no-hostname -n 1000
}


### Menu - Node state
node_state() {
  print_header "$PROJECT_NAME node state..."
  curl -s http://localhost/state | jq
}


### Menu - Node metrics
node_metrics() {
  print_header "$PROJECT_NAME node metrics..."
  curl -s http://localhost/state | jq
}


### Menu - Node health
node_health() {
  print_header "$PROJECT_NAME node health..."
  curl -s http://localhost/health | jq
}


### Menu - Update Node
node_update() {
  node_stop

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



################
### Main #######
################
while true; do
  echo ""
  echo -e "${B_GREEN}###############################"
  echo -e "### ${B_YELLOW}$PROJECT_NAME Node Menu: ${B_GREEN}###"
  echo -e "${B_GREEN}###############################${NO_COLOR}"
  echo "1. Install Node - Part 1"
  echo "2. Install Node - Part 2"
  echo "3. Start Node"
  echo "4. Check Node logs"
  echo "5. Check Node state"
  echo "6. Check Node metrics"
  echo "7. Check Node health"
  echo "8. Restart Node"  
  echo "9. Stop Node"
  echo "x. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node_1 ;;
    2) install_node_2 ;;
    3) node_start ;;
    4) node_logs ;;
    5) node_state ;;
    6) node_metrics ;;
    7) node_health ;;
    8) node_restart ;;
    9) node_stop ;;

    x) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
