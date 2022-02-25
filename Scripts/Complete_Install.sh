#!/bin/bash
Version="Version - 0.3.7"

#inintialise
# set -e

clear
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
                        if ! [[ wget -O - http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh | grep "Version - " -eq $Version ]]; then
                                clear
                                echo "Updating..."
                                sleep 1
                                sync; echo 3 > /proc/sys/vm/drop_caches 
                                if ! [ -d "$Config_Files" ]; then
                                        mkdir $Config_Files
                                fi
                                wget -m --no-cache --no-check-certificate -O $Config_Files/Updater.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
                                sudo bash $Config_Files/Updater.sh $Config_Files
                                exit
                        else
                                echo "Already up to date!"
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
NoColour='\033[0m'

#Set known variables
DefaultIP="10.1.0.4"
DefaultDir='/root/CyberXSecurity-Project-1/Scripts/'  # Remember to add file directory for each change in seperate files ie (metricbeat/met...)
CurDir=`pwd`
Config_Files="/etc/Elk_Install_Files"
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

#Download Dependent Function
# Dir_Select() {
# read -p "Would you like to set your own download folder(Y/N)?" confirm
# if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
#         read -p "Please enter the folder path you would like to install to. If It does not exit is will be automatically created:" Config_Files
#         if ! [ -d "$Config_Files" ]; then
#                 mkdir $Config_Files
#         fi
# elif [[ $confirm == [nN] || $confirm == [nN][oO] ]];then
#         Config_Files=$Config_Files_Default
#         mkdir $Config_Files
# else
#         exit
# fi 
# }


#Install file gather
Download_Install_And_Config_Files() {
        # Dir_Select
        if ! [ -d "$Config_Files" ]; then
                clear
                echo "Error: Folder Does not exist. Exiting"
                sleep 3
                menu
        fi
        wget --no-check-certificate --content-disposition -O $Config_Files/Complete_Install.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Complete_Install.yml
        printf "${Green}Complete_Install.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O $Config_Files/filebeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/FileBeat/filebeat-config.yml
        printf "${Green}filebeat-config.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O $Config_Files/metricbeat-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-config.yml
        printf "${Green}metricbeat-config.yml Complete${NoColour}\n\n"
        wget --no-check-certificate --content-disposition -O $Config_Files/metricbeat-docker-config.yml https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/MetricBeat/metricbeat-docker-config.yml
        printf "${Green}metricbeat-docker-config.yml Complete${NoColour}\n\n"
        if ! [ -f "$Config_Files/WebServerList.txt" ]; then
                echo "No WebServerList.txt found"
                echo "" > $Config_Files/WebServerList.txt
                echo "WebServerList.txt created"
        fi
        WebServerListFileName="$Config_Files/WebServerList.txt"
        #-----------------
        if ! [ -f "$Config_Files/ElkServerList.txt" ]; then
                echo "No ElkServerList.txt found"
                echo "" > $Config_Files/ElkServerList.txt
                echo "ElkServerList.txt created"
        fi
        ElkServerListFileName="$Config_Files/ElkServerList.txt"
}

#Set user web servers IP's
Web_Server_Set() {
        echo "[webservers]" >> $WebServerListFileName
        read -p "How many webservers would you like to deploy to? " TotalServers
        for i in $(seq 1 "$TotalServers")
        do
                read -p "Enter server number $i's IP:" NextIP
                echo "$NextIP" >> "$WebServerListFileName ansible_python_interpreter=/usr/bin/python3"
        done
        cat $WebServerListFileName >> /etc/ansible/hosts
}

#Set user elk server IP
Elk_Server_Set() {
        clear
        echo "Please enter the IP address of your Kibana server: "
        read NewIP
        echo "[elk]" > $ElkServerListFileName
        echo "$NewIP" > "$ElkServerListFileName ansible_python_interpreter=/usr/bin/python3"
        cat $ElkServerListFileName >> /etc/ansible/hosts
}

#Modify config files
Config_Modify() {
        sed -i "s/$DefaultIP/$NewIP/g" $Config_Files/filebeat-config.yml
        sed -i "s/$DefaultIP/$NewIP/g" $Config_Files/metricbeat-config.yml
        echo "${Green}Config Complete!${NoColour}"
}

#Runs install process once all variables have been given
Install() {
        ansible-playbook "$Config_Files/Complete_Install.yml"
        printf "${Green} Install Complete!${NoColour}"
        Exit_Or_Return
}

#Self Updater
Update() {
        # curl https://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh --output Updater.sh
        if ! [[ wget -O - http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh | grep "Version - " == "$Version" ]]; then
                sync; echo 3 > /proc/sys/vm/drop_caches 
                if ! [ -d "$Config_Files" ]; then
                        mkdir $Config_Files
                fi
                wget --no-cache --no-check-certificate -O $Config_Files/Updater.sh http://raw.githubusercontent.com/Logicye/CyberXSecurity-Project-1/main/Scripts/Updater.sh
                sleep 2
                sudo bash $Config_Files/Updater.sh $Config_Files
                exit
        else
                echo "Already up to date!"
                Menu
        fi
}

#Clean up discarded files
Clean_Up() {
        read -p "Would you like to delete the web server list file? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                rm $WebServerListFileName
                echo "Web Server List File Removed"
        fi
        read -p "Would you like to delete elk server list file? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                rm $ElkServerListFileName
                echo "Elk Server List File Removed"
        fi
        read -p "Would you like to delete the Complete installer playbook? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                rm $Config_Files/Complete_Install.yml
                echo "Playbook Removed"
        fi
        read -p "Would you like to delete the Complete installer package? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                rm /bin/Complete_Install
                echo "Installer Removed"
        fi
                read -p "Would you like to delete the config file folder? (Y/N): " confirm  
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];then
                rm -r $Config_Files
                echo "Config Files Removed"
        fi
        Exit_Or_Return
}


#primary menu function
Menu() {
      clear
      printf "${Blue}+-+-+-+ +-+-+-+-+-+-+-+-+-+\n"
      printf "${Green}|E|L|K| |I|N|S|T|A|L|L|E|R|\n"
      printf "${Blue}+-+-+-+ +-+-+-+-+-+-+-+-+-+\n${NoColour}"
      echo "($Version)Select one option using up/down keys and enter to confirm:"
      echo
      options=("Download Files" "Add Webservers" "Change Elk Server" "Modify Config Files" "Install" "Remove Installer And All Dependencies" "Update" "Quit")
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
                Config_Modify
                ;;
                4)
                Install
                ;;
                5)
                Clean_Up
                ;;
                6)
                Update
                ;;
                7)
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