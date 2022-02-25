#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="Version(Updater) - 0.3.11"
echo "$Version"
sleep 1
wget -m --no-cache --no-check-certificate -O /bin/Complete_Install http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
chmod u+x /bin/Complete_Install
chmod 777 /bin/Complete_Install
Complete_Install
exit