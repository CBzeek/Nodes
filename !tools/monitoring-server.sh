#!/bin/bash


# Update and dependencies
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')

# Insall Node Exporter
source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/monitoring-node.sh')


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install Prometheus to server... \e[0m" && sleep 1
echo ''
cd $HOME
wget https://github.com/prometheus/prometheus/releases/download/v2.55.0/prometheus-2.55.0.linux-amd64.tar.gz
tar xvf prometheus-2.55.0.linux-amd64.tar.gz
rm prometheus-2.55.0.linux-amd64.tar.gz
mv prometheus-2.55.0.linux-amd64 prometheus
chmod +x $HOME/prometheus/prometheus


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Create prometheusd service... \e[0m" && sleep 1
echo ''
sudo tee /etc/systemd/system/prometheusd.service > /dev/null <<EOF
[Unit]
Description=prometheus
After=network-online.target
[Service]
User=$USER
ExecStart=$HOME/prometheus/prometheus \
--config.file="$HOME/prometheus/prometheus.yml"
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart prometheusd service... \e[0m" && sleep 1
echo ''
sudo systemctl daemon-reload
sudo systemctl enable prometheusd
sudo systemctl restart prometheusd


echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Install Grafana to server... \e[0m" && sleep 1
echo ''
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.3.0_amd64.deb
sudo dpkg -i grafana-enterprise_11.3.0_amd64.deb
rm grafana-enterprise_11.3.0_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl restart grafana-server
