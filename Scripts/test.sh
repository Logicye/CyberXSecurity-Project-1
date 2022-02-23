chmod +x test.sh
clear
cd CyberXSecurity-Project-1
git pull
cd ..
cp CyberXSecurity-Project-1/Scripts/test.sh ../testing1/
cp CyberXSecurity-Project-1/Scripts/Complete_Install.sh ../testing1/
rm -r ELK_Stack_Install
echo "wiped" > log.txt
bash Complete_Install.sh
$LogDir=`pwd`
if [ -f "$LogDir/log.txt" ];
then
    cat log.txt
fi
sleep 10
clear