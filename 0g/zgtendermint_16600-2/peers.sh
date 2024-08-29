#!/bin/bash
PROJECT_NAME="0G"


echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop ogd

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node peers & seeds... \e[0m" && sleep 1
echo ''
#peers, seeds
#PEERS="1d9f03967df0d6a88b4e987f014180283f707374@138.201.58.101:26656,e6da81745db1b31d14a29943dac6556940106bae@49.12.175.10:26656,ca25663bebd62843e6d8cbc46d122b4cb72fc85b@116.202.145.247:34656,d9d16e84dd5e2f9901bd3e1e49ac361505130a66@45.61.161.223:26656,0316bc537a47d0d24c24055e458265ba2f6dfa25@161.97.136.193:26656,62754143326144fbb6c720eecd6e2b8ee2ef3f83@37.27.120.15:26656,3fd40b1f2bc5d199cde746190c66d2f1cf34ffee@37.27.134.176:26656,67ada0c114dcadd5969983f1a9d2b2c0d765751c@2a01:13956,e91c2f3f2b7f982c15809e1fec184b903285d86b@37.60.249.59:26656,b9d070fd993fd06d7687ca869126dc8410f2bcbd@194.163.158.212:26646" && \
#SEEDS="59df4b3832446cd0f9c369da01f2aa5fe9647248@162.55.65.137:27956" && \
#sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml
PEERS="67aa1c29dbb3e4565393022a232d121fcc1541b2@149.50.124.194:12656,625e4d70d537e67e10ef7ad9b1383d99ce91d4d9@159.69.61.114:47656,9e106f4f219bf2636917e5df83f952ba7f39d1ae@149.50.111.174:12656,bbf3b5b0d00cc1b1a2b0cb89f1911b0015996afa@149.50.117.142:12656,91ff30ec437b85c41e9be29a4c4d8ca71fc90d92@185.70.190.197:26656,bac83a636b003495b2aa6bb123d1450c2ab1a364@65.108.75.179:47656,71f04e5de2c8556ac398b7fed209fc9ec511118c@100.42.178.1:12656,134936e818a18cbcf1530509bd9da4709fcf4ccf@149.50.125.246:12656,c9f121f4ad54b7299e622335d54932ca0c481700@185.215.164.12:26656,a6243a9cc3cb8f60fa80c682f93b9b30f7d1eb81@45.140.147.24:26656,9dcb40c51fae47292418a9fe085fcc94d4e9dc15@148.113.9.176:36656,80cdd1a027020305972265dd6eb0e757950cfd2e@94.130.132.219:26656,31dd96cf2cc0bca78e52985f3871566020f5260c@136.243.66.243:26656,ed852e5001c312f77e39c8102eb8892e88a75bff@89.117.52.6:12656,890a8fdf7ae003e381d4123c5fa70d6aa1125391@176.9.104.216:26656,053e69f6b4b368bb663e434290ec5b27264784d5@149.50.113.227:12656,e001ace2503b374ccab8d5c45c34a68c01162f95@37.60.245.114:12656,15f982a56340186a795b2aef981e6197530f6145@38.242.131.32:26656,564464f25dba093aa34844a750b89e3eb09c60b9@149.50.113.153:12656,0cc4b51df6e136aa1cca70abee11b1b49e3b5554@149.50.124.252:12656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.0gchain/config/config.toml

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd
