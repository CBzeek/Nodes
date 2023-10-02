#!/bin/bash
PROJECT_NAME="nibid"
NODE=NIBIRU
NODE_HOME=$HOME/.nibid
BRANCH=v0.21.10
GIT="https://github.com/NibiruChain/nibiru.git"
GIT_FOLDER=nibiru
BINARY=nibid
GENESIS="https://snapshots.nodes.guru/nibiru/genesis.json"
ADDRBOOK="https://snapshots.nodes.guru/nibiru/addrbook.json"
CHAIN_ID=nibiru-itn-3


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Install dependencies... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Installing $PROJECT_NAME node... \e[0m" && sleep 1
echo ''

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi

echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile

cd $HOME

curl -s https://get.nibiru.fi/@${BRANCH}! | bash

$BINARY init "$VALIDATOR" --chain-id $CHAIN_ID --home $HOME/.nibid

curl -s https://rpc.itn-3.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json

# Add seeds
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn2.nibiru.fi/$CHAIN_ID/seeds)'"|g' $HOME/.nibid/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025unibi\"|" $HOME/.nibid/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.nibid/config/app.toml

echo "[Unit]
Description=$NODE Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/$BINARY start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/$BINARY.service
sudo mv $HOME/$BINARY.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl restart $BINARY


