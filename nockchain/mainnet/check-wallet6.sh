#!/bin/bash
source $HOME/nockchain/.env

# Config file to store wallet address
#CONFIG_FILE="$HOME/.nockchain_wallet_config"

# Socket path - search more broadly for the socket
# First try common locations, then do a wider search if needed
SOCKET=""

# Try common locations first (faster)
for dir in /root/nockchain-miners /root/nockchain /root /var/run /tmp; do
    if [ -d "$dir" ]; then
        FOUND=$(find "$dir" -maxdepth 3 -name "nockchain_npc.sock" -o -name "*.sock" 2>/dev/null | grep -i nock | head -1)
        if [ -n "$FOUND" ]; then
            SOCKET="$FOUND"
            break
        fi
    fi
done

# If still not found, do a broader search from /root
if [ -z "$SOCKET" ]; then
    echo "Searching for nockchain socket..."
    SOCKET=$(find /root -name "*nock*.sock" -o -name "nockchain_npc.sock" 2>/dev/null | head -1)
fi

# If still not found, try even broader search
if [ -z "$SOCKET" ]; then
    SOCKET=$(find / -maxdepth 5 -name "*nock*.sock" -o -name "nockchain_npc.sock" 2>/dev/null | head -1)
fi

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check if socket exists
if [ -z "$SOCKET" ]; then
    echo -e "${RED}Error: No nockchain socket found!${NC}"
    echo "Make sure miners are running."
    echo ""
    echo "Searched in common locations. You can also specify the socket path manually:"
    echo "Example: SOCKET=/path/to/socket ./CheckWallet"
    exit 1
else
    echo -e "${GREEN}Found socket: $SOCKET${NC}"
    sleep 1
fi

# Check if config exists, if not prompt for wallet
#if [ ! -f "$CONFIG_FILE" ]; then
#    clear
#    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
#    echo -e "${CYAN}║                   FIRST TIME SETUP                               ║${NC}"
#    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
#    echo ""
#    echo -e "${YELLOW}Please enter your public key to monitor:${NC}"
#    echo ""
#    read -p "Public Key: " USER_WALLET
    
#    # Validate input
#    if [ -z "$USER_WALLET" ]; then
#        echo -e "${RED}Error: No wallet address provided!${NC}"
#        exit 1
#    fi
    
#    # Save to config
#    echo "$USER_WALLET" > "$CONFIG_FILE"
#    echo ""
#    echo -e "${GREEN}✓ Wallet saved! Starting monitor...${NC}"
#    sleep 2
#else
#    # Read wallet from config
#    USER_WALLET=$(cat "$CONFIG_FILE")
#fi

# Get pubkey
USER_WALLET=$MINING_PUBKEY

# Header
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                      NOCKCHAIN WALLET MONITOR                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Analyzing blockchain...${NC}"
echo -e "${BLUE}Your wallet:${NC} ${CYAN}${USER_WALLET:0:20}...${USER_WALLET: -20}${NC}"
echo ""

# Get wallet output with timeout protection
echo -e "${YELLOW}Fetching blockchain data...${NC}"
WALLET_OUTPUT=$(timeout 30 nockchain-wallet --nockchain-socket $SOCKET list-notes 2>&1 | tr -d '\0')

# Check if command succeeded
if [ $? -ne 0 ] || [ -z "$WALLET_OUTPUT" ]; then
    echo -e "${RED}Error: Failed to retrieve wallet data${NC}"
    exit 1
fi

# Extract wallet addresses from the multi-line pks format
# This handles the case where addresses span multiple lines
echo -e "${YELLOW}Processing wallet data...${NC}"

# Create temp file for processing
TEMP_FILE=$(mktemp)

# Extract all pks blocks and reconstruct wallet addresses
echo "$WALLET_OUTPUT" | awk '
    /pks=<\|/ {
        in_pks = 1
        wallet = ""
        # Get the part after pks=<|
        line = $0
        sub(/.*pks=<\|/, "", line)
        wallet = line
    }
    in_pks && !/pks=<\|/ {
        # Continue building the wallet address
        wallet = wallet $0
    }
    in_pks && /\|>/ {
        # End of wallet address
        sub(/\|>.*/, "", wallet)
        # Remove any whitespace
        gsub(/[[:space:]]/, "", wallet)
        if (length(wallet) > 50) {  # Valid wallet addresses are long
            print wallet
        }
        in_pks = 0
        wallet = ""
    }
' > "$TEMP_FILE"

# Get unique wallets and count occurrences
declare -A WALLET_COUNTS
while IFS= read -r wallet; do
    if [ -n "$wallet" ]; then
        ((WALLET_COUNTS["$wallet"]++))
    fi
done < "$TEMP_FILE"

# Clean up
rm -f "$TEMP_FILE"

# Check if any wallets were found
if [ ${#WALLET_COUNTS[@]} -eq 0 ]; then
    echo -e "${RED}No mined blocks found in wallet data.${NC}"
    echo ""
    echo -e "${BLUE}Your blocks:${NC} ${RED}0${NC}"
    echo ""
    echo -e "${YELLOW}Keep mining! 💪${NC}"
    #exit 0
    exit
fi

# Create sorted list of wallets by block count (divide by 2 as requested)
declare -A FINAL_COUNTS
for wallet in "${!WALLET_COUNTS[@]}"; do
    FINAL_COUNTS["$wallet"]=$((WALLET_COUNTS["$wallet"] / 2))
done

# Sort wallets by block count
SORTED_WALLETS=$(for wallet in "${!FINAL_COUNTS[@]}"; do
    echo "${FINAL_COUNTS[$wallet]}:$wallet"
done | sort -rn)

# Count total unique miners
UNIQUE_COUNT=${#FINAL_COUNTS[@]}

# Display results
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                    BLOCKCHAIN MINING SUMMARY                       ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Total unique miners:${NC} ${YELLOW}$UNIQUE_COUNT${NC}"
echo ""
echo -e "${PURPLE}MINER RANKINGS:${NC}"
echo -e "${PURPLE}───────────────${NC}"

# Process rankings
USER_BLOCKS=0
USER_RANK=0
RANK=1
TOTAL_BLOCKS=0

while IFS=: read -r blocks wallet; do
    # Skip if no blocks
    [ "$blocks" -eq 0 ] && continue
    
    TOTAL_BLOCKS=$((TOTAL_BLOCKS + blocks))
    
    # Check if it's user's wallet
    WALLET_TAG=""
    if [ "$wallet" = "$USER_WALLET" ]; then
        USER_BLOCKS=$blocks
        USER_RANK=$RANK
        WALLET_TAG=" ${GREEN}← YOU!${NC}"
    fi
    
    # Display wallet (truncated for readability)
    if [ ${#wallet} -gt 60 ]; then
        WALLET_SHORT="${wallet:0:20}...${wallet: -20}"
    else
        WALLET_SHORT="$wallet"
    fi
    
    echo -e "${YELLOW}#$RANK${NC} ${CYAN}$WALLET_SHORT${NC}"
    echo -e "   ${GREEN}Blocks mined: $blocks${NC}$WALLET_TAG"
    echo ""
    
    RANK=$((RANK + 1))
    
    # Limit display to top 20 for readability
    [ $RANK -gt 20 ] && [ $USER_RANK -ne 0 ] && break
done <<< "$SORTED_WALLETS"

# If user is not in top 20 but has mined blocks, show their position
if [ $USER_RANK -eq 0 ] && [ $USER_BLOCKS -gt 0 ]; then
    echo -e "   ${YELLOW}...${NC}"
    echo ""
    echo -e "${YELLOW}#$USER_RANK${NC} ${CYAN}${USER_WALLET:0:20}...${USER_WALLET: -20}${NC}"
    echo -e "   ${GREEN}Blocks mined: $USER_BLOCKS${NC} ${GREEN}← YOU!${NC}"
    echo ""
fi

# Summary
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                        YOUR STANDINGS                              ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

if [ $USER_BLOCKS -gt 0 ]; then
    echo -e "${BLUE}Your blocks:${NC} ${GREEN}$USER_BLOCKS 🎉${NC}"
    echo -e "${BLUE}Your rank:${NC} ${YELLOW}#$USER_RANK${NC} out of ${YELLOW}$UNIQUE_COUNT${NC} miners"
    
    # Calculate percentage
    if [ $TOTAL_BLOCKS -gt 0 ]; then
        PERCENTAGE=$(awk "BEGIN {printf \"%.1f\", ($USER_BLOCKS / $TOTAL_BLOCKS) * 100}")
        echo -e "${BLUE}Your share:${NC} ${YELLOW}$PERCENTAGE%${NC} of all blocks"
    fi
else
    echo -e "${BLUE}Your blocks:${NC} ${RED}0${NC}"
    echo -e "${YELLOW}You haven't mined any blocks yet. Keep mining! 💪${NC}"
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "Last checked: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Network stats
echo -e "${PURPLE}Network Stats:${NC}"
echo -e "  Total blocks mined: ${YELLOW}$TOTAL_BLOCKS${NC}"
if [ $UNIQUE_COUNT -gt 0 ]; then
    AVG_BLOCKS=$(awk "BEGIN {printf \"%.1f\", $TOTAL_BLOCKS / $UNIQUE_COUNT}")
    echo -e "  Average per miner: ${YELLOW}$AVG_BLOCKS${NC}"
fi

# Fun motivational messages
if [ $USER_BLOCKS -gt 0 ]; then
    echo ""
    if [ $USER_BLOCKS -ge 10 ]; then
        echo -e "${GREEN}🎊 🎊 🎊 AMAZING! YOU'RE A NOCKCHAIN LEGEND! 🎊 🎊 🎊${NC}"
    elif [ $USER_BLOCKS -ge 5 ]; then
        echo -e "${GREEN}🎉 🎉 GREAT JOB! YOU'RE EARNING SERIOUS NOCK! 🎉 🎉${NC}"
    else
        echo -e "${GREEN}🎊 CONGRATULATIONS! YOU'RE EARNING NOCK! 🎊${NC}"
    fi
fi

