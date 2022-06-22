#!/bin/bash
cd $HOME

echo '### Stopping subspace service'
echo ''
sudo systemctl stop subspaced subspaced-farmer 

echo '### Install additional packages'
echo ''
sudo apt install -y ocl-icd-opencl-dev
sudo apt install -y intel-opencl-icd
sudo apt install -y libgomp1

echo '### Restart systemd'
echo ''
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer

echo '### Starting subspace node service'
echo ''
sudo systemctl restart subspaced
sleep 10

echo '### Starting subspace farmer service'
echo ''
sudo systemctl restart subspaced-farmer
