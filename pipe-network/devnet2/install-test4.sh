#!/bin/bash
# Variables
PROJECT_NAME="Pipe Network"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

print_header() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### {B_YELLOW}$1"
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
}


### Menu - Install Node
install_node() {
  # Install denepdencies
  source <(wget -O- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/!tools/server-prepare.sh')
  sudo apt install gnupg lsb-release apt-transport-https ca-certificates lsof -y

  if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
  fi
  
  if ! command -v docker-compose &>/dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi

  print_header "Installing $PROJECT_NAME node..."
  docker stop $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
  docker rm $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null

  read -p "Enter your HASH: " HASH
  echo ""

  docker run --network=host -d -v "$HOME/.titanedge:$HOME/.titanedge" nezha123/titan-edge
  sleep 10

  docker run --rm -it -v "$HOME/.titanedge:$HOME/.titanedge" nezha123/titan-edge bind --hash="$HASH" https://api-test1.container1.titannet.io/api/v2/device/binding
}


### Menu - Docker logs
docker_logs() {
  print_header "$PROJECT_NAME node logs..."
  # docker logs -f $(docker ps -aq --filter "ancestor=nezha123/titan-edge")
}


### Menu - Restart Node
restart_node() {
  print_header "Restarting $PROJECT_NAME node..."
  # docker restart $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
}


### Menu - Stop Node
stop_node() {
  print_header "Stopping $PROJECT_NAME node..."
  # docker stop $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
}


### Menu - Delete Node
delete_node() {
  echo ""
}


################
### Main #######
################
while true; do
  echo ""
  echo -e "${B_GREEN}###############################"
  echo -e "### ${B_YELLOW}$PROJECT_NAME Node Menu: ${B_GREEN}###"
  echo -e "${B_GREEN}###############################"
  echo "1. Install Node"
  echo "2. Check Node logs"
  echo "3. Restart Node"
  echo "4. Stop Node"
  echo "5. Delete Node"
  echo "6. Exit"
  echo -e "${B_YELLOW}"
  read -p "Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node ;;
    2) node_logs ;;
    3) restart_node ;;
    4) stop_node ;;
    5) delete_node ;;
    6) break ;;
    *) echo "${B_RED}Invalid option. Try again.${NO_COLOR}" ;;
  esac
done
