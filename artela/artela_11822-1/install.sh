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

cd && rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.9-rc9
make install
source $HOME/.bash_profile

# download aspect lib
#mkdir -p $HOME/.artelad/libs && cd $HOME/.artelad/libs
#curl -L https://github.com/artela-network/artela/releases/download/v0.4.7-rc7/artelad_0.4.7_rc7_Linux_amd64.tar.gz -o artelad_0.4.7_rc7_Linux_amd64.tar.gz
#tar -xvzf artelad_0.4.7_rc7_Linux_amd64.tar.gz
#rm artelad_0.4.7_rc7_Linux_amd64.tar.gz

#echo 'export LD_LIBRARY_PATH=/root/.artelad/libs:$LD_LIBRARY_PATH' >> ~/.bash_profile
#source ~/.bash_profile

#init node
cd $HOME
artelad config chain-id $CHAIN_ID
artelad config keyring-backend test
artelad config node tcp://localhost:$RPC_PORT
artelad init $MONIKER --chain-id $CHAIN_ID

#get genesis
curl -L https://snapshots-testnet.nodejumper.io/artela/genesis.json > $HOME/.artelad/config/genesis.json

#get addrbook
curl -L https://snapshots-testnet.nodejumper.io/artela/addrbook.json > $HOME/.artelad/config/addrbook.json

#peers, seeds
PEERS="5c9b1bc492aad27a0197a6d3ea3ec9296504e6fd@artela-testnet-peer.itrocket.net:30656,84f072e9154b3816ea6384de87d0dacea03e4195@213.199.61.46:30656,2503d2069bba21ca0366604ab87b53bed44949ed@157.173.207.232:3456,0e03c8834092c72fd70fada5f50d6f3781d5fb56@213.199.42.220:26656,cf88a302a7a9921367def8ed15ba414797b56468@62.169.26.97:3456,2f3b9357487f5bc603b36099e583d4fb22e8a065@156.67.31.31:23456,27abd947b1d8264178f8c04958bd40fe257ba52b@156.67.82.186:3456,1f09c918f39240cf204996cd1239eccdbb22a779@45.136.17.26:3456,6eb16383587830598578393c8c33b0415784f645@109.199.124.243:26656,647c0147fdeb92f0ecec499464f78f10bbde4205@38.242.139.66:26666,58514c1280eb7b0cc57881fa09f0a4d39a39e886@195.7.4.16:11856,3a5e376458bacb248650e924d9904ee0fdf46644@45.92.9.138:3456,c25185a411b5f5f653a4bf5410cb3af71ff6a53a@65.108.67.54:3456,3a3905cabaa5439f9a571f1f108c518ea696b4cf@195.7.6.6:11856,f994e822daa8bb8a21536ba2dbc09b8771afe2c5@89.117.148.223:3456,ee59c0f7f207da7f12671550393307e54de86feb@84.46.253.1:3456,8590ccf8fed731039e70e19132d20a0c2c50f17d@109.123.245.21:3456,b52689aa72b9cfd3cd882aca90e744b76fd8f168@92.42.106.203:37656,1b0cd81c4b06fd57f613c691dc93bae79b117a89@109.205.182.73:3456,44d058e60f233f842647f5a62fe139c8326648cf@185.209.229.62:3456,8d198deb0f48dd2e4d0f00b3d4fe1772413171fc@95.217.120.205:15856"
#PEERS="b2481ce4c59d7f15aae95dc9b60f6b42472d0bb8@49.13.115.147:45656,bc0e0607cbdee58eb11a95ba37b1f61319997ab5@2.56.99.251:3456,eaf1212822b94c625daae017e35e4743466c9d1f@91.205.105.41:3456,63558a9bd71ed66fd833fd25eb3a1e2a73c824cc@108.181.54.37:3456,92d95c7133275573af25a2454283ebf26966b188@167.235.178.134:27856,22533e3edfbeabec006591c3afae06fd970a3556@35.229.139.209:3456,01a67d55aad78327b2b4a16934a50d74fb128823@38.242.255.76:3456,6bc725e9539cb04c117aa1ca526c1a0256f685b2@202.61.226.0:3456,0f5a4ad942c2bb222362e7cb92f11f0f474a0f6d@45.136.17.29:3456,2ea95fed41189059e4de1e678de34fe999dd6e7a@104.234.231.98:3456" && \
SEEDS="211536ab1414b5b9a2a759694902ea619b29c8b1@47.251.14.47:26656,d89e10d917f6f7472125aa4c060c05afa78a9d65@47.251.32.165:26656,bec6934fcddbac139bdecce19f81510cb5e02949@47.254.24.106:26656,32d0e4aec8d8a8e33273337e1821f2fe2309539a@47.88.58.36:26656,1bf5b73f1771ea84f9974b9f0015186f1daa4266@47.251.14.47:26656" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.artelad/config/config.toml
#sed -i -e 's|^seeds *=.*|seeds = "211536ab1414b5b9a2a759694902ea619b29c8b1@47.251.14.47:26656,d89e10d917f6f7472125aa4c060c05afa78a9d65@47.251.32.165:26656,bec6934fcddbac139bdecce19f81510cb5e02949@47.254.24.106:26656,32d0e4aec8d8a8e33273337e1821f2fe2309539a@47.88.58.36:26656,1bf5b73f1771ea84f9974b9f0015186f1daa4266@47.251.14.47:26656"|' $HOME/.artelad/config/config.toml

#set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.artelad/config/app.toml

#set gas
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "20000000000uart"|' $HOME/.artelad/config/app.toml

#set pool
sed -E 's/^pool-size[[:space:]]*=[[:space:]]*[0-9]+$/apply-pool-size = 10\nquery-pool-size = 30/' ~/.artelad/config/app.toml > ~/.artelad/config/temp.app.toml && mv ~/.artelad/config/temp.app.toml ~/.artelad/config/app.toml


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
#echo ""
#shapshot
curl "https://snapshots-testnet.nodejumper.io/artela-testnet/artela-testnet_latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.artelad"


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
Environment="LD_LIBRARY_PATH=$HOME/.artelad/libs:$LD_LIBRARY_PATH"
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

