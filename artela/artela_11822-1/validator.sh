#!/bin/bash
PROJECT_NAME="Artela"
PROJECT_BIN="artelad"

echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node validator... \e[0m" && sleep 1
echo ''
#create validator
artelad tx staking create-validator \
  --amount=1000000uart \
  --pubkey=$(artelad tendermint show-validator) \
  --moniker="$MONIKER" \
  --chain-id=$CHAIN_ID \
  --commission-rate=0.10 \
  --commission-max-rate=0.20 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1 \
  --from=$WALLET_NAME \
  --identity="" \
  --website="" \
  --details="" \
  --gas=auto \
  --gas-adjustment=1.5 \
  --yes
