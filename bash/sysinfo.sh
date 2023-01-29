# /bin/COMP2101/bash
# sysinfo.sh

#FQDN of the system
echo Fully Qualified Domain Name : $( hostname -f)

#Operating System & Kernel Version  of the system
echo System Information:- 
hostnamectl | grep 'Operating \| Kernel'

#IP Address of the system
echo IP address is: $(hostname -I )

#RootFile Storage Status System
echo Root File System Status :
df -h | grep Filesystem 
df -h | grep /dev/sda3 


