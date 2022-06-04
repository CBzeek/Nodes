#!/bin/bash
cd $HOME

echo '### Stopping subspace service'
echo ''
sudo systemctl stop subspaced subspaced-farmer 

echo '### Erase chain data'
echo ''
subspace-farmer wipe
sleep 2
subspace-node purge-chain --chain gemini-1 -y
sleep 2

echo '### Starting subspace node service'
echo ''
sudo systemctl restart subspaced
sleep 4

echo '### Starting subspace farmer service'
echo ''
sudo systemctl restart subspaced-farmer


