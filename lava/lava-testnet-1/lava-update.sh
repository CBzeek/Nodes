#!/bin/bash
cd $HOME

PROJECT_NAME="lavad"

echo ''
echo -e "\e[1m\e[32m### Stopping ${PROJECT_NAME} service... \e[0m" && sleep 1
echo ''
sudo systemctl stop ${PROJECT_NAME}


echo ''
echo -e "\e[1m\e[32m### Updating ${PROJECT_NAME} to version v0.4.3... \e[0m" && sleep 1
echo ''
rm -rf $(which ${PROJECT_NAME})
source ~/.bash_profile

cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v0.4.3
make install
${PROJECT_NAME} version

sudo tee /etc/systemd/system/lavad.service > /dev/null << EOF
[Unit]
Description=Lava Network Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF


echo ''
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl daemon-reload
sudo systemctl start ${PROJECT_NAME}
