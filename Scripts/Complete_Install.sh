#!/bin/bash

#inintialise
set -e
clear
if [ $(whoami) != 'root' ]; then
        echo "Must be root to run $0"
        exit 1;
fi

#set colours and 
Green='\033[0;32m'
Blue='\033[0;34m'
NoColour='\033[0m'

#Set known variables
DefaultIP="10.1.0.4"
DefaultDir='/root/CyberXSecurity-Project-1/Scripts/'  # Remember to add file directory for each change in seperate files ie (metricbeat/met...)
LogFile="log.txt"
CurDir=`pwd`
#-----------------
if ! [ -f "$CurDir/WebServerList.txt" ]; then
echo "" > WebServerList.txt
fi
WebServerListFileName="$CurDir/WebServerList.txt"
#-----------------
if ! [ -f "$CurDir/ElkServerList.txt" ]; then
echo "" > ElkServerList.txt
fi
ElkServerListFileName="$CurDir/ElkServerList.txt"
#-----------------
Config_Files="123"

#Install file gather
Download_Install_And_Config_Files() {
        echo "Where Would you like to save the files:"
        read Config_Files
        read -p "Saving to $Config_Files \nContinue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
        mkdir $Config_Files
        cd $Config_Files
        wget --no-check-certificate --content-disposition -O Complete_Install.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.yml
        printf "${Green}Complete_Install.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O filebeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/FileBeat/filebeat-config.yml
        printf "${Green}filebeat-config.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O metricbeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-config.yml
        printf "${Green}metricbeat-config.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O metricbeat-docker-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-docker-config.yml
        printf "${Green}metricbeat-docker-config.yml Complete${NoColour}\n\n"
        cd ../
}

#Set user web servers IP's
Web_Server_Set() {

}

#Set user elk server IP
Elk_Server_Set() {

}

#Modify config files
Config_Modify() {
        echo "nothing here yet"
}

#Clear Server Lists at Run Time
Clear_Server_Lists() {
        echo "" > $WebServerListFile
        echo "" > $ElkServerListFile
}

#Runs install process once all variables have been given
Install() {
        ansible-playbook Complete_Install.yml
}

#Updates all variables required to specified log files add variables to list to watch outputs
Update_Log() {
        # echo "$ReplaceIP" >> $LogFile
        # echo "$SearchIP" >> $LogFile
        # echo "$ReplaceDir" >> $LogFile
        # echo "$SearchDir" >> $LogFile
        # echo "$WebServers" >> $LogFile
}

#Clean up discarded files
Clean_Up() {
        rm -r ELK_Stack_Install
        rm log.txt
        rm Complete_Install.yml


}


# -------------------------------------------------------------------------------------------------------------
#                       Main Arguments And Script
# -------------------------------------------------------------------------------------------------------------

echo "$Config_Files" >> $LogFile
Download_Install_And_Config_Files()
echo "$Config_Files" >> $LogFile





# Confirm test
# # read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] --------------------------------------------------
# echo 'Enter IP address of Kibana server: '
# echo -n '   -:'
# read ReplaceIP
# echo 'Wousld you like to add the Kibana Server to an [elk] list in ansible hosts. (/etc/ansible/hosts)'
# echo -n '   -:'
# read AddElk
# echo -n '   -:'
# select yn in "Yes" "No"; do
#     case $yn in
#         Yes ) if cat /etc/ansible/hosts.txt | grep -q "elk"; then
                        
#                 fi; break;;
#         No ) exit;;
#     esac
# done
# read REPLY
# if [$REPLY -e "y"]
# then
#         #modify ansible hosts files to add elk header and ip addresses
#         if ! grep -q "[elk]" "/etc/ansible/hosts"; then
#                 echo "[elk]" | tee $HostsFile
#         fi
# else 
#                 break
# fi


# echo -n '   -:'
# read

# echo 'Would you like to generate a [Webserver] list in ansible hosts (/etc/ansible/hosts)'
# echo 'Enter IP Addresses of Web Servers'




# mkdir ELK_Stack_Install
# cd ELK_Stack_Install
# wget --no-check-certificate --content-disposition -O Complete_Install.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.yml
# printf "${Green}Complete_Install.yml Complete${NoColour}\n\n"
# wget --no-check-certificate --content-disposition -O filebeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/FileBeat/filebeat-config.yml
# printf "${Green}filebeat-config.yml Complete${NoColour}\n\n"
# wget --no-check-certificate --content-disposition -O metricbeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-config.yml
# printf "${Green}metricbeat-config.yml Complete${NoColour}\n\n"
# wget --no-check-certificate --content-disposition -O metricbeat-docker-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-docker-config.yml
# printf "${Green}metricbeat-docker-config.yml Complete${NoColour}\n\n"
#Replace
#sed -n -i "s/10.1.0.4/$ReplaceIP/g" filebeat-config.yml
#sed -n -i "s/10.1.0.4/$ReplaceIP/g" metricbeat-config.yml