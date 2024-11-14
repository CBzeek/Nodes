#!/bin/bash

read -p "Enter node moniker: " PRIVATE_KEY

PRIV=$PRIVATE_KEY yq -i '.chain.wallet.private_key = strenv(PRIV)' $HOME/config.json

