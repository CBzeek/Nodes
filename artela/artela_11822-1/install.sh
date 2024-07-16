#!/bin/bash
PROJECT_NAME="Artela"

if [ ! $MONIKER ]; then
    echo ""
    echo -e "\e[1m\e[32m###########################################################################################"
    echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node moniker... \e[0m" && sleep 1
    echo ""
    read -p "Enter node moniker: " MONIKER
    echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
fi

if [ ! $CHAIN_ID ]; then
    echo 'export CHAIN_ID="artela_11822-1"' >> ~/.bash_profile
fi

if [ ! $WALLET_NAME ]; then
    echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
fi

if [ ! $RPC_PORT ]; then
    echo 'export RPC_PORT="26657"' >> ~/.bash_profile
fi
source $HOME/.bash_profile


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
#update
sudo apt update && apt upgrade -y
sudo apt install curl iptables build-essential git wget jq make gcc nano tmux htop lz4 nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y


#install go
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.21.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source .bash_profile


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#install binary 
cd $HOME
git clone https://github.com/artela-network/artela.git
cd artela
git checkout v0.4.7-rc6
make install
source $HOME/.bash_profile

#init node
cd $HOME
artelad config chain-id $CHAIN_ID
artelad config keyring-backend test
artelad config node tcp://localhost:$RPC_PORT
artelad init $MONIKER --chain-id $CHAIN_ID

#get genesis
curl -L https://snapshots-testnet.nodejumper.io/artela-testnet/genesis.json > $HOME/.artelad/config/genesis.json

#get addrbook
curl -L https://snapshots-testnet.nodejumper.io/artela-testnet/addrbook.json > $HOME/.artelad/config/addrbook.json

#peers, seeds
sed -i -e 's|^seeds *=.*|seeds = "211536ab1414b5b9a2a759694902ea619b29c8b1@47.251.14.47:26656,d89e10d917f6f7472125aa4c060c05afa78a9d65@47.251.32.165:26656,bec6934fcddbac139bdecce19f81510cb5e02949@47.254.24.106:26656,32d0e4aec8d8a8e33273337e1821f2fe2309539a@47.88.58.36:26656,1bf5b73f1771ea84f9974b9f0015186f1daa4266@47.251.14.47:26656"|' $HOME/.artelad/config/config.toml

#set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.artelad/config/app.toml

#set gas
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "20000000000uart"|' $HOME/.artelad/config/app.toml


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
#echo ""
#shapshot
#curl "https://snapshots-testnet.nodejumper.io/artela-testnet/artela-testnet_latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.artelad"


#cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
#rm -rf $HOME/.0gchain/data
#curl -L http://snapshots.liveraven.net/snapshots/testnet/zero-gravity/zgtendermint_16600-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.0gchain
#mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node service... \e[0m" && sleep 1
echo ""
#service file
sudo tee /etc/systemd/system/artelad.service > /dev/null << EOF
[Unit]
Description=Artela node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which artelad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl daemon-reload
sudo systemctl enable artelad
sudo systemctl start artelad

