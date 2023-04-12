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