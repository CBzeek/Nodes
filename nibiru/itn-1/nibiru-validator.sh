#!/bin/bash
PROJECT_NAME="nibid"

cd $HOME

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME validator... \e[0m" && sleep 1
echo ''
nibid tx staking create-validator \
--amount=1000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker="$VALIDATOR" \
--chain-id=nibiru-itn-1 \
--commission-rate="0.1" \
--commission-max-rate="0.10" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--fees=10000unibi \
--from=wallet \
-y
