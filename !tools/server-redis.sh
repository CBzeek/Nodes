#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

cd $HOME

#Install Software
print_header "Install dependencies..."
sudo apt update

#Install Redis
print_header "Install Redis to server..."
sudo apt install mc redis-server -y

#Get IP
#read -p "Enter IP address: " IP_ADDRESS

#Get PASSWORD
#read -p "Enter password: " PASSWORD

#Change IP addres in /etc/redis/redis.conf
#bind 127.0.0.1 -::1

#Change PASSWORD in /etc/redis/redis.conf
#requirepass $PASSWORD

# Restart
#sudo systemctl restart redis
#sudo systemctl status redis

#Test Connection
#redis-cli -h $IP_ADDRESS -p 6379 -a $PASSWORD

