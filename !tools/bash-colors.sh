#!/bin/bash

# Colors
B_GREEN='\033[1;32m'       # Bold Green
B_YELLOW='\033[1;33m'      # Yellow
B_RED='\033[1;31m'         # Bold Red
NO_COLOR='\033[0m'         # Color Reset


print_header() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### ${B_YELLOW}$1"
  echo -e "${B_GREEN}###########################################################################################"  
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
}

# YELLOW="\e[33m"
# CYAN="\e[36m"
# BLUE="\e[34m"
# GREEN="\e[32m"
# MAGENTA='\033[1;35m'
# RED="\e[31m"
# PINK="\e[35m"
# NC="\e[0m"

# Import Colors
# source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

#echo ""
#echo -e "${B_GREEN}"
#echo -e "${B_RED}"
#echo -e "${B_YELLOW}"
#echo -e "${NO_COLOR}"
#echo "" && sleep 2
