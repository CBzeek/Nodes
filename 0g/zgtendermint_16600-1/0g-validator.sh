#!/bin/bash

#create validator
0gchaind tx staking create-validator \
  --amount=100000ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker="$MONIKER" \
  --chain-id=$CHAIN_ID \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --from=$WALLET_NAME \
  --identity="" \
  --website="" \
  --details="" \
  --gas=auto \
  --gas-adjustment=1.4
  -y
