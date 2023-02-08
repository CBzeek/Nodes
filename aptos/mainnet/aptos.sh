#!/bin/bash

cd $HOME
rm -rf aptos-core
sudo mkdir -p /opt/aptos/data .aptos/config

git clone https://github.com/aptos-labs/aptos-core.git

cd aptos-core

echo y | ./scripts/dev_setup.sh
source ~/.cargo/env

git checkout --track origin/mainnet
cargo build -p aptos-node --release

mv  ~/aptos-core/target/release/aptos-node /usr/local/bin
cp ~/aptos-core/config/src/config/test_data/public_full_node.yaml ~/.aptos/config/fullnode.yaml

wget -q -O $HOME/.aptos/config/genesis.blob https://raw.githubusercontent.com/aptos-labs/aptos-networks/main/mainnet/genesis.blob
wget -q -O $HOME/.aptos/config/waypoint.txt https://raw.githubusercontent.com/aptos-labs/aptos-networks/main/mainnet/waypoint.txt

sleep 2 

sed -i.bak -e "s/127.0.0.1/0.0.0.0/" $HOME/.aptos/config/fullnode.yaml
sed -i "s|genesis_file_location: .*|genesis_file_location: \"$HOME/.aptos/config/genesis.blob\"|" $HOME/.aptos/config/fullnode.yaml
sed -i "s|from_file: .*|from_file: \"$HOME/.aptos/config/waypoint.txt\"|" $HOME/.aptos/config/fullnode.yaml

echo "[Unit]
Description=Aptos
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/aptos-node -f $HOME/.aptos/config/fullnode.yaml
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/aptosd.service

mv $HOME/aptosd.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable aptosd
sudo systemctl restart aptosd
