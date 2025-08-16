#!/bin/bash
# Variables
PROJECT_NAME="0G"
VERSION="v2.0.2"
#CHAIN_ID=""
WORK_DIR=".0gchaind"

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
  
  # if [ ! $CHAIN_ID ]; then
  #     echo 'export CHAIN_ID='\"${CHAIN_ID}\" >> ~/.bash_profile
  # fi
  
  if [ ! $WALLET_NAME ]; then
      echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
  fi

  echo "export PATH=$PATH:~/$WORK_DIR" >> ~/.bash_profile
    
  # Set variables
  source $HOME/.bash_profile

  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install -y libssl-dev ca-certificates

  # Install go 1.22.0
  cd $HOME
  source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/server-go.sh') 1.22.0

  # Download and Extract Galileo
  cd $HOME
  rm -rf galileo
  wget https://github.com/0glabs/0gchain-NG/releases/download/${VERSION}/galileo-${VERSION}.tar.gz
  tar -xvzf galileo-${VERSION}.tar.gz
  mv $HOME/galileo-${VERSION} $HOME/galileo
  rm galileo-${VERSION}.tar.gz
  chmod +x $HOME/galileo/bin/geth
  chmod +x $HOME/galileo/bin/0gchaind
    
  # Move binaries to /usr/local/bin for global access
  sudo cp $HOME/galileo/bin/geth /usr/local/bin/geth
  sudo cp $HOME/galileo/bin/0gchaind /usr/local/bin/0gchaind
  
  # Initialize the Chain
  mkdir -p $HOME/$WORK_DIR
  cd $HOME/$WORK_DIR
  cp -r $HOME/galileo $HOME/$WORK_DIR/
  
  # Init GEth
  geth init --datadir $HOME/.0gchaind/galileo/0g-home/geth-home $HOME/.0gchaind/galileo/genesis.json

  # Init 0GChaind
  0gchaind init $MONIKER --home $HOME/$WORK_DIR/tmp

  # Copy config
  CONFIG="$HOME/$WORK_DIR/galileo/0g-home/0gchaind-home/config"
  
  cp $HOME/$WORK_DIR/tmp/data/priv_validator_state.json $HOME/$WORK_DIR/galileo/0g-home/0gchaind-home/data/
  cp $HOME/$WORK_DIR/tmp/config/node_key.json $HOME/$WORK_DIR/galileo/0g-home/0gchaind-home/config/
  cp $HOME/$WORK_DIR/tmp/config/priv_validator_key.json $HOME/$WORK_DIR/galileo/0g-home/0gchaind-home/config/

  # Set Node Moniker
  sed -i -e "s/^moniker *=.*/moniker = \"$MONIKER\"/" $CONFIG/config.toml

  # Disable Indexer
  sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $CONFIG/config.toml

  # Configure custom pruning
  sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $CONFIG/app.toml
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $CONFIG/app.toml
  sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $CONFIG/app.toml

  # JSON-RPC Host (Geth / EVM Layer of 0G)
  sed -i 's/HTTPHost = .*/HTTPHost = "127.0.0.1"/' $HOME/$WORK_DIR/galileo/geth-config.toml

  # Cosmos RPC (Tendermint Layer)
  sed -i "s|laddr = \"tcp://127.0.0.1:26657\"|laddr = \"tcp://127.0.0.1:26657\"|" $CONFIG/config.toml


  # Set peers, seeds
  # SEEDS="20ca5fc4882e6f975ad02d106da8af9c4a5ac6de@empeiria-testnet-seed.itrocket.net:28656"
  # PEERS="03aa072f917ed1b79a14ea2cc660bc3bac787e82@empeiria-testnet-peer.itrocket.net:28656,e058f20874c7ddf7d8dc8a6200ff6c7ee66098ba@65.109.93.124:29056,4c055c7272b26141c26c82334d07cc65558e79aa@134.255.182.245:14656,78f766310a83b6670023169b93f01d140566db79@65.109.83.40:29056,0f87465704e95ea92f6906f47a99a5d91aff0e1c@195.201.86.60:43656,e62b549646fee135cf010bc10641f728aba7fbd0@65.108.234.158:26626,2db322b41d26559476f929fda51bce06c3db8ba4@65.109.24.155:11256,080d9cc12e08fb64dd0f4528d0da4a84d5d9428e@37.27.83.234:26656,810e21adee3b8f337bab0df70ba75d38afde2348@152.53.0.11:29656,5fc98f2ec4b2a6001aa5655c9852d259e83a8e74@65.108.226.44:11256,45bdc8628385d34afc271206ac629b07675cd614@65.21.202.124:25656"
  # sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
  #        -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.empe-chain/config/config.toml

  # Create 0gchaind service file
  print_header "Setting $PROJECT_NAME node service..."

# Setup 0gchaind.service
sudo tee /etc/systemd/system/0gchaind.service > /dev/null <<EOF
[Unit]
Description=0gchaind Node Service
After=network-online.target

[Service]
User=$USER
Environment=CHAIN_SPEC=devnet
WorkingDirectory=$HOME/$WORK_DIR/galileo
ExecStart=/usr/local/bin/0gchaind start \
#   --rpc.laddr tcp://0.0.0.0:26657 \
    --chaincfg.chain-spec devnet \
    --chaincfg.restaking.enabled \
    --chaincfg.restaking.symbiotic-rpc-dial-url https://ethereum-holesky-rpc.publicnode.com \
    --chaincfg.restaking.symbiotic-get-logs-block-range 256 \
    --chaincfg.kzg.trusted-setup-path=$HOME/$WORK_DIR/galileo/kzg-trusted-setup.json \
    --chaincfg.engine.jwt-secret-path=$HOME/$WORK_DIR/galileo/jwt-secret.hex \
    --chaincfg.kzg.implementation=crate-crypto/go-kzg-4844 \
    --chaincfg.block-store-service.enabled \
    --chaincfg.node-api.enabled \
    --chaincfg.node-api.logging \
    --chaincfg.node-api.address 0.0.0.0:3500 \
#    --pruning=nothing \
#    --chaincfg.engine.rpc-dial-url=http://localhost:${OG_PORT}551 \
    --home $HOME/$WORK_DIR/galileo/0g-home/0gchaind-home \
    --p2p.seeds 85a9b9a1b7fa0969704db2bc37f7c100855a75d9@8.218.88.60:26656 \
    --p2p.external_address=$(curl -4 -s ifconfig.me):26656
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF


# Setup geth.service
sudo tee /etc/systemd/system/geth.service > /dev/null <<EOF
[Unit]
Description=0g Geth Node Service
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/$WORK_DIR/galileo
ExecStart=/usr/local/bin/geth \
  --config $HOME/$WORK_DIR/galileo/geth-config.toml \
#  --nat extip:$(curl -4 -s ifconfig.me) \
  --bootnodes enode://de7b86d8ac452b1413983049c20eafa2ea0851a3219c2cc12649b971c1677bd83fe24c5331e078471e52a94d95e8cde84cb9d866574fec957124e57ac6056699@8.218.88.60:30303 \
  --datadir $HOME/$WORK_DIR/galileo/0g-home/geth-home \
#  --http.port ${OG_PORT}545 \
#  --ws.port ${OG_PORT}546 \
#  --authrpc.port ${OG_PORT}551 \
#  --port ${OG_PORT}303 \
  --networkid 16601
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

  # 
  sudo systemctl daemon-reload
  sudo systemctl enable 0gchaind
  sudo systemctl enable geth
  sudo systemctl start 0gchaind
  sudo systemctl start geth
  
}


### Menu - Create Wallet
wallet_create() {
  print_header "Create $PROJECT_NAME node wallet..."
#  emped keys add $WALLET_NAME
}

### Menu - Download Snapshot
download_snapshot() {
#  source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/empeiria/empe-testnet-2/snapshot.sh')
}





### Menu - Create Validator
# validator_create() {
#   print_header "Create $PROJECT_NAME node validator..."
#   emped tx staking create-validator \
#   --amount 1000000uempe \
#   --from "$WALLET_NAME" \
#   --commission-rate 0.1 \
#   --commission-max-rate 0.2 \
#   --commission-max-change-rate 0.01 \
#   --min-self-delegation 1 \
#   --pubkey $(emped tendermint show-validator) \
#   --moniker "$MONIKER" \
#   --identity "" \
#   --details "" \
#   --chain-id "$CHAIN_ID" \
#   --gas auto --gas-adjustment 1.5 --fees 30uempe \
#   -y
}


### Menu - Recovery Wallet
wallet_recovery() {
  print_header "Recovery $PROJECT_NAME node wallet..."
  # emped keys add $WALLET_NAME --recover
}

### Menu - Backup Keys
node_backup_keys() {
  print_header "Backup $PROJECT_NAME node keys..."
  # source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/empeiria/empe-testnet-2/backup.sh')
}


### Menu - Start Node
node_start() {
  print_header "Starting $PROJECT_NAME node..."
  # sudo systemctl start emped
}


### Menu - Update Node
node_update() {
  node_stop

  node_restart
}


### Menu - Restart Node
node_restart() {
  print_header "Restarting $PROJECT_NAME node..."
  # sudo systemctl restart emped
}


### Menu - Stop Node
node_stop() {
  print_header "Stopping $PROJECT_NAME node..."
  # sudo systemctl stop emped
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
  # echo "2. Create Wallet"
  # echo "3. Download Snapshot"
  # echo "4. Create Validator"
  # echo "5. Recovery Wallet"
  # echo "6. Backup Keys"
  echo "x. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) node_install ;;
    # 2) wallet_create ;;
    # 3) download_snapshot ;;
    # 4) validator_create ;;
    # 5) wallet_recovery ;;
    # 6) node_backup_keys ;;
    x) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
