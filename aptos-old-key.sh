#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
curl -s https://api.nodes.guru/logo.sh | bash && sleep 2
sudo apt update && sudo apt install git -y
cd $HOME
rm -rf aptos-core
sudo mkdir -p /opt/aptos/data .aptos/config .aptos/key
git clone https://github.com/aptos-labs/aptos-core.git
cd aptos-core
git checkout origin/devnet &>/dev/null
echo y | ./scripts/dev_setup.sh
source ~/.cargo/env
cargo build -p aptos-node --release
cargo build -p aptos-operational-tool --release
mv ~/aptos-core/target/release/aptos-node /usr/local/bin
mv ~/aptos-core/target/release/aptos-operational-tool /usr/local/bin
/usr/local/bin/aptos-operational-tool extract-peer-from-file --encoding hex --key-file ~/.aptos/key/private-key.txt --output-file ~/.aptos/config/peer-info.yaml &>/dev/null
cp ~/aptos-core/config/src/config/test_data/public_full_node.yaml ~/.aptos/config
wget -O /opt/aptos/data/genesis.blob https://devnet.aptoslabs.com/genesis.blob
wget -q -O ~/.aptos/waypoint.txt https://devnet.aptoslabs.com/waypoint.txt
wget -q -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64 && chmod +x /usr/local/bin/yq
wget -O seeds.yaml https://raw.githubusercontent.com/Pa1amar/aptos/main/seeds.yaml
WAYPOINT=$(cat ~/.aptos/waypoint.txt)
PRIVKEY=$(cat ~/.aptos/key/private-key.txt)
PEER=$(sed -n 2p ~/.aptos/config/peer-info.yaml | sed 's/.$//')
sed -i.bak -e "s/0:01234567890ABCDEFFEDCA098765421001234567890ABCDEFFEDCA0987654210/$WAYPOINT/" $HOME/.aptos/config/public_full_node.yaml
sed -i "s/genesis_file_location: .*/genesis_file_location: \"\/opt\/aptos\/data\/genesis.blob\"/" $HOME/.aptos/config/public_full_node.yaml
sleep 2 
sed -i "s/127.0.0.1/0.0.0.0/" $HOME/.aptos/config/public_full_node.yaml
sed -i '/network_id: "public"$/a\
      identity:\
        type: "from_config"\
        key: "'$PRIVKEY'"\
        peer_id: "'$PEER'"' $HOME/.aptos/config/public_full_node.yaml

/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/.aptos/config/public_full_node.yaml seeds.yaml

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
mv $HOME/aptosd.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable aptosd
sudo systemctl restart aptosd
