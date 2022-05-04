#!/bin/bash
cd $HOME

sudo mkdir -p /opt/aptos/etc/

sudo systemctl stop aptosd

if [ -f /opt/aptos/etc/genesis.blob ]; then
    echo "Genesis exists."
else 
    echo "Starting download Genesis..."
    wget -q -O /opt/aptos/etc/genesis.blob https://devnet.aptoslabs.com/genesis.blob
    echo "Genesis successfully downloaded."
    sleep 2
fi

if [ -f /opt/aptos/etc/waypoint.txt ]; then
    echo "Waypoint exists."
else 
    echo "Starting download Waypoint..."
    wget -q -O /opt/aptos/etc/waypoint.txt https://devnet.aptoslabs.com/waypoint.txt
    echo "Waypoint successfully downloaded."
    sleep 2
fi

echo "Starting update Genesis and Waypoint in config file..."
sed -i "s/genesis_file_location: .*/genesis_file_location: \"\/opt\/aptos\/etc\/genesis.blob\"/" $HOME/.aptos/config/public_full_node.yaml
sed -i "s/from_file: .*/from_file: \"\/opt\/aptos\/etc\/waypoint.txt\"/" $HOME/.aptos/config/public_full_node.yaml

echo "Genesis and Waypoint successfully updated in config file."

sleep 2 

sudo systemctl restart aptosd

