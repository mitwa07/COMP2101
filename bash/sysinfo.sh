# /bin/COMP2101/bash
# sysinfo.sh


#HOSTNAME of the system 
hostname=$( hostname )

#FQDN of the system
FQDN=$(hostname -f)

#Operating System & Kernel Version  of the system
SystemInformation=$(hostnamectl | grep 'Operating \| Kernel')

#IP Address of the system
IPaddress=$(hostname -I )

#RootFile Storage Status System
FileStatus=$(df --output=avail --block-size=G / | awk 'NR==2 {print $1 }')

cat <<EOF
Report for $hostname
######################################
FQDN:$FQDN
$SystemInformation
Ip Address :$IPaddress
Root File System Available Space :$FileStatus
######################################
EOF
 


