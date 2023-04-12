#calling parameters
param (
    [switch]$System, 
    [switch]$Disks, 
     [switch]$Network
)


#function for OS for $system
function get-osdescription 
{
"---Operating System Description---"
Get-WmiObject win32_operatingsystem|Format-List name, version
}

#function CPU Processor for $system
function get-processordescription
{
"---Processor Description----"
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



#function physical memory for $system
function get-physicalmemory
 {
"---RAM Description---"
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


#function Disk drive summary for $Disks
function get-diskdrive 
{
"---Disk drive Description---"
$diskdrives = Get-CimInstance cim_diskdrive
foreach ($disk in $diskdrives)
{
$partitions = $disk|Get-CimAssociatedInstance -resultclassname cim_diskpartition
foreach ($partition in $partitions )
{
$logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName cim_logicaldisk
foreach ($logicaldisk in $logicaldisks)
{
New-Object -TypeName psobject -Property @{Manufacturer=$disk.Manufacturer
                                            Model=$disk.Model
                                          "Size(GB)"=$logicaldisk.size/1gb -as [int]
                                          "Freespace(GB)"=$logicaldisk.freespace/1gb -as [int]
                                          "Percentage free"=($logicaldisk.freespace)/($logicaldisk.size)*100
                                          }|Format-Table
}
}
}
}


#function network adapter summary for $Network
function get-networkconfiguration
{
"---Network Adapter Description---"
 gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |
 where { $_.ipaddress -ne $null -or $_.ipsubnet -ne $null -or $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |select description, ipaddress,ipsubnet,dnsserversearchorder, dnsdomain, dnshostname | format-table -AutoSize
}

#function video card for $system
function get-videocard 
{
"---Video Card Description---"
Get-WmiObject win32_videocontroller | Format-List name, description, videomodedescription
}


#systemreport -System -Disks & -Network

if ($System -eq $true)
 {
   
    get-osdescription
    get-processordescription
    get-physicalmemory
    get-videocard
}
elseif ($Disks -eq $true) 
{
    get-diskdrive
}
elseif ($Network -eq $true)
 {
    get-networkconfiguration
}

else 
 {
    
    get-osdescription
    get-processordescription
    get-physicalmemory
    get-diskdrive
    get-networkconfiguration
    get-videocard
}
