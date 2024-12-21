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



echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Downloading $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ''
rm -rf $HOME/.fiamma/data/application.db 
cp $HOME/.fiamma/data/priv_validator_state.json $HOME/.fiamma/priv_validator_state.json.backup
fiammad tendermint unsafe-reset-all --home $HOME/.fiamma --keep-addr-book
curl https://server-5.itrocket.net/testnet/fiamma/fiamma_2024-11-26_310597_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.fiamma
mv $HOME/.fiamma/priv_validator_state.json.backup $HOME/.wfiamma/data/priv_validator_state.json
#rm -f ./latest_snapshot.tar.lz4



echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### Restarting $PROJECT_NAME node..."
echo -e "${NO_COLOR}" && sleep 1
sudo systemctl restart fiammad
