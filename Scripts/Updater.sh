#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="0.2.6"
echo "$Version - Version (Updater)"
sleep 5
rm Complete_Install.sh
wget --no-cache --no-check-certificate -O Complete_Install.sh https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
rm Updater.sh
wget --no-cache --no-check-certificate -O Updater.sh https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
bash Complete_Install.sh
exit