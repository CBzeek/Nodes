#!/bin/bash

#create validator
evmosd tx staking create-validator \
  --amount=1000000aevmos \
  --pubkey=$(evmosd tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=$CHAIN_ID \
  --commission-rate=0.10 \
  --commission-max-rate=0.20 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1000000 \
  --from=$WALLET_NAME \
  --identity="" \
  --website="" \
  --details="" \
  --gas=500000 --gas-prices=99999aevmos \
  -y
