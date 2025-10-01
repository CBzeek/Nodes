#!/bin/bash
# Variables
PROJECT_NAME="Aztec"
# VERSION="v0.4.0"
# CHAIN_ID="empe-testnet-2"
WORK_DIR=".aztec"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


### Menu - Install Node
node_install() {
  print_header "Installing $PROJECT_NAME node..."

  # Check variables
  echo "export PATH=$PATH:~/$WORK_DIR" >> ~/.bash_profile
    
  # Set variables
  source $HOME/.bash_profile
  
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install -y ncdu cmake clang pkg-config libssl-dev libzmq3-dev libczmq-dev python3-pip protobuf-compiler dos2unix 

  # Install docker
  cd $HOME
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')

  # Install node
  cd $HOME 
  bash -i <(curl -s https://install.aztec.network)

}


### Menu - Node Config
node_config() {
  print_header "Configuring $PROJECT_NAME node..."

  # Firewall
  ufw allow 22
  ufw allow ssh
  ufw enable
  
  # Sequencer
  ufw allow 40400
  ufw allow 8080

  echo ""
  echo ""

  # Get RPC
  read -p "Enter RPC url: " RPC
  
  # Get Beacon RPC
  read -p "Enter Beacon RPC url: " RPC_BEACON

  # Get Private Key
  read -p "Enter Private Key: " PRIV_KEY

  # Get Wallet Address
  read -p "Enter Wallet Address: " ADDRESS

  # Get IP
  NODE_IP=$(curl -s ipv4.icanhazip.com)
  
  # Create node start file
sudo tee $HOME/$WORK_DIR/aztec_run.sh > /dev/null <<EOF
#!/bin/bash

ETHEREUM_HOSTS="${RPC}"
L1_CONSENSUS_HOST_URLS="${RPC_BEACON}"
VALIDATOR_PRIVATE_KEYS="${PRIV_KEY}"
COINBASE="${ADDRESS}"
P2P_IP="${NODE_IP}"

$HOME/.aztec/bin/aztec start --node --archiver --sequencer --network testnet --l1-rpc-urls \${ETHEREUM_HOSTS} --l1-consensus-host-urls \${L1_CONSENSUS_HOST_URLS} --sequencer.validatorPrivateKeys \${VALIDATOR_PRIVATE_KEYS} --sequencer.coinbase \${COINBASE} --p2p.p2pIp \${P2P_IP} --p2p.maxTxPoolSize 1000000000
EOF

  chmod +x $HOME/$WORK_DIR/aztec_run.sh

  # Create service file
  print_header "Setting $PROJECT_NAME node service..."

sudo tee /etc/systemd/system/aztecd.service > /dev/null <<EOF
[Unit]
Description=Aztec node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.aztec
ExecStart=$HOME/.aztec/aztec_run.sh
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
   
  sudo systemctl daemon-reload
  sudo systemctl enable aztecd
  sudo systemctl restart aztecd
}


### Menu - Start Node
node_start() {
  print_header "Starting $PROJECT_NAME node..."
  sudo systemctl start aztecd
}


### Menu - Update Node
node_update() {
  node_stop

  node_restart
}


### Menu - Node Logs
node_logs() {
  print_header "Starting $PROJECT_NAME node logs..."
  sudo journalctl -u aztecd -fo cat --no-hostname
}


### Menu - Restart Node
node_restart() {
  print_header "Restarting $PROJECT_NAME node..."
  sudo systemctl restart aztecd
}


### Menu - Stop Node
node_stop() {
  print_header "Stopping $PROJECT_NAME node..."
  sudo systemctl stop aztecd
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
  echo "2. Configure Node"
  echo "3. Logs"
  echo "4. Restart Node"
  echo "x. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) node_install ;;
    2) node_config ;;
    3) node_logs ;;
    4) node_restart ;;
    x) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
