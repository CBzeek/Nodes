#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop $PROJECT_BIN


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
# build new binary
cd && rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.7-rc7-fix-execution
make install

# download aspect lib
mkdir -p $HOME/.artelad/libs && cd $HOME/.artelad/libs
curl -L https://github.com/artela-network/artela/releases/download/v0.4.7-rc7/artelad_0.4.7_rc7_Linux_amd64.tar.gz -o artelad_0.4.7_rc7_Linux_amd64.tar.gz
tar -xvzf artelad_0.4.7_rc7_Linux_amd64.tar.gz
rm artelad_0.4.7_rc7_Linux_amd64.tar.gz

echo 'export LD_LIBRARY_PATH=/root/.artelad/libs:$LD_LIBRARY_PATH' >> ~/.bash_profile
source ~/.bash_profile

# update addrbook
curl -s https://snapshots-testnet.nodejumper.io/artela-testnet/addrbook.json > $HOME/.artelad/config/addrbook.json

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl start $PROJECT_BIN
