#!/bin/bash
cd $HOME

echo '### Stopping subspace service'
echo ''
sudo systemctl stop subspaced subspaced-farmer 

echo '### Starting subspace node service'
echo ''
sudo systemctl restart subspaced
sleep 10

echo '### Starting subspace farmer service'
echo ''
sudo systemctl restart subspaced-farmer
