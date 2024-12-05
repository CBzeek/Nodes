#!/bin/bash
PROJECT_NAME="Gitopia"
PROJECT_BIN="gitopiad"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node validator... \e[0m" && sleep 1
echo ''
#create validator
$PROJECT_BIN tx staking create-validator \
--amount=1000000ulore \
--pubkey=$(gitopiad tendermint show-validator) \
--moniker="$MONIKER" \
--chain-id=$CHAIN_ID \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices 0.0012ulore \
--gas-adjustment=1.5 \
--gas=auto \
--yes 

#--identity="" \
#--website="" \
#--details="" \
