#!/bin/bash
# Variables
PROJECT_NAME="Titan Network"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')

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

  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### Installing $PROJECT_NAME node..."
  echo -e "${NO_COLOR}" && sleep 1
  echo ""

  docker stop $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
  docker rm $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null

  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "${NO_COLOR}" && sleep 1
  read -p "Enter your HASH: " HASH

  docker run --network=host -d -v "$HOME/.titanedge:$HOME/.titanedge" nezha123/titan-edge
  sleep 10

  docker run --rm -it -v "$HOME/.titanedge:$HOME/.titanedge" nezha123/titan-edge bind --hash="$HASH" https://api-test1.container1.titannet.io/api/v2/device/binding
}


### Menu - Docker logs
docker_logs() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### $PROJECT_NAME node logs..."
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
  docker logs $(docker ps -aq --filter "ancestor=nezha123/titan-edge")
}


### Menu - Restart Node
restart_node() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### Restarting $PROJECT_NAME node..."
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
  docker restart $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
}


### Menu - Stop Node
stop_node() {
  echo ""
  echo -e "${B_GREEN}"
  echo -e "###########################################################################################"
  echo -e "### Stopping $PROJECT_NAME node..."
  echo -e "${NO_COLOR}" && sleep 1
  echo ""
  docker stop $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
}


### Menu - Delete Node
delete_node() {
  read -p "Do you really want to delete your node? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  
  docker stop $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
  docker rm $(docker ps -aq --filter "ancestor=nezha123/titan-edge") &>/dev/null
  sudo rm -rf "$HOME/.titanedge"
}


################
### Main #######
################
while true; do
  echo ""
  echo -e "${B_GREEN}"
  echo -e "########################"
  echo -e "${B_YELLOW}Titan Network Node Menu:"
  echo -e "${B_GREEN}########################"
  echo "1. Install Node"
  echo "2. Check Node logs"
  echo "3. Restart Node"
  echo "4. Stop Node"
  echo "5. Delete Node"
  echo "6. Exit"
  echo ""
  read -p "${B_YELLOW}Choose an option: " choice
  echo -e "${NO_COLOR}"

  case $choice in
    1) install_node ;;
    2) docker_logs ;;
    3) restart_node ;;
    4) stop_node ;;
    5) delete_node ;;
    6) exit 0 ;;
    *) echo "Неверный пункт. Повторите ввод." ;;
  esac
done






