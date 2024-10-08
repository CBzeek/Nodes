#!/bin/bash
PROJECT_NAME="Elixir"

echo ""
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Restart $PROJECT_NAME node ... \e[0m" && sleep 1
echo ""
docker kill elixir
docker rm elixir

docker run -d \
  --env-file $HOME/.elixir/validator.env \
  --name elixir \
  -p 17690:17690 \
  elixirprotocol/validator:v3
