#!/bin/bash
PROJECT_NAME="0G"


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop ogd

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node peers & seeds... \e[0m" && sleep 1
echo ''
#peers, seeds
PEERS="1d9f03967df0d6a88b4e987f014180283f707374@138.201.58.101:26656,e6da81745db1b31d14a29943dac6556940106bae@49.12.175.10:26656,ca25663bebd62843e6d8cbc46d122b4cb72fc85b@116.202.145.247:34656,d9d16e84dd5e2f9901bd3e1e49ac361505130a66@45.61.161.223:26656,0316bc537a47d0d24c24055e458265ba2f6dfa25@161.97.136.193:26656,62754143326144fbb6c720eecd6e2b8ee2ef3f83@37.27.120.15:26656,3fd40b1f2bc5d199cde746190c66d2f1cf34ffee@37.27.134.176:26656,67ada0c114dcadd5969983f1a9d2b2c0d765751c@2a01:13956,e91c2f3f2b7f982c15809e1fec184b903285d86b@37.60.249.59:26656,b9d070fd993fd06d7687ca869126dc8410f2bcbd@194.163.158.212:26646" && \
SEEDS="59df4b3832446cd0f9c369da01f2aa5fe9647248@162.55.65.137:27956" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd
