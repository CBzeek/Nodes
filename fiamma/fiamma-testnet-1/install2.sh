#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="Fiamma"
VERSION="v1.0.0"

# Check variables
if [ ! $MONIKER ]; then
    echo ""
    echo -e "${B_GREEN}"
    echo -e "###########################################################################################"
    echo -e "### Setting $PROJECT_NAME node moniker..."
    echo -e "${NO_COLOR}" && sleep 1
    echo -e "${B_YELLOW}"
    read -p "Enter node moniker: " MONIKER
    echo -e "${NO_COLOR}" && sleep 1
    echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
fi

if [ ! $CHAIN_ID ]; then
    echo 'export CHAIN_ID="fiamma-testnet-1"' >> ~/.bash_profile
fi

if [ ! $WALLET_NAME ]; then
    echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
fi

if [ ! $RPC_PORT ]; then
    echo 'export RPC_PORT="26657"' >> ~/.bash_profile
fi
source $HOME/.bash_profile


# Install denepdencies
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
sudo apt install make bash gcc pkg-config openssl libssl-dev -y


#install go
cd $HOME
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/server-go.sh') 1.23.3



echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Installing $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
# Install binary 
cd $HOME && rm -rf fiamma
git clone https://github.com/fiamma-chain/fiamma.git
cd fiamma
git checkout $VERSION
make install
fiammad version
source $HOME/.bash_profile

# Config node
cd $HOME
fiammad config chain-id $CHAIN_ID
fiammad config keyring-backend test

# Init node
fiammad init $MONIKER --chain-id $CHAIN_ID

# Get genesis
wget -O $HOME/.fiamma/config/genesis.json https://raw.githubusercontent.com/fiamma-chain/networks/main/fiamma-testnet-1/genesis.json 

# Get addrbook
wget -O $HOME/.fiamma/config/addrbook.json  https://server-5.itrocket.net/testnet/fiamma/addrbook.json

# Set peers, seeds
PEERS="5d6828849a45cf027e035593d8790bc62aca9cef@18.182.20.173:26656,526d13f3ce3e0b56fa3ac26a48f231e559d4d60c@35.73.202.182:26656" && \
SEEDS="5d6828849a45cf027e035593d8790bc62aca9cef@18.182.20.173:26656,526d13f3ce3e0b56fa3ac26a48f231e559d4d60c@35.73.202.182:26656" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.fiamma/config/config.toml

# Set pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.fiamma/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.fiamma/config/app.toml

# Set minimum gas
minimum_gas="0.00001ufia"
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"$minimum_gas\"/" $HOME/.fiamma/config/app.toml

# Disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.fiamma/config/config.toml

# Enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.fiamma/config/config.toml



echo ""
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Setting $PROJECT_NAME node service..."
echo -e "${NO_COLOR}" && sleep 1
echo ""
# Create service file
sudo tee /etc/systemd/system/fiammad.service > /dev/null << EOF
[Unit]
Description=Fiamma Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which fiammad) start
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
# Start node
sudo systemctl daemon-reload
sudo systemctl enable fiammad
sudo systemctl start fiammad

