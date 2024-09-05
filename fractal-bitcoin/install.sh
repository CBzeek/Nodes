#!/bin/bash
PROJECT_NAME="Fractal Bitcoin"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
sudo apt-get update -y && sudo apt upgrade -y && sudo apt-get install make build-essential pkg-config libssl-dev unzip tar lz4 gcc git jq -y


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#Get binary
wget https://github.com/fractal-bitcoin/fractald-release/releases/download/v0.1.8/fractald-0.1.8-x86_64-linux-gnu.tar.gz
tar -zxvf fractald-0.1.8-x86_64-linux-gnu.tar.gz
cd fractald-0.1.8-x86_64-linux-gnu/
mkdir data
cp ./bitcoin.conf ./data


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node service... \e[0m" && sleep 1
echo ""
#service file
sudo tee /etc/systemd/system/fractald.service > /dev/null << EOF
[Unit]
Description=Fractal Node
After=network-online.target
[Service]
User=$USER
ExecStart=/root/fractald-0.1.8-x86_64-linux-gnu/bin/bitcoind -datadir=/root/fractald-0.1.8-x86_64-linux-gnu/data/ -maxtipage=504576000
Restart=always
RestartSec=5
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF

#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Creating $PROJECT_NAME bitcoin wallet... \e[0m" && sleep 1
#echo ""
cd bin
./bitcoin-wallet -wallet=wallet -legacy create
./bitcoin-wallet -wallet=/root/.bitcoin/wallets/wallet/wallet.dat -dumpfile=/root/.bitcoin/wallets/wallet/MyPK.dat dump

#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Getting $PROJECT_NAME private key... \e[0m" && sleep 1
#echo ""
#get private key
cd && awk -F 'checksum,' '/checksum/ {print "Wallet Private Key:" $2}' .bitcoin/wallets/wallet/MyPK.dat
read -p "Don't remember to save private key!!! Press enter to continue..."

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl daemon-reload
sudo systemctl enable fractald
sudo systemctl start fractald

#logs
sudo journalctl -u fractald -f --no-hostname -o cat




