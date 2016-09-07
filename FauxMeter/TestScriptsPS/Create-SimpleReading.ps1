<#
.SYNOPSIS
Create data files for importation by my super-experimental/research project "FauxMeter"

#>

param (
    [string] $IncomingDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData',
    [string] $ArchiveDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData\Archive',
    [int] $FilesToCreate = 100,
    [int] $DwellSeconds = 0
    )


Function Create-TestFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $IncomingDirectory,
        #[Parameter(Mandatory=$true)]
        #[string] $ArchiveDirectory,
        [switch] $ForceALoadFailure,
        [int] $RecordsPerFile = 77000
        )


    $OutFile = "$IncomingDirectory\MeterReads-$(([datetime]::Now).ToString("yyyyMMdd.HHmmss")).csv"

    write-verbose -Message "The incoming files are in '$OutFile'."

    # the idea is that a GUID is a set of readings that all happen "at the same time". 
    # This doesn't necessarily mean that one file is one set of readings. One file could have many sets of readings,
    # I just haven't implemented it that way (yet).

    # without wrapping the actualy GUID with {braces}, SSIS won't interpret the GUID correctly when it tries to import the value and you'll get a runtime error
    $GUID = "{$($(new-guid).Guid)}"

    # using an array list is much more efficient than a standard powershell 
    #$r = @()
    #$r += new-object -Property $record -TypeName psobject 
    $r = New-Object System.Collections.ArrayList
    for ($i= 1; $i -le $RecordsPerFile; $i++) {
        Write-Progress -Activity “Creating Records” -status “Created record $i” -percentComplete ($i / $RecordsPerFile * 100) -ParentId 1
        $record = [ordered] @{
            MeterID = $i + 1000000
            ReadingID = $GUID
            ReadingDate = [datetime]::Now
            ReadingWattHours = Get-Random -minimum 0 -maximum 100000
            ReadingColor = ('Red','Orange','Yellow','Green','Blue','Indigo','Violet' ) | Get-Random
            # Medición
            MedicionColor = ('Roja','Naranja','Amarillo','Verde','Azule' ) | Get-Random

            }

        #if (($i % 1000) -eq 0) {write-verbose -Verbose -Message "$i of $RecordsPerFile" }
        if (($i -eq 50) -and $ForceALoadFailure) {
            $record.ReadingColor = 'FAILME'
            }

        $r.Add($(new-object -Property $record -TypeName psobject)) | out-null
        }

    $r | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $OutFile -Encoding ascii

    }


$CreateALotOfFiles = $false
if ($CreateALotOfFiles) {
    for ($i=1; $i -le $FilesToCreate; $i++) {
        Write-Progress -Activity “Creating Files” -status “Created file $i” -percentComplete ($i / $FilesToCreate * 100) -id 1

        Create-TestFile -IncomingDirectory $IncomingDirectory 

        $IncomingSize = ls -path $IncomingDirectory -filter MeterReads-*.csv -ErrorAction:SilentlyContinue | Measure-Object -sum -Property:Length
        $ArchiveSize = ls -path $ArchiveDirectory -filter MeterReads-*.csv -ErrorAction:SilentlyContinue | Measure-Object -sum -Property:Length

        write-verbose -verbose -message "The incoming folder has $($IncomingSize.Count) files, for a total of $($IncomingSize.Sum) bytes."
        write-verbose -verbose -message "The archive folder has $($ArchiveSize.Count) files, for a total of $($ArchiveSize.Sum) bytes."



        # I want to make sure we have at least a little time between invocations. 
        sleep -Seconds $DwellSeconds 
        }
    }
else {

    Create-TestFile -IncomingDirectory $IncomingDirectory -ForceALoadFailure -RecordsPerFile 100

    }