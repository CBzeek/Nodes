#!/bin/bash
cd $HOME

echo '### Stopping subspace service'
echo ''
#sudo systemctl stop subspaced
#sudo systemctl stop subspaced-farmer 
sudo systemctl stop subspaced subspaced-farmer 

echo '### Erase chain data'
echo ''
subspace-farmer wipe
sleep 2
#subspace-node purge-chain --chain gemini-1 -y > /dev/null 2>&1
subspace-node purge-chain --chain gemini-1 -y
sleep 2

echo '### Starting subspace service'
echo ''
sudo systemctl restart subspaced subspaced-farmer
sleep 2

