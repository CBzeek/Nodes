#!/bin/bash
PROJECT_NAME="Story Protocol"

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop story && sudo systemctl stop story-geth

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''

cd $HOME
#wget -O Story_snapshot.lz4 https://vps5.josephtran.xyz/Story/Story_snapshot.lz4
#wget -O Geth_snapshot.lz4 https://vps5.josephtran.xyz/Story/Geth_snapshot.lz4
wget -O Story_snapshot.lz4 https://josephtran.co/story/Story_snapshot.lz4
wget -O Geth_snapshot.lz4 https://josephtran.co/story/Geth_snapshot.lz4
rm -rf ~/.story/story/data
rm -rf ~/.story/geth/iliad/geth/chaindata
mkdir -p $HOME/.story/story/data
lz4 -d -c ./Story_snapshot.lz4 | tar -xf - -C $HOME/.story/story/
mkdir -p $HOME/.story/geth/iliad/geth/chaindata
lz4 -d -c ./Geth_snapshot.lz4 | tar -xf - -C $HOME/.story/geth/iliad/geth/
rm -f ./Story_snapshot.lz4
rm -f ./Geth_snapshot.lz4


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart story && sudo systemctl restart story-geth
