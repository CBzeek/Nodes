#!/bin/bash
PROJECT_NAME="Gitopia"
PROJECT_VERSION="v5.1.0"

if [ ! $MONIKER ]; then
    echo ""
    echo -e "\e[1m\e[32m###########################################################################################"
    echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node moniker... \e[0m" && sleep 1
    echo ""
    read -p "Enter node moniker: " MONIKER
    echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
fi

if [ ! $CHAIN_ID ]; then
    echo 'export CHAIN_ID="gitopia"' >> ~/.bash_profile
fi

if [ ! $WALLET_NAME ]; then
    echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
fi

#if [ ! $RPC_PORT ]; then
#    echo 'export RPC_PORT="11357"' >> ~/.bash_profile
#fi
source $HOME/.bash_profile



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
#update
sudo apt update && apt upgrade -y
sudo apt install curl git jq lz4 build-essential -y

#install go
sudo rm -rf /usr/local/go
#curl -L https://go.dev/dl/go1.22.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
curl -L https://go.dev/dl/go1.21.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source $HOME/.bash_profile



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#install node
cd $HOME
cd && rm -rf gitopia
git clone https://github.com/gitopia/gitopia
cd gitopia
git checkout $PROJECT_VERSION
make install
source $HOME/.bash_profile

#init node
cd $HOME
gitopiad config chain-id $CHAIN_ID
gitopiad config keyring-backend file
#gitopiad config node tcp://localhost:$RPC_PORT
gitopiad init $MONIKER --chain-id $CHAIN_ID

#get genesis
curl -L https://snapshots.nodejumper.io/gitopia/genesis.json > $HOME/.gitopia/config/genesis.json

#get addrbook
curl -L https://snapshots.nodejumper.io/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json

#peers, seeds
#sed -i -e 's|^seeds *=.*|seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:11356,20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:11356,ebc272824924ea1a27ea3183dd0b9ba713494f83@gitopia-mainnet-seed.autostake.com,187425bc3739daaef8cb1d7cf47d655117396dbe@seed-gitopia.ibs.team:16660,9aa8a73ea9364aa3cf7806d4dd25b6aed88d8152@gitopia-seed.mzonder.com:11056,400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@gitopia.rpc.kjnodes.com:14159,f280239045928af4e1b289d9df4059b7f941777b@seed-node.mms.team:35656,a74403b9fbf58ba7538e0a9584510c67a0877beb@rpc.gitopia.nodestake.top:666,6d41d36d54abd868c4cdaf5b956ac047327bff67@seeds-3.anode.team:10260,8542cd7e6bf9d260fef543bc49e59be5a3fa9074@seed.publicnode.com:26656"|' $HOME/.gitopia/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.gitopia/config/config.toml
peers="4cf66531681c92f15c95c25bd1bff524f9dca35e@65.109.154.181:26656,b2f764694d52e09793d68259d584ece0c194b6fe@65.108.229.93:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.gitopia/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.gitopia/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.gitopia/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.gitopia/config/config.toml

#Set minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0012ulore"|' $HOME/.gitopia/config/app.toml

#Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.gitopia/config/app.toml

#Enable prometheus
#sed -i -e 's|^prometheus *=.*|prometheus = true|' $HOME/.gitopia/config/config.toml

# Change ports
#sed -i -e "s%:1317%:11317%; s%:8080%:11380%; s%:9090%:11390%; s%:9091%:11391%; s%:8545%:11345%; s%:8546%:11346%; s%:6065%:11365%" $HOME/.gitopia/config/app.toml
#sed -i -e "s%:26658%:11358%; s%:26657%:11357%; s%:6060%:11360%; s%:26656%:11356%; s%:26660%:11361%" $HOME/.gitopia/config/config.toml



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node service... \e[0m" && sleep 1
echo ""
#service file
# Create a service
sudo tee /etc/systemd/system/gitopiad.service > /dev/null << EOF
[Unit]
Description=Gitopia node service
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.gitopia
ExecStart=$(which gitopiad) start
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.gitopia"
Environment="DAEMON_NAME=gitopiad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
[Install]
WantedBy=multi-user.target
EOF



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl daemon-reload
sudo systemctl enable gitopiad
sudo systemctl start gitopiad


