#!/bin/bash
PROJECT_NAME="0G"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node peers... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/peers.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node bin... \e[0m" && sleep 1
echo ''
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/update-bin.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Update $PROJECT_NAME node snapshot... \e[0m" && sleep 1
echo ""
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/snapshot.sh')



echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Show $PROJECT_NAME node logs... \e[0m" && sleep 1
echo ""
tail -f -n 100 $HOME/.0gchain/log/chain.log | grep height --color

