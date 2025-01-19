#!/bin/bash
# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

# Variables
PROJECT_NAME="Fiamma"
PROJECT_DIR=".fiamma"

echo ''
echo -e "${B_GREEN}"
echo -e "###########################################################################################"
echo -e "### $PROJECT_NAME node height checker..."
echo -e "${NO_COLOR}"
echo ''

RPC_PORT=$(grep -m 1 -oP '^laddr = "\K[^"]+' "$HOME/$PROJECT_DIR/config/config.toml" | cut -d ':' -f 3)
while true; do
  NODE_HEIGHT=$(curl -s localhost:$RPC_PORT/status | jq -r '.result.sync_info.latest_block_height')
  RPC_HEIGHT=$(curl -s https://testnet-rpc.fiammachain.io/status | jq -r '.result.sync_info.latest_block_height')

  if ! [[ "$NODE_HEIGHT" =~ ^[0-9]+$ ]] || ! [[ "$RPC_HEIGHT" =~ ^[0-9]+$ ]]; then
    echo -e "${B_RED}"
    echo -e "Error: Invalid block height data. Retrying..."
    echo -e "${NO_COLOR}"
    sleep 5
    continue
  fi

  BLOCKS_LEFT=$((RPC_HEIGHT - NODE_HEIGHT))
  if [ "$BLOCKS_LEFT" -lt 0 ]; then
    BLOCKS_LEFT=0
  fi

  echo -e "Node Height: ${B_GREEN}$NODE_HEIGHT${NO_COLOR} | RPC Height: ${B_YELLOW}$RPC_HEIGHT${NO_COLOR} | Blocks Left: ${B_RED}$BLOCKS_LEFT${NO_COLOR}"

  sleep 5
done
