#!/bin/bash
PROJECT_NAME="massa"

cd $HOME

echo '###########################################################################################'
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node auto rolls script... \e[0m" && sleep 1
echo ''
sudo tee /root/rollsup.sh > /dev/null <<EOF
#!/bin/sh
#Версия 0.15
cd /root/massa/massa-client
#Set variables
catt=/usr/bin/cat
passwd=\$(\$catt \$HOME/mspasswd)
candidat=\$(./massa-client wallet_info -p "\$passwd"|grep 'Rolls'|awk '{print \$4}'| sed 's/=/ /'|awk '{print \$2}')
massa_wallet_address=\$(./massa-client -p "\$passwd" wallet_info |grep 'Address'|awk '{print \$2}')
tmp_final_balans=\$(./massa-client -p "\$passwd" wallet_info |grep 'Balance'|awk '{print \$3}'| sed 's/=/ /'|sed 's/,/ /'|awk '{print \$2}')
final_balans=\${tmp_final_balans%%.*}
averagetmp=\$(\$catt /proc/loadavg | awk '{print \$1}')
node=\$(./massa-client -p "\$passwd" get_status |grep 'Error'|awk '{print \$1}')
if [ -z "\$node" ]&&[ -z "\$candidat" ];then
echo \`/bin/date +"%b %d %H:%M"\` "(rollsup) Node is currently offline" >> /root/rolls.log
elif [ \$candidat -gt "0" ];then
echo "Ok" > /dev/null
elif [ \$final_balans -gt "99" ]; then
echo \`/bin/date +"%b %d %H:%M"\` "(rollsup) The roll flew off, we check the number of coins and try to buy" >> /root/rolls.log
resp=\$(./massa-client -p "\$passwd" buy_rolls \$massa_wallet_address 1 0)
else
echo \`/bin/date +"%b %d %H:%M"\` "(rollsup) Not enough coins to buy a roll from you \$final_balans, minimum 100" >> /root/rolls.log
fi
EOF


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Creating $PROJECT_NAME node auto rolls cron.d task... \e[0m" && sleep 1
echo ''
printf "SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/3 * * * * root /bin/bash /root/rollsup.sh > /dev/null 2>&1
" > /etc/cron.d/massarolls


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Save $PROJECT_NAME node password.. \e[0m" && sleep 1
echo ''
sudo tee $HOME/mspasswd > /dev/null <<EOF
$1
EOF


echo '###########################################################################################'
echo -e "\e[1m\e[32m### Creating auto rolls log.. \e[0m" && sleep 1
echo ''
sudo tee $HOME/rolls.log > /dev/null <<EOF
Лог файл создан удачно.
EOF

