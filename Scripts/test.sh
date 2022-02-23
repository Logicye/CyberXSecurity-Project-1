chmod +x test.sh
clear
cd CyberXSecurity-Project-1
git pull
cd ..
cp CyberXSecurity-Project-1/Scripts/test.sh ../testing1/test
cp CyberXSecurity-Project-1/Scripts/Complete_Install.sh ../testing1/
rm -r ELK_Stack_Install
rm log.txt
bash Complete_Install.sh
cat log.txt
sleep 10
clear