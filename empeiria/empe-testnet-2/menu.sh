#!/bin/bash
# Variables
PROJECT_NAME="Empeiria"
VERSION="v0.4.0"
CHAIN_ID="empe-testnet-2"
WORK_DIR=".empe-chain"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


### Menu - Install Node
node_install() {
  print_header "Installing $PROJECT_NAME node..."

  # Check variables
  if [ ! $MONIKER ]; then
      print_header "Setting $PROJECT_NAME node moniker..."
      read -p "Enter node moniker: " MONIKER
      echo "" && sleep 1
      echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
  fi
  
  if [ ! $CHAIN_ID ]; then
      echo "export CHAIN_ID=$CHAIN_ID" >> ~/.bash_profile
  fi
  
  if [ ! $WALLET_NAME ]; then
      echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
  fi

  echo "export PATH=$PATH:~/$WORK_DIR" >> ~/.bash_profile
    
  # Set variables
  source $HOME/.bash_profile
  
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install -y libssl-dev ca-certificates

  # Install go
  cd $HOME
  source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/server-go.sh') 1.22.3

  # Install wasm library
  curl -L https://github.com/CosmWasm/wasmvm/releases/download/v1.5.0/libwasmvm.x86_64.so > libwasmvm.x86_64.so
  sudo mv -f libwasmvm.x86_64.so /usr/lib/libwasmvm.x86_64.so

  # Install binary 
  cd $HOME 
  mkdir $WORK_DIR
  cd $HOME/$WORK_DIR
  curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/${VERSION}/emped_${VERSION}_linux_amd64.tar.gz
  tar -xvf emped_${VERSION}_linux_amd64.tar.gz
  chmod +x $HOME/$WORK_DIR/emped
  rm -f emped_${VERSION}_linux_amd64.tar.gz
  emped version

  # Config node
  cd $HOME
  emped config chain-id $CHAIN_ID
  emped config keyring-backend test
  
  # Init node
  emped init $MONIKER --chain-id $CHAIN_ID

  # Get genesis
  wget -O $HOME/.empe-chain/config/genesis.json https://server-5.itrocket.net/testnet/empeiria/genesis.json
 
  # Get addrbook
  wget -O $HOME/.empe-chain/config/addrbook.json https://server-5.itrocket.net/testnet/empeiria/addrbook.json
  
  # Set peers, seeds
  SEEDS="20ca5fc4882e6f975ad02d106da8af9c4a5ac6de@empeiria-testnet-seed.itrocket.net:28656"
  PEERS="03aa072f917ed1b79a14ea2cc660bc3bac787e82@empeiria-testnet-peer.itrocket.net:28656,e058f20874c7ddf7d8dc8a6200ff6c7ee66098ba@65.109.93.124:29056,4c055c7272b26141c26c82334d07cc65558e79aa@134.255.182.245:14656,78f766310a83b6670023169b93f01d140566db79@65.109.83.40:29056,0f87465704e95ea92f6906f47a99a5d91aff0e1c@195.201.86.60:43656,e62b549646fee135cf010bc10641f728aba7fbd0@65.108.234.158:26626,2db322b41d26559476f929fda51bce06c3db8ba4@65.109.24.155:11256,080d9cc12e08fb64dd0f4528d0da4a84d5d9428e@37.27.83.234:26656,810e21adee3b8f337bab0df70ba75d38afde2348@152.53.0.11:29656,5fc98f2ec4b2a6001aa5655c9852d259e83a8e74@65.108.226.44:11256,45bdc8628385d34afc271206ac629b07675cd614@65.21.202.124:25656"
  sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
         -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.empe-chain/config/config.toml

  # Set pruning
  pruning="custom"
  pruning_keep_recent="100"
  pruning_interval="19"
  sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.empe-chain/config/app.toml
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.empe-chain/config/app.toml
  sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.empe-chain/config/app.toml

  # Set minimum gas
  minimum_gas="0.0001uempe"
  sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas\"/" $HOME/.empe-chain/config/app.toml
  
  # Disable indexing
  indexer="null"
  sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.empe-chain/config/config.toml
  
  # Enable prometheus
  sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.empe-chain/config/config.toml

  # Create service file
  print_header "Setting $PROJECT_NAME node service..."

sudo tee /etc/systemd/system/emped.service > /dev/null <<EOF
[Unit]
Description=Empeiria node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.empe-chain
ExecStart=$(which emped) start --home $HOME/.empe-chain
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
   
  sudo systemctl daemon-reload
  sudo systemctl enable emped
  sudo systemctl restart emped
}


### Menu - Create Wallet
wallet_create() {
  print_header "Create $PROJECT_NAME node wallet..."
  emped keys add $WALLET_NAME
}

### Menu - Download Snapshot
download_snapshot() {
  print_header "Downloading $PROJECT_NAME node snapshot..."
  source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/empeiria/empe-testnet-2/snapshot.sh')
}



### Menu - Create Validator
validator_create() {
  print_header "Create $PROJECT_NAME node validator..."
  emped tx staking create-validator \
  --amount 1000000uempe \
  --from $WALLET_NAME \
  --commission-rate 0.1 \
  --commission-max-rate 0.2 \
  --commission-max-change-rate 0.01 \
  --min-self-delegation 1 \
  --pubkey $(emped tendermint show-validator) \
  --moniker "$MONIKER" \
  --identity "" \
  --details "" \
  --chain-id "$CHAIN_ID" \
  --gas auto --gas-adjustment 1.5 --fees 30uempe \
  -y
}


### Menu - Recovery Wallet
wallet_create() {
  print_header "Recovery $PROJECT_NAME node wallet..."
  emped keys add $WALLET_NAME --recover
}


### Menu - Start Node
node_start() {
  print_header "Starting $PROJECT_NAME node..."
  sudo systemctl start emped
}


### Menu - Update Node
node_update() {
  node_stop

  node_restart
}


### Menu - Restart Node
node_restart() {
  print_header "Restarting $PROJECT_NAME node..."
  sudo systemctl restart emped
}


### Menu - Stop Node
node_stop() {
  print_header "Stopping $PROJECT_NAME node..."
  sudo systemctl stop emped
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
  echo "2. Create Wallet"
  echo "3. Download Snapshot"
  echo "4. Create Validator"
  echo "5. Recovery Wallet"
  echo "x. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) node_install ;;
    2) wallet_create ;;
    3) download_snapshot ;;
    4) validator_create ;;
    5) wallet_recovery ;;
    x) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
