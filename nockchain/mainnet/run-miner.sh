#!/bin/bash
# Variables
PROJECT_NAME="Nockchain"



while true
do
    # Logo
    source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')
    
    # Additional pause
    sleep 2

    # Import Colors
    source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')
    
    source $HOME/nockchain/.env
    
    RUST_BACKTRACE=1
    
    export RUST_LOG
    export MINIMAL_LOG_FORMAT
    export MINING_PUBKEY
    export RUST_BACKTRACE
    
    cd $HOME/nockchain

    sudo sysctl -w vm.overcommit_memory=1

    if [ -n "$1" ]
    then
        # Run additional miner
        print_header "$PROJECT_NAME additional miner $1 start..."
        DIR=$HOME/nockchain/miner-node$1
        if [ ! -d $DIR ]; then
            # Directory NOT exists."
            echo "Directory $DIR NOT exists."
            mkdir -p $DIR/.data.nockchain
            cp -r $HOME/nockchain/miner-node/.data.nockchain/checkpoints* $DIR/.data.nockchain 
        fi

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
   
done

