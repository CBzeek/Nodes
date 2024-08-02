#!/bin/bash
PROJECT_NAME="Nubit"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Adding $PROJECT_NAME node localhost settings... \e[0m" && sleep 1
echo ""
# Add "localhost" to /etc/hosts
sed -i 's/127.0.0.1 /127.0.0.1 localhost /' /etc/hosts
