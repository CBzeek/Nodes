#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

#Backup & delete old files
if [ -f $HOME/.aptos/config ]; then
    echo 'Stopping aptos node...'
    sudo systemctl stop aptosd
    echo 'Aptos node stopping done'
    sleep 2

    echo 'Backup configuration files...'
    cd $HOME
    cp -r $HOME/.aptos $HOME/aptos_backup_$(date +%F--%R)
    echo 'Backup files done'
    sleep 2

    echo 'Erasing old aptos data...'
    cd $HOME
    rm -rf ~/aptos-core
    rm -rf ~/.aptos/config/
    rm -rf ~/.aptos/waypoint.txt
    rm -rf /opt/aptos/
    echo 'Erase old aptos data done'
    sleep 2
else
    echo ''
fi

#Install additional software
echo 'Installing curl, git, yq...'
sudo apt install curl -y < "/dev/null"
sudo apt update && sudo apt install git -y
wget -q -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64 && chmod +x /usr/local/bin/yq
echo 'Curl. git, yq installation done'
sleep 2

#making dir structure
echo 'Making directory structure...'
cd $HOME
sudo mkdir -p /opt/aptos/data .aptos/config .aptos/key
git clone https://github.com/aptos-labs/aptos-core.git
cd aptos-core
git checkout origin/devnet &>/dev/null
echo 'Directory structure done'
sleep 2

#aptos install
echo 'Installing aptos node...'
echo y | ./scripts/dev_setup.sh
source ~/.cargo/env
cargo build -p aptos-node --release
cargo build -p aptos-operational-tool --release
mv  ~/aptos-core/target/release/aptos-node /usr/local/bin
mv  ~/aptos-core/target/release/aptos-operational-tool /usr/local/bin
echo 'Aptos node installation - Done'
sleep 2

#Check for private-key.txt
if [ -f ~/.aptos/key/private-key.txt ]; then
    echo 'Private-key exists'
else
    echo 'Generating private key...'
#    /usr/local/bin/aptos-operational-tool generate-key --encoding hex --key-type x25519 --key-file ~/.aptos/key/private-key.txt
    echo 'Private-key generation done'
    sleep 2
fi

#Generating peer info
echo 'Generating peer info...'
/usr/local/bin/aptos-operational-tool extract-peer-from-file --encoding hex --key-file ~/.aptos/key/private-key.txt --output-file ~/.aptos/config/peer-info.yaml &>/dev/null
echo 'Peer info generation done'
sleep 2

#Downloading devnet data
echo 'Downloading aptos devnet data...'
cp ~/aptos-core/config/src/config/test_data/public_full_node.yaml ~/.aptos/config
wget -O /opt/aptos/data/genesis.blob https://devnet.aptoslabs.com/genesis.blob
wget -O /opt/aptos/data/waypoint.txt https://devnet.aptoslabs.com/waypoint.txt
echo 'Downloading devnet data done'
sleep 2

#Configuring aptos node
echo 'Configuring aptos node...'
wget -O seeds.yaml https://github.com/CBzeek/Nodes/raw/main/seeds.yaml
PRIVKEY=$(cat ~/.aptos/key/private-key.txt)
PEER=$(sed -n 2p ~/.aptos/config/peer-info.yaml | sed 's/.$//')
sed -i.bak "s/genesis_file_location: .*/genesis_file_location: \"\/opt\/aptos\/data\/genesis.blob\"/" $HOME/.aptos/config/public_full_node.yaml
sed -i "s/from_file: .*/from_file: \"\/opt\/aptos\/data\/waypoint.txt\"/" $HOME/.aptos/config/public_full_node.yaml
sed -i "s/127.0.0.1/0.0.0.0/" $HOME/.aptos/config/public_full_node.yaml
sed -i '/network_id: "public"$/a\
      identity:\
        type: "from_config"\
        key: "'$PRIVKEY'"\
        peer_id: "'$PEER'"' $HOME/.aptos/config/public_full_node.yaml
/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/.aptos/config/public_full_node.yaml seeds.yaml
echo 'Aptos node configuration  done'
sleep 2

#Creating aptos service
echo 'Creating aptos service...'

echo "[Unit]
Description=Aptos
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/aptos-node -f $HOME/.aptos/config/public_full_node.yaml
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/aptosd.service
echo 'Aptos service creation done'
sleep 2

#Staring node
echo 'Starting aptos node...'
mv $HOME/aptosd.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable aptosd
sudo systemctl restart aptosd
echo 'Aptos node start done'
sleep 2

