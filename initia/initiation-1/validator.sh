#!/bin/bash
PROJECT_NAME="Initia"

echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node validator... \e[0m" && sleep 1
echo ''


#create validator
initiad tx mstaking create-validator \
  --amount=100000uinit \
  --pubkey=$(initiad tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=$CHAIN_ID \
  --identity="" \
  --website="" \
  --details="" \
  --security-contact="" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --from=$WALLET_NAME \
  --gas=auto \
  --gas-adjustment=1.4 \
  --fees=300000uinit \
  --yes
