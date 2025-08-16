#!/bin/bash

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

if [ -n "$1" ]
then
    VER="$1"
else
    echo -e "${B_RED}"
    echo -e "!!! language version not specified"
    echo -e "${NO_COLOR}"
fi

# Install go
print_header "Installing Go language version $VER to server..."

wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
go version
