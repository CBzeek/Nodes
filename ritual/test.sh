#!/bin/bash

read -p "Enter node moniker: " PRIVATE_KEY

yq -i '.chain.wallet.private_key = strenv(PRIVATE_KEY)' $HOME/config.json

