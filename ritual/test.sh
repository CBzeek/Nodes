#!/bin/bash
PROJECT_NAME="Ritual"

read -p "Enter your private key (example: 0x123....123): " PRIVATE_KEY

sed -i 's/sender *:=.*/sender := ${PRIVATE_KEY}/' Makefile
