#!/bin/bash
PROJECT_NAME="Story Protocol"

# Node
NODE="story"
CHAIN_ID="odyssey"

# Binary
STORY_BIN="https://github.com/piplabs/story/releases/download/v0.12.1/story-linux-amd64"
GETH_BIN="https://github.com/piplabs/story-geth/releases/download/v0.10.0/geth-linux-amd64"

#Check curl
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    source $HOME/.bash_profile
fi

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1



echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop story && sudo systemctl stop story-geth
rm -rf $HOME/.story/story/data/application.db
sleep 1


#Backup to update
mkdir -p $HOME/update-network
cp $HOME/.story/story/config/node_key.json $HOME/update-network/node_key.json
cp $HOME/.story/story/config/priv_validator_key.json $HOME/update-network/priv_validator_key.json

#Backup iliad
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/story-protocol/iliad/backup.sh')

#Delete old
sudo rm -rf $HOME/.story
sudo rm /etc/systemd/system/story-geth.service
sudo rm /etc/systemd/system/story.service

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Install story
cd $HOME
wget -O story $STORY_BIN
sudo chmod +x $HOME/story
sudo mv $HOME/story /usr/local/bin/
story version

# Install story-geth
cd $HOME
wget -O story-geth $GETH_BIN
sudo chmod +x $HOME/story-geth
sudo mv $HOME/story-geth /usr/local/bin/
story-geth version

# Init node
story init --network $CHAIN_ID --moniker "${VALIDATOR}"
sleep 1

rm $HOME/.story/story/config/node_key.json
rm $HOME/.story/story/config/priv_validator_key.json

cp $HOME/update-network/node_key.json $HOME/.story/story/config/node_key.json
cp $HOME/update-network/priv_validator_key.json $HOME/.story/story/config/priv_validator_key.json


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Setting $PROJECT_NAME node service... \e[0m" && sleep 1
echo ""
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF  
[Unit]
Description=Story execution daemon
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/story-geth --odyssey --syncmode full
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/story.service > /dev/null <<EOF  
[Unit]
Description=Story consensus daemon
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/.story/story
ExecStart=/usr/local/bin/story run
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable story
sudo systemctl restart story
sudo systemctl enable story-geth
sudo systemctl restart story-geth
sleep 5


#Backup odyssey
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/story-protocol/odyssey/backup.sh')


#Snapshot
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/story-protocol/odyssey/snapshot.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Getting $PROJECT_NAME node EVM address and private key... \e[0m" && sleep 1
echo ""
# Show EVM address, private key, validator public key
echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### EVM Public Key"
story validator export --export-evm-key | grep "EVM Address"
echo ""

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Private Key"
cat $HOME/.story/story/config/private_key.txt | grep PRIVATE_KEY
echo ""

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Validator Public Key"
cat /root/.story/story/config/priv_validator_key.json | jq [.pub_key.value]
echo ""

