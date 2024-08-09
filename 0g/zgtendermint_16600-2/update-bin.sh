#!/bin/bash
PROJECT_NAME="0G"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updateing $PROJECT_NAME node to version v0.3.0... \e[0m" && sleep 1
echo ""
# build new binary
cd && rm -rf 0g-chain

if [ -n "$1" ]
then
    if [ $1 = "v0.2.3" ]
    then
        git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
    fi

    if [ $1 = "v0.2.5" ]
    then
        git clone -b v0.2.5 https://github.com/0glabs/0g-chain.git
    fi

else
    git clone -b v0.3.0 https://github.com/0glabs/0g-chain.git
fi


cd 0g-chain
make install
0gchaind version


echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restarting $PROJECT_NAME node... \e[0m" && sleep 1
echo ""
#start node
sudo systemctl restart ogd

