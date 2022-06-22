#!/bin/bash
cd $HOME

echo '### Stopping subspace service'
echo ''
sudo systemctl stop subspaced subspaced-farmer 

echo '### Download new Subspace release'
echo ''
wget -O subspace-node https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-18
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-18
chmod +x subspace-node subspace-farmer
mv subspace-node subspace-farmer /usr/local/bin/

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
