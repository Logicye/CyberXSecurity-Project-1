#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="0.2.4"
echo "$Version"
sleep 2
wget -O Complete_Install.sh https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
wget -O Updater.sh https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
bash Complete_Install.sh
exit