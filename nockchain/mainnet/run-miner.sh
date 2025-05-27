#!/bin/bash
# Variables
PROJECT_NAME="Nockchain"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

source $HOME/nockchain/.env

RUST_BACKTRACE=1

export RUST_LOG
export MINIMAL_LOG_FORMAT
export MINING_PUBKEY
export RUST_BACKTRACE

cd $HOME/nockchain

if [ -n "$1" ]
then
    # Run additional miner
    print_header "$PROJECT_NAME additional miner $1 start..."
    mkdir -p miner-node$1
    cd miner-node$1
    rm -f nockchain.sock
    nockchain --npc-socket nockchain.sock --mining-pubkey ${MINING_PUBKEY} --mine
else
    # Run main miner
    print_header "$PROJECT_NAME main miner start..."
    mkdir -p miner-node 
    cd miner-node 
    rm -f nockchain.sock 
    nockchain --npc-socket nockchain.sock --mining-pubkey ${MINING_PUBKEY} --mine
fi


