#!/bin/bash
PROJECT_NAME="massa"

cd $HOME

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Deleting $PROJECT_NAME node auto rolls script and task... \e[0m" && sleep 1
echo ''
rm /root/rollsup.sh
rm /etc/cron.d/massarolls
rm /root/rolls.log

