#!/bin/bash
PROJECT_NAME="Initia"


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl stop initiad

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME node peers & seeds... \e[0m" && sleep 1
echo ''
#peers, seeds
PEERS="0ecdbae53da02eec6f7a8097022218821b724347@138.201.129.214:53456,0f80116882d7732d52abaf3e6c007f3218665635@185.16.39.138:53456,7f7fcc6e7ce3287ea6bd7a7c6cb8119c97d4697d@49.13.25.33:26656,95071a39cab00a428c532c682c6cd05618f5a9f4@46.4.80.48:25756,c7148b9dd296ff12723ba6301c91f8376e5490bf@162.55.47.206:27656,fbba8098f52c272c3319061826bced9143b6efc3@181.214.231.175:26656,bbaa823545488a7e8785d891b2f5f49d648bb6f5@181.214.231.170:26656,793a86268d83e78f596fbb918d6d82d6bcb8e3f6@181.214.231.173:26656,a12dc32421d3aabafd52239d774c27af6fda494d@88.99.164.202:26656,aaa63e5685e1e3362e2fb271adea05ea74a965c0@179.61.251.10:26656,2ed75640d6a37e33da583385d12261dea2975338@141.94.194.57:36042,548e26b95b895efc964b08a6b2e991c6d5a6791d@142.132.151.35:15674,917d28e3c7234763788aaa9656a683d5ffac2f3b@179.61.251.153:26656,e043d748f85f4b001f19002fe87ca5021a79018a@181.214.99.209:26656,4f76c615791a4efd8ae7bd4b243606bb7536d38e@181.214.231.152:26656,cbb8e26a938d8e9faeb440c36fff0a0c31d958fe@181.214.99.207:26656,3b944bcae9db0b88d8419adde8e26188a6a5ef5d@65.109.59.22:25756,471a41ce4a87b295216b7ce03518a3f4124f1a85@144.91.72.156:53456,49735e6f020a9efcc181e90a95f78861f6d1cdf9@95.216.172.13:27656,8c21fc86e4a89f1d63ee7959e9f10e7d9aeeafd4@38.242.247.136:53456,cd69bcb00a6ecc1ba2b4a3465de4d4dd3e0a3db1@65.108.231.124:51656,4426384d44d2ad79037eab349ed92f8c40503cb8@149.50.108.14:27656,5c5441d80d686129b9c3fe62830ee5fc732bdce4@138.201.196.246:26656"
sed -i.bak -e "s/^persistent_peers =./persistent_peers = "$peers"/" ~/.initia/config/config.toml

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
sudo systemctl restart initiad
