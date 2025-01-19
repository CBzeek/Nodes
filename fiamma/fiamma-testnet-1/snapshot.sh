#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="Fiamma"


echo ''
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Stopping $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
echo ''
sudo systemctl stop fiammad


echo ''
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Downloading $PROJECT_NAME node snapshot..."
echo -e "${NO_COLOR}" && sleep 1
echo ''
cd $HOME
rm -rf $HOME/.fiamma/data/application.db
cp $HOME/.fiamma/data/priv_validator_state.json $HOME/.fiamma/priv_validator_state.json.backup
fiammad tendermint unsafe-reset-all --home $HOME/.fiamma --keep-addr-book
LATEST_SNAPSHOT=$(curl -s https://server-1.stavr.tech/Testnet/Fiamma/ | grep -oE 'fiamma-snap-[0-9]+\.tar\.lz4' | while read SNAPSHOT; do HEIGHT=$(curl -s "https://server-1.stavr.tech/Testnet/Fiamma/${SNAPSHOT%.tar.lz4}-info.txt" | awk '/Block height:/ {print $3}'); echo "$SNAPSHOT $HEIGHT"; done | sort -k2 -nr | head -n 1 | awk '{print $1}')
curl -o - -L https://server-1.stavr.tech/Testnet/Fiamma/$LATEST_SNAPSHOT | lz4 -c -d - | tar -x -C $HOME/.fiamma
mv $HOME/.fiamma/priv_validator_state.json.backup $HOME/.fiamma/data/priv_validator_state.json
rm -f ./$LATEST_SNAPSHOT

#FIAMMA_SNAP=$(curl -s https://server-5.itrocket.net/testnet/fiamma/ | grep -oP '(?<=href=")[^"]*' | sed 's/.*\///' | grep fiamma | awk 'NR == 2')
#rm -rf $HOME/.fiamma/data/application.db
#cp $HOME/.fiamma/data/priv_validator_state.json $HOME/.fiamma/priv_validator_state.json.backup
#fiammad tendermint unsafe-reset-all --home $HOME/.fiamma --keep-addr-book
#curl https://server-5.itrocket.net/testnet/fiamma/$FIAMMA_SNAP | lz4 -dc - | tar -xf - -C $HOME/.fiamma
#mv $HOME/.fiamma/priv_validator_state.json.backup $HOME/.fiamma/data/priv_validator_state.json
#rm -f ./latest_snapshot.tar.lz4


echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Restarting $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
sudo systemctl restart fiammad
