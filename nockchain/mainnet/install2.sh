#!/bin/bash
# Variables
PROJECT_NAME="Nockchain"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

### Menu - Install Node
node_install() {

  # Install dependencies
  print_header "Installing dependencies..."
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 -y
  sudo apt install pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev llvm-dev libclang-dev -y

  # Rust
  print_header "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env

  # Docker
  # source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')


  # Install Nockchain
  print_header "Installing $PROJECT_NAME node..."

  # Clone github repo  
  git clone https://github.com/zorp-corp/nockchain
  cd $HOME/nockchain

  # Copy the example environment file and rename it to .env:
  cp .env_example .env

  # Install hoonc, the Hoon compiler:
  make install-hoonc

  # To build the Nockchain
  make build

  ## Install wallet
  make install-nockchain-wallet

  ## Install Nockchain
  make install-nockchain

  ## Open ports: 3005, 3006
#  sudo ufw allow 3005/tcp
#  sudo ufw allow 3006/tcp

  ## Update path
  echo 'export PATH="$PATH:$HOME/nockchain/target/release"' >> ~/.bashrc
  source ~/.bashrc
}


### Menu - Walet Keygen
node_wallet_keygen() {
  print_header "$PROJECT_NAME wallet keygen..."
  cd $HOME/nockchain && nockchain-wallet keygen
}


### Menu - Update Pubkey
node_update_pubkey() {
  print_header "Updating $PROJECT_NAME update Public key..."
  read -p "Enter you public key: " PUBKEY
  cd $HOME/nockchain
  sed -i "s|^MINING_PUBKEY=.*$|MINING_PUBKEY=$PUBKEY|" .env

  print_header "Public key succesfully updated..."
  cat .env | grep MINING_PUBKEY
}


### Menu - Update Pubkey
node_display_pubkey() {
  print_header "Your $PROJECT_NAME Public key..."
  cat $HOME/nockchain/.env | grep MINING_PUBKEY
}


### Menu - Backup Keys
node_backup_keys() {
  print_header "Backup $PROJECT_NAME Keys..."
  cd $HOME/nockchain
  nockchain-wallet export-keys
  print_header "Succesfully backup Keys..."
}


### Menu - Import Keys
node_import_keys() {
  print_header "Importing $PROJECT_NAME Keys..."
  cd $HOME/nockchain
  nockchain-wallet import-keys --input keys.export
  print_header "Succesfully import Keys..."
}


### Menu - Node start
node_start() {
  print_header "$PROJECT_NAME node start..."
  cd $HOME/nockchain && make run-nockchain
}


### Menu - Node Update
node_update() {
  print_header "$PROJECT_NAME node update..."

  # backup wallet
  node_backup_keys

  # make temp dir
  mkdir $HOME/temp-nockchain
  
  # move files
  mv -f $HOME/nockchain/.env $HOME/temp-nockchain/.env
  mv -f $HOME/nockchain/keys.store $HOME/temp-nockchain/keys.store
  
  # remove dirs
  rm -f $HOME/nockchain
  rm -f $HOME/.nockapp
  
  # install
  #node_install
  print_header "$PROJECT_NAME NODE INSTALL!!!"
  git clone https://github.com/zorp-corp/nockchain
  cd $HOME/nockchain
  
  # move files
  mv -f $HOME/temp-nockchain/.env $HOME/nockchain/.env
  mv -f $HOME/temp-nockchain/keys.store $HOME/nockchain/keys.store
  
  # erase temp dir
  rm -f $HOME/temp-nockchain
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
  echo "2. Generate New Wallet"
  echo "3. Update Public Key"
  echo "4. Display Public Key"
  echo "5. Backup Wallet"
  echo "6. Import Wallet"
  echo "7. Start Node"
  echo "8. Start Update"
  echo "x. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) node_install ;;
    2) node_wallet_keygen ;;
    3) node_update_pubkey ;;
    4) node_display_pubkey ;;
    5) node_backup_keys ;;
    6) node_import_keys ;;
    7) node_start ;;
    8) node_update ;;
    x) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
