#!/bin/bash
# Variables
PROJECT_NAME="Nexus"

# Logo
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/logo.sh')

# Import Colors
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/!tools/bash-colors.sh')


print_header "Installing $PROJECT_NAME node..."

# Install denepdencies
sudo apt install build-essential pkg-config libssl-dev git-all -y
sudo apt install -y protobuf-compiler

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add riscv32i-unknown-none-elf

source "$HOME/.cargo/env"

curl https://cli.nexus.xyz/ | sh


