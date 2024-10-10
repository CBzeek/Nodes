#!/bin/bash
PROJECT_NAME="Story Protocol"

# Node
NODE="story"
DAEMON_HOME="$HOME/.story/story"
DAEMON_NAME="story"
CHAIN_ID="iliad"

# Binary
STORY_BIN="story-linux-amd64-0.11.0-aac4bfe"
GETH_BIN="geth-linux-amd64-0.9.3-b224fdf"
#STORY_BIN="story-linux-amd64-0.10.1-57567e5"
#STORY_BIN="story-linux-amd64-0.10.0-9603826"
#GETH_BIN="geth-linux-amd64-0.9.2-ea9f0d2"


#Backup
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/backup.sh')


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop story && sudo systemctl stop story-geth


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Install story
cd $HOME
rm -rf $STORY_BIN
wget -O $STORY_BIN.tar.gz https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/$STORY_BIN.tar.gz
tar xvf $STORY_BIN.tar.gz
sudo chmod +x $STORY_BIN/story
sudo mv $STORY_BIN/story /usr/local/bin/
rm -rf $STORY_BIN
rm -f $STORY_BIN.tar.gz
story version

# Install story-geth
cd $HOME
rm -rf $GETH_BIN
wget -O $GETH_BIN.tar.gz https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/$GETH_BIN.tar.gz 
tar xvf $GETH_BIN.tar.gz
sudo chmod +x $GETH_BIN/geth
sudo mv $GETH_BIN/geth /usr/local/bin/story-geth
rm -rf $GETH_BIN
rm -f $GETH_BIN.tar.gz


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
sudo systemctl restart story && sudo systemctl restart story-geth

