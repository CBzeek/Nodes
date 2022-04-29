#!/bin/bash
cd $HOME
systemctl stop aptosd

if grep -Fxq 'state_sync:' $HOME/.aptos/config/public_full_node.yaml
then
    echo "State_sync parameter found, no need to update. "
else
    echo "State_sync parameter not found, update needed."
    echo "Start update..."
echo "
state_sync:
  state_sync_driver:
    enable_state_sync_v2: true" >> $HOME/.aptos/config/public_full_node.yaml
echo "Config successfully updated."
fi

systemctl restart aptosd

