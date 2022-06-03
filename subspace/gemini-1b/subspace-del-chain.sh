#!/bin/bash
cd $HOME
sudo systemctl stop subspaced
sudo systemctl stop subspaced-farmer

subspace-farmer wipe
subspace-node purge-chain --chain gemini-1 -y > /dev/null 2>&1

sudo systemctl restart subspaced
sudo systemctl restart subspaced-farmer
