clear
Green='\033[0;32m'
NoColour='\033[0m'
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
curDir = pwd
printf $curDir