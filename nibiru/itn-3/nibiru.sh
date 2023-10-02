#!/bin/bash
PROJECT_NAME="nibid"

cd $HOME

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

NODE=NIBIRU
NODE_HOME=$HOME/.nibid
BRANCH=v0.21.10
GIT="https://github.com/NibiruChain/nibiru.git"
GIT_FOLDER=nibiru
BINARY=nibid
#GENESIS="https://snapshots.nodes.guru/nibiru/genesis.json"
#ADDRBOOK="https://snapshots.nodes.guru/nibiru/addrbook.json"
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

rm -rf $HOME/$GIT_FOLDER
git clone $GIT
cd $GIT_FOLDER && git checkout $BRANCH
make build
sudo mv $HOME/$GIT_FOLDER/build/$BINARY /usr/local/bin/ || exit
sleep 1
$BINARY init "$VALIDATOR" --chain-id $CHAIN_ID
sleep 1
nibid config keyring-backend test
seeds="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:13959,142142567b8a8ec79075ff3729e8e5b9eb2debb7@35.195.230.189:26656,766ca434a82fe30158845571130ee7106d52d0c2@34.140.226.56:26656"
sed -i 's|seeds =.*|seeds = "'$seeds'"|g' $NODE_HOME/config/config.toml
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
#PEERS="8e0e6c1583153282d07511d3ea13e53f6ce77b51@162.55.234.70:55356,4a81486786a7c744691dc500360efcdaf22f0840@141.94.174.11:26656,a4acc1fac7ce2446a808ac96429ba99a3900ec31@65.109.92.148:26656,c060180df8c01546c66d21ee307b09f700780f65@34.34.137.125:26656,afe1a8d392b2caaa02c51165dd2b37e0181dacf9@65.108.72.233:21656,2cbae8362c1953cbe7badac73dd547ae0854cb63@104.199.24.9:26656,274ada4dd44aea04f4d2c63d9cb7dae1b7df56f1@84.252.159.237:26656,7d443bfaec2780c72319ea7de03c09e0a9c9fbfc@78.46.103.246:26656,6a80ea45fb50b9635c183e2861b2dd9b6bd77736@65.109.92.235:29656,7e75b2249d088a4dfc3b33f386c316cb47366d2b@195.3.221.48:11656,fac29c5446afa4c44285394468172fe423d3a5f4@188.40.106.246:46656,7f618923c7e04061fc64e68cf0157464bf56e1bb@82.64.41.31:26656,0f03a30baa17cd3f50da057e5b383c9786a07110@135.181.239.35:33656,d092162ed9c61c9921842ff1fb221168c68d4872@65.109.65.248:27656,a4f87637aae554b575621cd5eab230f9c46e68cc@65.108.75.107:19656,41bb02a3e2b60761f07ddcc7138bcf17b6a1eda9@65.109.90.171:27656,c709cad9e11b315644fe8f1d2e90c03c5cba685c@79.168.171.177:26656,d3754b2d59c7390bac4e2160628cff159c154a62@116.202.227.117:13956,7a0d35b3cb1eda647d57c699c3e847d4e41d890d@65.108.8.28:36656,0269836fc9a3db6b34828c57d9130b62cbbf59f2@134.249.103.215:26656,23ef382358cad4b07cd2f8edd746f6877f2db455@158.220.106.231:26656,c068c45ef902b35dd9ea4f6b82405e6ab2dfc730@65.109.92.241:11036,2edf3849e5455aafd5900c203570f9365e91b5f0@142.132.248.253:52657,9a3d3357c38dc553e0fd2e89f9d2213016751fb5@176.9.110.12:36656,965dfc1e9fd7811e469ceb5682a354c0f230a651@45.10.154.131:13956,e8e173564d8b7383d6306e1f1d0ed01e2fc4d507@34.77.52.8:26656,02ddb201a1ceca73e43647d53a82a0342a6532ab@148.251.90.138:11656,0ef61e7d37858885aba8c692a2030550fee17479@213.239.207.175:45656,766ca434a82fe30158845571130ee7106d52d0c2@34.79.238.239:26656,96e26da24f2b70b1314301263477e1a3c8a159be@65.109.26.21:11656,71e0287833781b837adc2d1ae6d886592f64fa81@185.16.39.206:13956,a3a1c995a0fc7996218c8b3c56354738e8670125@35.205.157.12:26656,e590d1519c5b4b103eaa17a8b027c89a40db45a8@95.111.233.163:13956,5cd43fa2f6910e9aec268d347fb7d9797616a462@135.181.220.61:17656,c72f479008dee06bf6f5a288cc84c10e6003f14b@65.21.141.82:61656,8d2735274fddfd6f38585f94b748a91280086def@62.171.167.76:26656,d7a4f45965c0f83fe07627a3dbab6ed75b81f32e@154.26.156.174:16156,111dd6b7ac9d0f80d7a04ce212267ce95cb913e9@195.201.76.69:26656,7f8bd4eaf6b9b213fd7b89ceefc517bcaa517d24@5.9.147.22:22656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:13956,ed625f0c5ce3b6e38ea47ce3dff735842935613a@35.196.60.241:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13956,faf332f0f0e56398314935a1b72de2e0a70ddd82@91.107.214.162:26656,6868eabdf1458d74b9be204bc8b2afa7c14ca7e2@212.227.233.231:27656,ea516128d449c0a6a3c042a32020c98203b7b501@188.166.29.139:26656,52eecc8b39cb5a966b66a61fc747809e2de57a48@65.109.103.140:39656,b316ff6b5a0715732fa02f990db94aef39e758b3@148.251.88.145:34656,081ff903784a3f1b69522d6167c998c88c91ce61@65.108.13.154:27656,f276229191ceb5b7409f4278a76e61298b2f0862@195.64.235.189:26656"
#sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $NODE_HOME/config/config.toml
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025unibi\"/" $NODE_HOME/config/app.toml

#wget $GENESIS -O $NODE_HOME/config/genesis.json
curl -s https://rpc.itn-3.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json

$BINARY tendermint unsafe-reset-all

#curl -L https://snapshots.nodes.guru/nibiru/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $NODE_HOME
#wget $ADDRBOOK -O $NODE_HOME/config/addrbook.json

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

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl restart $BINARY
