#!/bin/bash
PROJECT_NAME="Story Protocol"
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop story && sudo systemctl stop story-geth


#Backup
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/backup.sh')


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''

STORY_SNAP=$(curl -s https://server-3.itrocket.net/testnet/story/ | grep -oP '(?<=href=")[^"]*' | sed 's/.*\///' | grep story_2024 | awk 'NR == 4')
GETH_SNAP=$(curl -s https://server-3.itrocket.net/testnet/story/ | grep -oP '(?<=href=")[^"]*' | sed 's/.*\///' | grep story_2024 | awk 'NR == 2')
echo $STORY_SNAP
echo $GETH_SNAP

rm -rf ~/.story/story/data/application.db 
sleep 1
cp ~/.story/story/data/priv_validator_state.json ~/.story/story/priv_validator_state.json.backup

cd $HOME
rm -rf ~/.story/story/data
rm -rf ~/.story/geth/iliad/geth/chaindata
#wget -O Story_snapshot.lz4 https://vps5.josephtran.xyz/Story/Story_snapshot.lz4
#wget -O Geth_snapshot.lz4 https://vps5.josephtran.xyz/Story/Geth_snapshot.lz4
#wget -O Story_snapshot.lz4 https://josephtran.co/story/Story_snapshot.lz4
#wget -O Geth_snapshot.lz4 https://josephtran.co/story/Geth_snapshot.lz4
wget -O Story_snapshot.lz4 https://server-3.itrocket.net/testnet/story/$STORY_SNAP
wget -O Geth_snapshot.lz4 https://server-3.itrocket.net/testnet/story/$GETH_SNAP
mkdir -p $HOME/.story/story/data
lz4 -d -c ./Story_snapshot.lz4 | tar -xf - -C $HOME/.story/story/
mkdir -p $HOME/.story/geth/iliad/geth/chaindata
lz4 -d -c ./Geth_snapshot.lz4 | tar -xf - -C $HOME/.story/geth/iliad/geth/
rm -f ./Story_snapshot.lz4
rm -f ./Geth_snapshot.lz4

mv ~/.story/story/priv_validator_state.json.backup ~/.story/story/data/priv_validator_state.json

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart story && sudo systemctl restart story-geth
