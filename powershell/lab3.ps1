gwmi -class win32_networkadapterconfiguration -filter ipenabled=true |
 where { $_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null } |
 select description, dnsserversearchorder, dnsdomain, dnshostname