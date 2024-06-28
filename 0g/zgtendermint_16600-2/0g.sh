#!/bin/bash
PROJECT_NAME="0G"

if [ ! $MONIKER ]; then
    echo ""
    echo -e "\e[1m\e[32m###########################################################################################"
    echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node moniker... \e[0m" && sleep 1
    echo ""
    read -p "Enter node moniker: " MONIKER
    echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
fi
#read -p "Enter node moniker: " MONIKER
#echo 'export MONIKER='\"${MONIKER}\" >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_16600-2"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
#update
sudo apt update && \
sudo apt install curl git jq build-essential gcc unzip wget lz4 -y


#install go
cd $HOME && \
ver="1.21.3" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#install binary 
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
cd 0g-chain
make install
0gchaind version
source $HOME/.bash_profile

#init node
cd $HOME
0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
0gchaind config node tcp://localhost:$RPC_PORT
0gchaind init $MONIKER --chain-id $CHAIN_ID

#get genesis
wget -O $HOME/.0gchain/config/genesis.json https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json

#get addrbook
#wget -O $HOME/.0gchain/config/addrbook.json https://snapshots.liveraven.net/snapshots/testnet/zero-gravity/addrbook.json
#curl -Ls https://snapshots.liveraven.net/snapshots/testnet/zero-gravity/addrbook.json > $HOME/.0gchain/config/addrbook.json

#peers, seeds
PEERS="" && \
SEEDS="81987895a11f6689ada254c6b57932ab7ed909b6@54.241.167.190:26656,010fb4de28667725a4fef26cdc7f9452cc34b16d@54.176.175.48:26656,e9b4bc203197b62cc7e6a80a64742e752f4210d5@54.193.250.204:26656,68b9145889e7576b652ca68d985826abd46ad660@18.166.164.232:26656" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

#config
EXTERNAL_IP=$(wget -qO- eth0.me) \
PROXY_APP_PORT=26658 \
P2P_PORT=26656 \
PPROF_PORT=6060 \
API_PORT=1317 \
GRPC_PORT=9090 \
GRPC_WEB_PORT=9091

#set port
sed -i \
    -e "s/\(proxy_app = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$PROXY_APP_PORT\"/" \
    -e "s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$RPC_PORT\"/" \
    -e "s/\(pprof_laddr = \"\)\([^:]*\):\([0-9]*\).*/\1localhost:$PPROF_PORT\"/" \
    -e "/\[p2p\]/,/^\[/{s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$P2P_PORT\"/}" \
    -e "/\[p2p\]/,/^\[/{s/\(external_address = \"\)\([^:]*\):\([0-9]*\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/; t; s/\(external_address = \"\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/}" \
    $HOME/.0gchain/config/config.toml

sed -i \
    -e "/\[api\]/,/^\[/{s/\(address = \"tcp:\/\/\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$API_PORT\4/}" \
    -e "/\[grpc\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_PORT\4/}" \
    -e "/\[grpc-web\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_WEB_PORT\4/}" $HOME/.0gchain/config/app.toml

#set pruning
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.0gchain/config/app.toml

#set gas
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
#echo ""
#shapshot
#cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
#rm -rf $HOME/.0gchain/data
#curl -L http://snapshots.liveraven.net/snapshots/testnet/zero-gravity/zgtendermint_16600-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.0gchain
#mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node service... \e[0m" && sleep 1
echo ""
#service file
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=OG Node
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=$(which 0gchaind) start --home $HOME/.0gchain
Restart=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl daemon-reload && \
sudo systemctl enable ogd && \
sudo systemctl start ogd


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node comsos wallet... \e[0m" && sleep 1
#echo ""
#echo "Select option:"
#echo "1 - Create a new wallet"
#echo "2 - Import an existing wallet"
#read -p "Enter option: " OPTION
#case $OPTION in
#    2)  #Import wallet
#        0gchaind keys add --recover $WALLET_NAME --eth
#        ;;
#    *)  #Create wallet
#        0gchaind keys add $WALLET_NAME --eth
#        ;;
#esac


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Getting $PROJECT_NAME node EVM address... \e[0m" && sleep 1
#echo ""
#get EVM address
#echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"

#get EVM privatekey
#0gchaind keys unsafe-export-eth-key $WALLET_NAME
#echo ""
