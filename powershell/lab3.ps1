
function lab3
{

"Network Adapter summary"

 gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |

 where { $_.ipaddress -ne $null -or $_.ipsubnet -ne $null -or $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |select description, ipaddress,ipsubnet,dnsserversearchorder, dnsdomain, dnshostname | format-table -AutoSize

}
