param (
    [string] $IncomingDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData',
    [string] $ArchiveDirectory = 'C:\Users\dstrait.CORP\Documents\Visual Studio 2012\Projects\FauxMeter\IncomingData\Archive'
    )

$IncomingSize = @(ls -path $IncomingDirectory -filter MeterReads-*.csv -ErrorAction:SilentlyContinue | Measure-Object -sum -Property:Length)
$ArchiveSize = @(ls -path $ArchiveDirectory -filter MeterReads-*.csv -ErrorAction:SilentlyContinue | Measure-Object -sum -Property:Length)

if ($($IncomingSize.Count) -eq 0) {
    write-verbose -verbose -message "The incoming folder has zero files."
    }
else {
    write-verbose -verbose -message "The incoming folder has $($IncomingSize.Count) files, for a total of $([math]::Round($IncomingSize.Sum / 1kb) ) kilobytes."
    }

if ($($ArchiveSize.Count) -eq 0) {
    write-verbose -verbose -message "The archive folder has zero files."
    }
else {
    write-verbose -verbose -message "The archive folder has $($ArchiveSize.Count) files, for a total of $([math]::Round($ArchiveSize.Sum / 1kb) ) kilobytes."
    }


#write-verbose -verbose -message "The archive folder has $($ArchiveSize.Count) files, for a total of $($ArchiveSize.Sum) bytes."
