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
PEERS="" && \
#SEEDS="c4d619f6088cb0b24b4ab43a0510bf9251ab5d7f@54.241.167.190:26656,44d11d4ba92a01b520923f51632d2450984d5886@54.176.175.48:26656,f2693dd86766b5bf8fd6ab87e2e970d564d20aff@54.193.250.204:26656,f878d40c538c8c23653a5b70f615f8dccec6fb9f@54.215.187.94:26656" && \
SEEDS="b44ff9e9eb4792bc233147dbe43f1709ad77ce43@80.65.211.223:26656,255360200854a97c65d8c1f2d7154c5dd5e54eb5@65.108.68.214:14256,feb0cc40a3009a16a62bb843c000974565107c4c@128.140.65.68:26656,b2dcd3248fc4104b37568d98495466b4a2074672@65.109.145.247:1020,89189bb79a36e051abacce5f2bc1a0e6382a5a5b@185.193.67.160:26656,2e2643b638496a5b948a1ecce0d79bdc9bcf64a6@91.105.131.140:26656,258861e4032177e6f0328aa7e2e38b0298510d6c@84.247.188.240:26656,f3c912cf5653e51ee94aaad0589a3d176d31a19d@157.90.0.102:31656,535ddcc917ab5ee6ddd2259875dac6018651da24@176.9.183.45:32656,a6076b5d78b9b37fd3488af51f2b9dcc6978f9e8@185.11.251.182:47656,6b72d01e9d09d00beac1a004281cfc10833019fe@38.242.138.151:26656,59fe20be127ea2431fcf004af16f101a62269b93@38.242.144.121:26656,2384a34d3bd0631eb299f1d48fd3b28f3bf05c13@84.247.179.51:26656,549cb67ff1eebbea462adb4fcafcd7e4e95008f5@107.172.211.152:26656,0a0b54852a271923277b03366a1f0a1dacbcd464@109.199.102.47:26656,38ae510d30cb048caf99cf87108ec21317a4063f@82.67.49.126:26656,710f94642675d82190d43d272a77dfeb1daaf940@5.9.61.237:19656,9a6a47bd79b3a1bdb27b8df0e6f2218968d56f67@158.220.88.106:26656,7a81280d611e4f67ac631347aaea5cdfbcede5b4@62.171.154.181:16656,a25dadd5cb8feb5ad88ea39ededce5e81f90c87b@5.75.253.119:26656,45cb154a020fff3f5583d0eda2499d78ea44aea7@213.199.44.68:26656,b4bb8314c40e943f1744b5cffa61e83cfbdc6391@84.247.171.3:26656" && \
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart ogd



