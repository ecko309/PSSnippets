################################################################################################
# Reset spooler service
Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name Spooler -ErrorAction SilentlyContinue

################################################################################################
# Get all printers with HP drivers
Get-Printer | Where-Object DriverName -in $(Get-PrinterDriver -Name "HP*").Name

################################################################################################
# Remove all printers with HP drivers
Get-Printer | Where-Object DriverName -in $(Get-PrinterDriver -Name "HP*").Name | Remove-Printer -Confirm:$false
