<#
.SYNOPSIS
This empties out the import table and moves the CSVs from the "archive" folder to the "incoming" folder.

#>
[string] $IncomingDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData'
[string] $ArchiveDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData\Archive'


& "C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\TestScriptsPS\get-importsreport.ps1"

# sometimes, old versions of invoke-sqlcmd will move the PWD 
$l = Get-Location

Write-Verbose -Verbose -Message "Truncating table dbo.MeterReadings"
invoke-sqlcmd -server moe -query "truncate table dbo.MeterReadings" -database FauxMeter -as:NonQuery 

ls -Path $ArchiveDirectory -Filter MeterReads-*.csv  | Move-Item -Destination $IncomingDirectory 

Set-Location $l 

& "C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\TestScriptsPS\get-importsreport.ps1"