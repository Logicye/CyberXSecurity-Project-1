#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="0.3.0"
echo "$Version - Version (Updater)"
sleep 5
apt update
apt upgrade -yy
apt install wget
sync; echo 3 > /proc/sys/vm/drop_caches 
rm Complete_Install.sh
wget -m --no-cache --no-check-certificate -O Complete_Install.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
rm Updater.sh
wget -m --no-cache --no-check-certificate -O Updater.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
bash Complete_Install.sh
exit