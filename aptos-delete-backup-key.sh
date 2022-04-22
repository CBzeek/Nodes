#!/bin/bash

cd $HOME

systemctl stop aptosd

mkdir ~/.aptos-backup-key/
cp ~/.aptos/key/private-key.txt ~/.aptos-backup-key/private-key.txt

rm -rf ~/aptos-core
rm -rf ~/.aptos/config/
rm -rf ~/.aptos/waypoint.txt
rm -rf /opt/aptos/
