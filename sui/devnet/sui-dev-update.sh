#!/bin/bash
cd $HOME

PROJECT_NAME="sui"

#Stop service
echo ''
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
systemctl stop suid

#Erase data
echo ''
echo -e "\e[1m\e[32m### Erasing $PROJECT_NAME data... \e[0m" && sleep 1
echo ''
rm -rf /var/sui/db/* /var/sui/genesis.blob $HOME/sui
mkdir -p /var/sui/db

#Update
echo ''
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME... \e[0m" && sleep 1
echo ''
source $HOME/.cargo/env
cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git checkout -B devnet --track upstream/devnet
cargo build -p sui-node -p sui --release
mv ~/sui/target/release/sui-node /usr/local/bin/
mv ~/sui/target/release/sui /usr/local/bin/
wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

#Restart service 
echo ''
echo '### Starting $PROJECT_NAME service'
echo ''
systemctl restart suid
