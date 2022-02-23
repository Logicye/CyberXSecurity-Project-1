if [ $(whoami) != 'root' ]; then
        echo "Must be root to run $0"
        exit 1;
fi

clear
Green='\033[0;32m'
Blue='\033[0;34m'
NoColour='\033[0m'
LogFile="log.txt"

# IP Addresses to replace
SearchIP="10.1.0.4"
# Directories to replace 
ReplaceDir=`pwd`
SearchDir='/root/CyberXSecurity-Project-1/Scripts/'  # Remember to add file directory for each change in seperate files ie (metricbeat/met...)

echo 'Enter IP address of Kibana server: '
echo -n '   -:'
read ReplaceIP
echo 'Wousld you like to add the Kibana Server to an [elk] list in ansible hosts y/n. (/etc/ansible/hosts)'
echo -n '   -:'
read REPLY
if $REPLY= "y"
then
        #modify ansible hosts files to add elk header and ip addresses
        if not grep -q "[elk]" "/etc/ansible/hosts"; then
                echo --silent "[elk]" >> /etc/ansible/hosts.txt
        fi

fi

echo -n '   -:'
read

echo 'Would you like to generate a [Webserver] list in ansible hosts (/etc/ansible/hosts)'
echo 'Enter IP Addresses of Web Servers'

# Creating Log of All Variables
echo "$ReplaceIP" >> $LogFile
echo "$SearchIP" >> $LogFile
echo "$ReplaceDir" >> $LogFile
echo "$SearchDir" >> $LogFile
echo "$WebServers" >> $LogFile



mkdir ELK_Stack_Install
cd ELK_Stack_Install
wget --no-check-certificate --content-disposition -O Complete_Install.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.yml
printf "${Green}Complete_Install.yml Complete${NoColour}\n\n"
wget --no-check-certificate --content-disposition -O filebeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/FileBeat/filebeat-config.yml
printf "${Green}filebeat-config.yml Complete${NoColour}\n\n"
wget --no-check-certificate --content-disposition -O metricbeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-config.yml
printf "${Green}metricbeat-config.yml Complete${NoColour}\n\n"
wget --no-check-certificate --content-disposition -O metricbeat-docker-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-docker-config.yml
printf "${Green}metricbeat-docker-config.yml Complete${NoColour}\n\n"
#Replace
#sed -n -i "s/10.1.0.4/$ReplaceIP/g" filebeat-config.yml
#sed -n -i "s/10.1.0.4/$ReplaceIP/g" metricbeat-config.yml