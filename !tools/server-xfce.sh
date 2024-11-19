#!/bin/bash
cd $HOME

#Ubuntu update and upgrade
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Updating and Upgrading server... \e[0m"
echo '' && sleep 1
sudo apt update && sudo apt upgrade -y

# Install software
echo ''
echo -e "\e[1m\e[32m###########################################################################################"
echo -e "\e[1m\e[32m### Installing dependencies to server... \e[0m"
echo '' && sleep 1
sudo apt install curl mc git jq screen lz4 build-essential htop zip unzip wget rsync snapd -y
sudo snap install yq
sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils xrdp xorgxrdp

# Add xrdp user
sudo adduser xrdp ssl-cert

# Backup 
cd /etc/xrdp
sudo mv startwm.sh startwm.sh.bak

sudo tee startwm.sh > /dev/null <<EOF
#!/bin/sh
if [ -r /etc/default/locale ]; then
. /etc/default/locale
export LANG LANGUAGE
fi
exec /usr/bin/startxfce4
EOF

sudo chmod 755 startwm.sh

sudo systemctl restart xrdp

sudo systemctl status xrdp

sudo ufw allow 3389



