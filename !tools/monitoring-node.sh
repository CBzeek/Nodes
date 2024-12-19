#!/bin/bash

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')


# Update and dependencies
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install Node Exporter to server... \e[0m" && sleep 1
echo ''
cd $HOME
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvf node_exporter-1.8.2.linux-amd64.tar.gz     
rm node_exporter-1.8.2.linux-amd64.tar.gz     
sudo mv node_exporter-1.8.2.linux-amd64 node_exporter
chmod +x $HOME/node_exporter/node_exporter
mv $HOME/node_exporter/node_exporter /usr/bin
rm -Rvf $HOME/node_exporter/


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Create exporterd service... \e[0m" && sleep 1
echo ''
sudo tee /etc/systemd/system/exporterd.service > /dev/null <<EOF
[Unit]
Description=node_exporter
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/node_exporter
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart exporterd service... \e[0m" && sleep 1
echo ''
sudo systemctl daemon-reload && \
sudo systemctl enable exporterd && \
sudo systemctl restart exporterd
