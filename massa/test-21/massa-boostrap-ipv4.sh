#!/bin/bash
PROJECT_NAME="massa"

cd $HOME

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Checking $PROJECT_NAME node boostrap option... \e[0m" && sleep 1
echo ''
if grep -rq 'bootstrap_protocol' $HOME/massa/massa-node/config/config.toml
then
    echo "bootstrap_protocol parameter found, no need to update..."
    echo ''
else
    echo '###########################################################################################'
    echo -e "\e[1m\e[32m### Stoping $PROJECT_NAME node... \e[0m" && sleep 1
    echo ''
#    sudo systemctl stop massad
    cp $HOME/massa/massa-node/config/config.toml $HOME/massa/massa-node/config/config.toml.backup
    
    echo "bootstrap_protocol parameter not found, starting update..."
    echo ''

sudo tee -a $HOME/massa/massa-node/config/config.toml > /dev/null <<EOF

[bootstrap]
# force the bootstrap protocol to use: "IPv4", "IPv6", or "Both". Defaults to using both protocols.
bootstrap_protocol = "IPv4"

EOF

echo "Config successfully updated..."
echo ''

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Starting $PROJECT_NAME node... \e[0m" && sleep 1
echo ''
#sudo systemctl restart massad
fi






