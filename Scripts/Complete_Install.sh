clear
Green='\033[0;32m'
Blue='\033[0;34m'
NoColour='\033[0m'

# IP Addresses to replace
ReplaceIP= "" >> log.txt
printf "Replace IP Address: $ReplaceIP" >> log.txt
SeacrchIP= "10.1.0.4" >> log.txt
printf "Search IP Address: $SearchIP" >> log.txt

# Directories to replace 
ReplaceDir= pwd >> log.txt
printf "Replace Directory: $ReplaceDir" >> log.txt
SearchDir= "/root/CyberXSecurity-Project-1/Scripts/" >> log.txt # Remember to add file directory for each change in seperate files ie (metricbeat/met...)
printf "Search Directory: $SearchDir" >> log.txt

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
sed -n -i "s/10.1.0.4/$ReplaceIP/g" filebeat-config.yml
sed -n -i "s/10.1.0.4/$ReplaceIP/g" metricbeat-config.yml