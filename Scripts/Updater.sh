#!/bin/bash
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh --output Complete_Install.sh
# curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
Version="Version(Updater) - 0.3.8"
echo "$Version"
sleep 1

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
Complete_Install
exit