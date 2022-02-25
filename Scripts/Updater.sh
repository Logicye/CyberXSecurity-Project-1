#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="0.3.0"
echo "$Version - Version (Updater)"
sleep 5
sync; echo 3 > /proc/sys/vm/drop_caches 
wget -m --no-cache --no-check-certificate -O Complete_Install.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
wget -m --no-cache --no-check-certificate -O Updater.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
Complete_Install
exit