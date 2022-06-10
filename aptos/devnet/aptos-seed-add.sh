#!/bin/bash


echo 'Stopping aptos node...'
sudo systemctl stop aptosd
echo 'Done'
sleep 2

cd $HOME

echo 'Backup configuration files...'
cp -r $HOME/.aptos $HOME/aptos_backup_$(date +%F--%R)
echo 'Done'
sleep 2


echo 'Check for yq...'
if [ -f /usr/local/bin/yq ]; then
    echo 'yq installed'
else 
    echo 'yq not stalled, starting install...'
    wget -q -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64 && chmod +x /usr/local/bin/yq
    echo 'Done'
fi

echo 'Add seeds to configuration file...'
wget -O $HOME/seeds.yaml https://github.com/CBzeek/Nodes/raw/main/aptos/devnet/seeds.yaml
/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/.aptos/config/public_full_node.yaml $HOME/seeds.yaml
echo 'Done'
sleep 2

echo 'Starting aptos node...'
sudo systemctl restart aptosd
echo 'Done'
sleep 2

