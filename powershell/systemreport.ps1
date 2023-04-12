
#function for CPU description
function get-processordescription
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

#function for OS
function get-osdescription 
{
"Operating System description"
Get-WmiObject win32_operatingsystem|Format-List name, version
}

#function for physical memory
function get-physicalmemory{
"RAM summary"
$ramc=0
$Sysram = Get-WmiObject win32_physicalmemory 
foreach ($ram in $Sysram) {
                     new-object -typename psobject -property @{Venetworkor=$ram.Manufacturer
                                                               Description=$ram.Description
                                                               "Size(GB)"=$ram.Capacity / 1gb -as [int]
                                                               BankLabel= $ram.banklabel
                                                               Slot = $ram.Devicelocator
                                                               }
                                                               $ramc = $ram.capacity/1gb -as [int]
                                                               }
                                                               "
Total RAM (GB) = $($ramc)"
}

#function for displaying vedio card summary
function get-videocard 
{
"Video Card summary"
Get-WmiObject win32_videocontroller | Format-List name, description, videomodedescription
}


#function for Disk drive summary
function get-diskdrive 
{
"Physical drive summary"
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
function get-networkconfiguration
{
"Network Adapter summary"
 gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |
 where { $_.ipaddress -ne $null -or $_.ipsubnet -ne $null -or $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |
 select description, ipaddress,ipsubnet,dnsserversearchorder, dnsdomain, dnshostname | format-table -AutoSize

}

function systemreport {

		param(
    [switch]$System,
    [switch]$Disks,
    [switch]$Network 
		)
		
if ($System){
			get-processordescription
			get-osdescription 
			get-physicalmemory
			get-videocard 
			
		} 
		elseif  ($Disks){
			get-diskdrive
		}
		elseif  ($Network){
			get-networkconfiguration
		}
		else {
                  get-processordescription
			get-osdescription 
			get-physicalmemory
			get-videocard 
			get-diskdrive
			
		}


}