#! /bin/bash
clear
Version="Version - 0.4.1.1"
Config_Files="/etc/Elk_Install_Files"

if [ $(whoami) != 'root' ]; then
        echo "Must be root to run $0"
        exit 1;
fi

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
        case $1 in
                -c|--clean-boot)
                        clear
                        echo "CLEAN BOOT(Removing all files...)"
                        sleep 1
                        rm -r $Config_Files
                        if ! [ -d "$Config_Files" ]; then
                                mkdir $Config_Files
                        fi
                ;;
                -u|--update-boot)
                        clear
                        VersionCheckSum='Version="'$Version'"'
                        VersionCheck=$(wget -qO - http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh | grep -m 1 "Version - ")
                        if ! [ "$VersionCheck" == "$VersionCheckSum" ]; then
                                clear
                                echo "Updating..."
                                if ! [ -d "$Config_Files" ]; then
                                        mkdir $Config_Files
                                fi
                                wget -q --no-check-certificate -qO /bin/Complete_Install http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
                                chmod u+x /bin/Complete_Install
                                chmod 777 /bin/Complete_Install
                                Complete_Install
                                exit
                        else
                                echo "Already up to date!"
                                sleep 1
                                Complete_Install
                                exit
                        fi
                ;;
                -v|--version)
                        clear
                        echo "$Version"
                        sleep 2
                        clear
                        exit
                ;;
                *)
                ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

#set colours and 
Green='\033[0;32m'
Blue='\033[0;34m'
Red='\033[0;31m'
NoColour='\033[0m'

#Set known variables
DefaultIP="10.1.0.4"
DefaultDir='/root/CyberXSecurity-Project-1/Scripts/'  # Remember to add file directory for each change in seperate files ie (metricbeat/met...)
CurDir=`pwd`
# Config_Files_Default="/etc/Elk_Installer"



# -------------------------------------------------------------------------------------------------------------
#                                       Main Functions
# -------------------------------------------------------------------------------------------------------------


function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

#Install file gather
Download_Install_And_Config_Files() {
        clear
        if ! [ -d "$Config_Files" ]; then
                clear
                echo "Error: Folder Does not exist. Exiting"
                sleep 3
                menu
        fi
        wget -q --no-check-certificate --content-disposition -O $Config_Files/Complete_Install.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.yml
        printf "${Green}Complete_Install.yml Download Complete${NoColour}\n\n"
        wget -q --no-check-certificate --content-disposition -O $Config_Files/filebeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/FileBeat/filebeat-config.yml
        printf "${Green}filebeat-config.yml Download Complete${NoColour}\n\n"
        wget -q --no-check-certificate --content-disposition -O $Config_Files/metricbeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-config.yml
        printf "${Green}metricbeat-config.yml Download Complete${NoColour}\n\n"
        wget -q --no-check-certificate --content-disposition -O $Config_Files/metricbeat-docker-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-docker-config.yml
        printf "${Green}metricbeat-docker-config.yml Download Complete${NoColour}\n\n"
        printf "${Green}        All Downloads Complete${NoColour}\n\n"
        sleep 2
        sed -i "s/\/root\/CyberXSecurity-Project-1\/Scripts\/FileBeat\//\/etc\/Elk_Install_Files\//g" $Config_Files/Complete_Install.yml
        sed -i "s/\/root\/CyberXSecurity-Project-1\/Scripts\/MetricBeat\//\/etc\/Elk_Install_Files\//g" $Config_Files/Complete_Install.yml
        printf "${Green}       Complete_Install.yml Configured${NoColour}\n\n"
        sleep 2
        Menu
}

# Checks validity of ip
is_ip() {
        local ip=$1
        if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
                for d in 1 2 3 4; do
                        if [ $(echo "$ip" | cut -d. -f$d) -gt 255 ]; then
                                clear
                                echo "IP address entered is not a valid IP address!"
                                return 1
                        fi
                done
                return 0
        else
                clear
                echo "IP address entered is not a valid IP address!"
                return 1
        fi
}


#Set user web servers IP's
Web_Server_Set() {
        WebServerExist=$(grep "\[webservers\]" /etc/ansible/hosts)
        if [ "$WebServerExist" == "[webservers]" ];then
                clear 
                echo "webservers does exit"
                
        elif [ "$WebServerExist" == "## [webservers]" ];then
                clear
                echo "## webservers does exist"
                sed -i "s/## \[webservers\]/[webservers]/g" /etc/ansible/hosts
        else
                clear
                echo "webservers does not exist"
                echo "" >> /etc/ansible/hosts
                echo "[webservers]" >> /etc/ansible/hosts

        fi

        read -p "How many webservers would you like to deploy to? " TotalServers
        while [[ $((TotalServers)) != $TotalServers ]] ; do
                echo "Number of servers must be an integer!"
                read -p "How many webservers would you like to deploy to? " TotalServers
        done
        for i in $(seq 1 "$TotalServers")
        do
                read -p "Enter server number $i's IP:" NextIP
                is_ip $NextIP
                while ! [[ $? -eq 0 ]]; do
                        read -p "Enter server number $i's IP:" NextIP
                        is_ip $NextIP
                done

                IPExistCheck=$(grep -m 1 "$NextIP" /etc/ansible/hosts)
                if [ "$IPExistCheck" == "$NextIP ansible_python_interpreter=/usr/bin/python3" ];then
                        echo "$NextIP Already in hosts file"
                else
                        sed -i "/\[webservers\]/a $NextIP ansible_python_interpreter=/usr/bin/python3" /etc/ansible/hosts
                fi
        done
        printf "${Green}        All new webserver IP's Added${NoColour}\n\n"
        sleep 2
        Menu

}

#Set user elk server IP
Elk_Server_Set() {
        ElkExist=$(grep "\[elk\]" /etc/ansible/hosts)
        if [ "$ElkExist" == "[elk]" ];then
                clear 
                echo "elk does exit"
        else
                clear
                echo "elk does not exist"
                echo "" >> /etc/ansible/hosts
                echo "[elk]" >> /etc/ansible/hosts

        fi
        read -p "Please enter the IP address of your Kibana server: " ElkIP
        is_ip $ElkIP
        while ! [[ $? -eq 0 ]]; do
                read -p "Please enter the IP address of your Kibana server: " ElkIP
                is_ip $ElkIP
        done
        IPExistCheck=$(grep -m 1 "$ElkIP ansible_python_interpreter=/usr/bin/python3" /etc/ansible/hosts)
        if [ "$IPExistCheck" == "$ElkIP" ];then
                echo "$ElkIP Already in hosts file"
        else
                sed -i "/\[elk\]/a $ElkIP ansible_python_interpreter=/usr/bin/python3" /etc/ansible/hosts
        fi
        sed -i "s/$DefaultIP/$ElkIP/g" $Config_Files/filebeat-config.yml
        sed -i "s/$DefaultIP/$ElkIP/g" $Config_Files/metricbeat-config.yml
        printf "${Green}        Config files changed for kibana server${NoColour}"
        sleep 2
        Menu
}

#Runs install process once all variables have been given
Install() {
        ansible-playbook "$Config_Files/Complete_Install.yml"
        printf "${Green}        Install Complete!${NoColour}"
        Exit_Or_Return
}

#Self Updater
Update() {
        clear
        VersionCheckSum='Version="'$Version'"'
        VersionCheck=$(wget -qO - http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh | grep -m 1 "Version - ")
        if ! [ "$VersionCheck" == "$VersionCheckSum" ]; then
                clear
                echo "Updating..."
                if ! [ -d "$Config_Files" ]; then
                        mkdir $Config_Files
                fi
                wget --no-check-certificate -qO /bin/Complete_Install http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.sh
                chmod u+x /bin/Complete_Install
                chmod 777 /bin/Complete_Install
                Complete_Install
                exit
        else
                echo "Already up to date!"
                sleep 1
                Complete_Install
                exit
        fi
}


#primary menu function
Menu() {
      clear
      printf "${Blue}+-+-+-+ +-+-+-+-+-+-+-+-+-+\n"
      printf "${Green}|E|L|K| |I|N|S|T|A|L|L|E|R|\n"
      printf "${Blue}+-+-+-+ +-+-+-+-+-+-+-+-+-+\n${NoColour}"
      echo "($Version)"
      echo
      options=("Download Config Files" "Add Webservers" "Change Kibana Server IP" "Install" "Update" "Quit")
      select_option "${options[@]}"
      choice=$?

        case $choice in
                0)
                Download_Install_And_Config_Files;;
                1)
                Web_Server_Set
                ;;
                2)
                Elk_Server_Set
                ;;
                3)
                Install
                ;;
                4)
                Update
                ;;
                5)
                clear
                exit
                ;;
        esac
}

#Exit or return function, decides whether or not to head back to menu or close out of the installer
Exit_Or_Return() {
        read -p "Would you like to return to menu? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                clear
                Menu
        elif [[ $confirm == [nN] || $confirm == [nN][oO] ]];then
                clear
                exit
        else
                clear
                Exit_Or_Return
        fi
}


# -------------------------------------------------------------------------------------------------------------
#                                       Main Arguments And Script
# -------------------------------------------------------------------------------------------------------------

Menu