#!/bin/bash

read -r -p "Enter node moniker: " MONIKER

#Install dependencies
#Update system and install build tools
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

#Install Go
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

#Download and build binaries
# Clone project repository
cd $HOME
rm -rf hub
git clone https://github.com/mars-protocol/hub.git
cd hub
git checkout v1.0.0-rc7

# Build binaries
make build

# Prepare binaries for Cosmovisor
mkdir -p $HOME/.mars/cosmovisor/genesis/bin
mv build/marsd $HOME/.mars/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/.mars/cosmovisor/genesis $HOME/.mars/cosmovisor/current
sudo ln -s $HOME/.mars/cosmovisor/current/bin/marsd /usr/local/bin/marsd

#Install Cosmovisor and create a service
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Create service
sudo tee /etc/systemd/system/marsd.service > /dev/null << EOF
[Unit]
Description=mars-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.mars"
Environment="DAEMON_NAME=marsd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable marsd

#Initialize the node
# Set node configuration
marsd config chain-id ares-1
marsd config keyring-backend test

# Initialize the node
marsd init $MONIKER --chain-id ares-1

# Download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/mars-testnet/genesis.json > $HOME/.mars/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/mars-testnet/addrbook.json > $HOME/.mars/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@mars-testnet.rpc.kjnodes.com:45659\"|" $HOME/.mars/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0umars\"|" $HOME/.mars/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.mars/config/app.toml

#Download latest chain snapshot
curl -L https://snapshots.kjnodes.com/mars-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.mars
[[ -f $HOME/.mars/data/upgrade-info.json ]] && cp $HOME/.mars/data/upgrade-info.json $HOME/.mars/cosmovisor/genesis/upgrade-info.json

#Start service and check the logs
sudo systemctl start marsd && sudo journalctl -u marsd -f --no-hostname -o cat


