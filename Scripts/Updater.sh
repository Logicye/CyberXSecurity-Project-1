#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="0.3.4"
echo "$Version - Version (Updater)"
sleep 2

# POSITIONAL_ARGS=()

# while [[ $# -gt 0 ]]; do
#     case $1 in
#         -d|--directory)
#             CurDir= "$2"
#         ;;
#         *)
#         ;;
#     esac
# done

sync; echo 3 > /proc/sys/vm/drop_caches 
wget -m --no-cache --no-check-certificate -O /bin/Complete_Install http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
chmod u+x /bin/Complete_Install
chmod 777 /bin/Complete_Install
wget -m --no-cache --no-check-certificate -O $1/Updater.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
Complete_Install
exit