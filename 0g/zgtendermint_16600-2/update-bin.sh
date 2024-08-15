#!/bin/bash
PROJECT_NAME="0G"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updateing $PROJECT_NAME node to version v0.3.1... \e[0m" && sleep 1
echo ""

if [ -n "$1" ]
then
    if [ $1 = "v0.2.3" ]
    then
        # build new binary
        cd && rm -rf 0g-chain
        git clone https://github.com/0glabs/0g-chain
        cd 0g-chain
        git checkout v0.2.3
        make install
#        git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
    fi

    if [ $1 = "v0.2.5" ]
    then
        # build new binary
        cd && rm -rf 0g-chain
        git clone https://github.com/0glabs/0g-chain
        cd 0g-chain
        git checkout v0.2.5
        make install
#        git clone -b v0.2.5 https://github.com/0glabs/0g-chain.git
    fi

else
    wget https://github.com/0glabs/0g-chain/releases/download/v0.3.1/0gchaind-linux-v0.3.1
    sudo chmod +x ./0gchaind-linux-v0.3.1
    sudo mv ./0gchaind-linux-v0.3.1 $(which 0gchaind)
#    git checkout v0.3.1
#    git clone -b v0.3.1 https://github.com/0glabs/0g-chain.git
#    git clone -b v0.3.0 https://github.com/0glabs/0g-chain.git
fi


#check Version
0gchaind version


#update Snapshot
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/snapshot.sh')


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl restart ogd

