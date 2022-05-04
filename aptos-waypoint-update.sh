#!/bin/bash
cd $HOME

sudo systemctl stop aptosd

if [ -f $HOME/.aptos/key/waypoint.txt ]; then
    echo "Waypoint exists."
else 
    echo "Starting download waypoint..."
    wget -q -O ~/.aptos/waypoint.txt https://devnet.aptoslabs.com/waypoint.txt
    echo "Waypoint successfully downloaded."
    sleep 2
fi


echo "Starting update waypoint in config file..."
sed -i.bak 's@/full/path/to/waypoint.txt@/root/.aptos/waypoint.txt@g' $HOME/.aptos/config/public_full_node.yaml


echo "Waypoint successfully updated in config file."

sleep 2 

sudo systemctl restart aptosd

