function lab1
{
echo "Hello World!"
}

function lab2
{
# Lab 2 COMP2101 welcome script for profile
#

write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."

# functionn get-mydisks


function get-mydisks {
    Get-PhysicalDisk | Select-Object Manufacturer, Model, SerialNumber, FirmwareRevision, Size | Format-Table
}

get-mydisks
}

function lab3
{

"Network Adapter summary"

 gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |

 where { $_.ipaddress -ne $null -or $_.ipsubnet -ne $null -or $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |select description, ipaddress,ipsubnet,dnsserversearchorder, dnsdomain, dnshostname | format-table -AutoSize

}

function lab4
{
"--System Report--"

#function for operating system description
function osdescription 
{
"Operating System description"
Get-WmiObject win32_operatingsystem|Format-List name, version
}

#function for processor description
function processordescription
{
"Processor Description"
Get-WmiObject -Class win32_processor | 
foreach{
    New-Object -TypeName psobject -Property @{
        "Speed(MHz)" = $_.CurrentClockSpeed
        Cores = $_.NumberOfCores
        L1Size = $_.L1CacheSize
        L2Size = $_.L2CacheSize
        L3Size = $_.L3CacheSize
    }
} | Format-List "Speed(MHz)",Cores,L1Size,L2Size,L3Size
}

#function for physical memory
function physicalmemory
 {
"RAM Description"
$ramtemp=0
$Sysram = Get-WmiObject win32_physicalmemory 
foreach ($ram in $Sysram) {
                     new-object -typename psobject -property @{Manufacturer=$ram.Manufacturer
                                                               Description=$ram.Description
                                                               "Size(GB)"=$ram.Capacity / 1gb -as [int]
                                                               BankLabel= $ram.banklabel
                                                               Slot = $ram.Devicelocator
                                                               }|Format-Table BankLabel,Slot,Manufacturer,Description,"Size(GB)"
                                                               $ramtemp = $ram.capacity/1gb -as [int]
                                                               } 
                                                               
"Total RAM (GB) = $($ramtemp)"
}


#function for Disk drive summary
function diskdrive 
{
"Diskdrive Description"
$diskdrives = Get-CimInstance cim_diskdrive
foreach ($disk in $diskdrives)
{
$partitions = $disk|Get-CimAssociatedInstance -resultclassname cim_diskpartition
foreach ($partition in $partitions )
{
$logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName cim_logicaldisk
foreach ($logicaldisk in $logicaldisks)
{
New-Object -TypeName psobject -Property @{Venetworkor=$disk.Manufacturer
                                            Model=$disk.Model
                                          "Size(GB)"=$logicaldisk.size/1gb -as [int]
                                          "Freespace(GB)"=$logicaldisk.freespace/1gb -as [int]
                                          "Percentage free"=($logicaldisk.freespace)/($logicaldisk.size)*100
                                          }|Format-Table
}
}
}
}

#function for network adapter summary 
function networkconfiguration
{
"Network Adapter Description"
 gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |
 where { $_.ipaddress -ne $null -or $_.ipsubnet -ne $null -or $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |select description, ipaddress,ipsubnet,dnsserversearchorder, dnsdomain, dnshostname | format-table -AutoSize

}


#function for displaying vedio card summary
function videocard 
{
"Video Card summary"
Get-WmiObject win32_videocontroller | Format-List name, description, videomodedescription
}

#all functions
hardwaredescription
osdescription
processordescription
physicalmemory
diskdrive
networkconfiguration
videocard
"--END--"

}

