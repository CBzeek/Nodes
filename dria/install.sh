#!/bin/bash
# Variables
PROJECT_NAME="Dria"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

### Menu - Install Node
install_node() {
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  # sudo apt install iptables make gcc automake autoconf nvme-cli libssl-dev libleveldb-dev tar clang bsdmainutils ncdu openssl -y
  sudo apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev tar clang bsdmainutils ncdu unzip libleveldb-dev lz4 screen bc fail2ban -y
  # Docker
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-docker.sh')
  
  print_header "Installing $PROJECT_NAME node..."

  # Install Ollama
  curl -fsSL https://ollama.com/install.sh | sh

  # Install dria
  curl -fsSL https://dria.co/launcher | bash

  #wget https://raw.githubusercontent.com/firstbatchxyz/dkn-compute-node/master/.env.example
  #cp .env.example .env
  #mv .env $HOME/.dria/bin/

  node_start
 
}


### Menu - Node start
node_start() {
  print_header "$PROJECT_NAME node start..."
  cd $HOME/.dria/bin && $HOME/.dria/bin/dkn-compute-launcher start
}


### Menu - Node points
node_points() {
  print_header "$PROJECT_NAME node points..."
  cd $HOME/.dria/bin && $HOME/.dria/bin/dkn-compute-launcher points
}

### Menu - Node referrals
node_referrals() {
  print_header "$PROJECT_NAME node referrals..."
  cd $HOME/.dria/bin && $HOME/.dria/bin/dkn-compute-launcher referrals
}

### Menu - Update Node
node_update() {
  print_header "Updating $PROJECT_NAME node..."
  cd $HOME/.dria/bin && $HOME/.dria/bin/dkn-compute-launcher update
}


################
### Main #######
################
while true; do
  echo ""
  echo -e "${B_GREEN}###############################"
  echo -e "### ${B_YELLOW}$PROJECT_NAME Node Menu: ${B_GREEN}###"
  echo -e "${B_GREEN}###############################${NO_COLOR}"
  echo "1. Install Node"
  echo "2. Start Node"
  echo "3. Check Node point"
  echo "4. Working with referrals"
  echo "5. Update Node"  
  echo "5. Exit"
  
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node ;;
    2) node_start ;;
    3) node_points ;;
    4) node_referrals ;;
    5) node_update ;;
    e) break ;;
    *) echo -e "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
