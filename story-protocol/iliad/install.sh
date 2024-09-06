#!/bin/bash
PROJECT_NAME="Story Protocol"

# Node
NODE="story"
DAEMON_HOME="$HOME/.story/story"
DAEMON_NAME="story"
CHAIN_ID="iliad"

# Minimum supported Ubuntu version
min_version_number=2204

# Colors
RED='\033[0;31m'
RESET='\033[0m'

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

# Get the Ubuntu version
version=$(lsb_release -r | awk '{print $2}')

# Convert the version to a number for comparison
version_number=$(echo $version | sed 's/\.//')

# Compare the versions
if [ "$version_number" -lt "$min_version_number" ]; then
    echo -e "${RED}Current Ubuntu Version: "$version".${RESET}"
    echo "" && sleep 1
    echo -e "${RED}Required Ubuntu Version: 22.04.${RESET}"
    echo "" && sleep 1
    echo -e "${RED}Please use Ubuntu version 22.04 or higher.${RESET}"
    exit 1
fi	

if [ -d "$DAEMON_HOME" ]; then
    new_folder_name="${DAEMON_HOME}_$(date +"%Y%m%d_%H%M%S")"
    mv "$DAEMON_HOME" "$new_folder_name"
fi

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies... \e[0m" && sleep 1
echo ""
cd $HOME
sudo apt update
sudo apt install make unzip clang pkg-config lz4 libssl-dev build-essential git jq ncdu bsdmainutils htop -y < "/dev/null"

echo -e '\n\e[42mInstall Go\e[0m\n' && sleep 1
cd $HOME
VERSION=1.23.0
wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
# Install story
cd $HOME
rm -rf story-linux-amd64-0.9.11-2a25df1
wget -O story-linux-amd64-0.9.11-2a25df1.tar.gz https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.9.11-2a25df1.tar.gz
tar xvf story-linux-amd64-0.9.11-2a25df1.tar.gz
sudo chmod +x story-linux-amd64-0.9.11-2a25df1/story
sudo mv story-linux-amd64-0.9.11-2a25df1/story /usr/local/bin/
rm -rf story-linux-amd64-0.9.11-2a25df1
story version

# Install story-geth
cd $HOME
rm -rf geth-linux-amd64-0.9.2-ea9f0d2
wget -O geth-linux-amd64-0.9.2-ea9f0d2.tar.gz https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.2-ea9f0d2.tar.gz 
tar xvf geth-linux-amd64-0.9.2-ea9f0d2.tar.gz
sudo chmod +x geth-linux-amd64-0.9.2-ea9f0d2/geth
sudo mv geth-linux-amd64-0.9.2-ea9f0d2/geth /usr/local/bin/story-geth
rm -rf geth-linux-amd64-0.9.2-ea9f0d2

# Init node
$DAEMON_NAME init --network $CHAIN_ID --moniker "${VALIDATOR}"
sleep 1


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
#WorkingDirectory=$HOME/.story/geth
ExecStart=/usr/local/bin/story-geth --iliad --syncmode full
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/$NODE.service > /dev/null <<EOF  
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

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable $NODE
sudo systemctl restart $NODE
sudo systemctl enable story-geth
sudo systemctl restart story-geth
sleep 5


#echo ""
#echo -e "\e[1m\e[32m###########################################################################################"
#echo -e "\e[1m\e[32m### Getting $PROJECT_NAME node EVM address and private key... \e[0m" && sleep 1
#echo ""
# Show EVM address and private key
$DAEMON_NAME validator export --export-evm-key | grep "EVM Public Key"
echo "------------------------------------------------------"
cat $HOME/.story/story/config/private_key.txt | grep PRIVATE_KEY
echo "------------------------------------------------------"


