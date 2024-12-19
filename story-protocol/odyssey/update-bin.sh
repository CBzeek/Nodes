#!/bin/bash
PROJECT_NAME="Story Protocol"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')



# Node
NODE="story"


# Binary
STORY_BIN="https://github.com/piplabs/story/releases/download/v0.13.0/story-linux-amd64"
GETH_BIN="https://github.com/piplabs/story-geth/releases/download/v0.10.1/geth-linux-amd64"


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop story && sudo systemctl stop story-geth
sleep 1


# Backup
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/story-protocol/odyssey/backup.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Install story-geth
cd $HOME
rm -rf $GETH_BIN
wget -O story-geth $GETH_BIN
sudo chmod +x $HOME/story-geth
sudo mv $HOME/story-geth /usr/local/bin/
rm -rf $GETH_BIN
story-geth version


# Install story
cd $HOME
rm -rf $STORY_BIN
wget -O story $STORY_BIN
sudo chmod +x $HOME/story
sudo mv $HOME/story /usr/local/bin/
rm -rf $STORY_BIN
story version


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
sudo systemctl restart story && sudo systemctl restart story-geth
