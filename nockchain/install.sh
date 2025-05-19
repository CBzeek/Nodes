#!/bin/bash
# Variables
PROJECT_NAME="Nockchain"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

### Menu - Install Node
install_node() {
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev  -y

  # Rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env

  # Docker
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')

  print_header "Installing $PROJECT_NAME node..."

  # Install Nockchain
  # Clone github repo  
  git clone https://github.com/zorp-corp/nockchain
  cd $HOME/nockchain

  # Install hoonc, the Hoon compiler:
  make install-hoonc

  # To build the Nockchain
  make build

  ## Install wallet
  make install-nockchain-wallet

  ## Install Nockchain
  make install-nockchain

  echo 'export PATH="$PATH:$HOME/nockchain/target/release"' >> ~/.bashrc
  source ~/.bashrc
}


### Menu - Walet Keygen
node_wallet_keygen() {
  print_header "$PROJECT_NAME wallet keygen..."
  cd $HOME/nockchain && nockchain-wallet keygen
}

### Menu - Update Pubkey
node_update_pubkey {
  print_header "Updating $PROJECT_NAME update Public key..."
  read -p "Enter you public key: " PUBKEY
  cd $HOME/nockchain
  sed -i "s|^export MINING_PUBKEY :=.*$|export MINING_PUBKEY := $PUBKEY|" Makefile
}

### Menu - Leader node start
node_start_leader() {
  print_header "$PROJECT_NAME leader node start..."
  cd $HOME/nockchain && make run-nockchain-leader
}

### Menu - Follower node start
node_start_follower() {
  print_header "$PROJECT_NAME follower node start..."
  cd $HOME/nockchain && make run-nockchain-follower
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
  echo "2. Wallet Keygen"
  echo "3. Update Public Key"  
  echo "4. Start Leader Node"
  echo "5. Start Follower Node"
  echo "6. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node ;;
    2) node_wallet_keygen ;;
    3) node_update_pubkey ;;
    4) node_start_leader ;;
    5) node_start_follower ;;
    6) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
