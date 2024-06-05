#!/bin/bash
PROJECT_NAME="0G"

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Unjail $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
0gchaind tx slashing unjail --from $WALLET_NAME --chain-id zgtendermint_16600-1 --gas=auto --gas-adjustment=1.4 -y
