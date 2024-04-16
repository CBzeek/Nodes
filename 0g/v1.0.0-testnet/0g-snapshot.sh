#!/bin/bash

wget https://rpc-zero-gravity-testnet.trusted-point.com/latest_snapshot.tar.lz4

sudo systemctl stop ogd

cp $HOME/.evmosd/data/priv_validator_state.json $HOME/.evmosd/priv_validator_state.json.backup

evmosd tendermint unsafe-reset-all --home $HOME/.evmosd --keep-addr-book

lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.evmosd

mv $HOME/.evmosd/priv_validator_state.json.backup $HOME/.evmosd/data/priv_validator_state.json

sudo systemctl restart ogd && sudo journalctl -u ogd -f -o cat

