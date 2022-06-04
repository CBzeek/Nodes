#!/bin/bash
cd $HOME
sudo systemctl stop subspaced
sudo systemctl stop subspaced-farmer

subspace-farmer wipe
sleep 2
subspace-node purge-chain --chain gemini-1 -y > /dev/null 2>&1
sleep 2

sudo systemctl restart subspaced
sleep 2
sudo systemctl restart subspaced-farmer
sleep 2
