#!/bin/bash
cd $HOME

PROJECT_NAME="PANIC by Simply VC"

#Create a Node Exporter user for running the exporter:
echo '#############################################################'
echo -e "\e[1m\e[32m### Create a Node Exporter user... \e[0m" && sleep 1
echo ''
sudo useradd --no-create-home --shell /bin/false node_exporter

#Download and extract the latest version of Node Exporter:
echo '#############################################################'
echo -e "\e[1m\e[32m### Downloading and install Node Exporter... \e[0m" && sleep 1
echo ''
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar -xzvf node_exporter-0.18.1.linux-amd64.tar.gz
sudo cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo rm node_exporter-0.18.1.linux-amd64 -rf
sudo nano /etc/systemd/system/node_exporter.service


#Creating config and start Node Exporter:
echo '#############################################################'
echo -e "\e[1m\e[32m### Creating config and start Node Exporter... \e[0m" && sleep 1
echo ''

echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

