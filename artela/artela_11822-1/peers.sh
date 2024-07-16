#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop $PROJECT_BIN

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node peers & seeds... \e[0m" && sleep 1
echo ''
#peers, seeds
PEERS="b2481ce4c59d7f15aae95dc9b60f6b42472d0bb8@49.13.115.147:45656,bc0e0607cbdee58eb11a95ba37b1f61319997ab5@2.56.99.251:3456,eaf1212822b94c625daae017e35e4743466c9d1f@91.205.105.41:3456,63558a9bd71ed66fd833fd25eb3a1e2a73c824cc@108.181.54.37:3456,92d95c7133275573af25a2454283ebf26966b188@167.235.178.134:27856,22533e3edfbeabec006591c3afae06fd970a3556@35.229.139.209:3456,01a67d55aad78327b2b4a16934a50d74fb128823@38.242.255.76:3456,6bc725e9539cb04c117aa1ca526c1a0256f685b2@202.61.226.0:3456,0f5a4ad942c2bb222362e7cb92f11f0f474a0f6d@45.136.17.29:3456,2ea95fed41189059e4de1e678de34fe999dd6e7a@104.234.231.98:3456" && \
SEEDS="211536ab1414b5b9a2a759694902ea619b29c8b1@47.251.14.47:26656,d89e10d917f6f7472125aa4c060c05afa78a9d65@47.251.32.165:26656,bec6934fcddbac139bdecce19f81510cb5e02949@47.254.24.106:26656,32d0e4aec8d8a8e33273337e1821f2fe2309539a@47.88.58.36:26656,1bf5b73f1771ea84f9974b9f0015186f1daa4266@47.251.14.47:26656" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.artelad/config/config.toml


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart $PROJECT_BIN
