#!/bin/bash
cd $HOME

echo '### Stopping sui service'
echo ''
systemctl stop suid

echo ''
echo '### Sui db clear'
echo ''
rm -rf /var/sui/db/*

echo ''
echo '### Sui genesis update'
echo ''
wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

echo ''
echo '### Starting sui node service'
echo ''
systemctl restart suid
