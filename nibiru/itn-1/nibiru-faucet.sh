#!/bin/bash
PROJECT_NAME="nibid"

cd $HOME

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Request tokens from $PROJECT_NAME faucet... \e[0m" && sleep 1
echo ''
FAUCET_URL="https://faucet.itn-1.nibiru.fi/"
ADDR=$1 # your address 
curl -X POST -d '{"address": "'"$ADDR"'", "coins": ["11000000unibi","100000000unusd","100000000uusdt"]}' $FAUCET_URL
