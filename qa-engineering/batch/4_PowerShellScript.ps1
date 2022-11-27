Function GetFileName($SourcePath)
{
   New-PSDrive -Name source -PSProvider FileSystem -Root $SourcePath | Out-Null
   $LatestFile = Get-ChildItem -Path source: -Name STANDARD*.bak | Sort-Object LastAccessTime -Descending | Select-Object -First 1
   Remove-PSDrive source
   Return $LatestFile
}

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
 
$backuppath = "\\dbabkup01\B$\PROD_backups"
$SourceServer = "STANDARDDB01"
$TargetServer = "STANDARDDBUAT"
$SourceDatabaseName = "STANDARD"
$TargetDatabaseName = "STANDARD"

[string]$dt = get-date -format yyyyMMddHHmmss
# $FileName = GetFileName "\\dbabkup01\B$\PROD_BACKUPS\STANDARDDB01"
$FileName = GetFileName "\\dbabkup01\B$\PROD_BACKUPS\STANDARDDB01\STANDARD\FULL"

$bdir = "\\dbabkup01\B$\PROD_BACKUPS"
$bfil = "$backuppath\$SourceServer\STANDARD\FULL\$FileName"

$oSourceServer = new-object ("Microsoft.SqlServer.Management.Smo.Server") $SourceServer
$oSourceServer.ConnectionContext.StatementTimeout = 0

# Connect to the specified instance
$oTargetServer = new-object ('Microsoft.SqlServer.Management.Smo.Server') $TargetServer
$oTargetServer.ConnectionContext.StatementTimeout = 0
 
# Get the default file and log locations
# (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
$fileloc = $oTargetServer.Settings.DefaultFile
$logloc = $oTargetServer.Settings.DefaultLog
if ($fileloc.Length -eq 0) {
    $fileloc = $oTargetServer.Information.MasterDBPath
    }
if ($logloc.Length -eq 0) {
    $logloc = $oTargetServer.Information.MasterDBLogPath
    }
 
# Identify the backup file to use, and the name of the database copy to create
 
# Build the physical file names for the database copy
$dbfile = $fileloc + '\'+ $TargetDatabaseName + '_Data.mdf'
$logfile = $logloc + '\'+ $TargetDatabaseName + '_Log.ldf'
 
# Use the backup file name to create the backup device
$bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bfil, 'File')
 
# Create the new restore object, set the database name and add the backup device
$rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
$rs.Database = $TargetDatabaseName
$rs.Devices.Add($bdi)
$rs.ReplaceDatabase = $true
$rs.FileNumber = 1

 
# Get the file list info from the backup file
try{
$fl = $rs.ReadFileList($oTargetServer)
}
catch {$error[0] | format-list -force
		Throw}

foreach ($fil in $fl) {
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $fil.LogicalName
    if ($fil.Type -eq 'D'){
        $rsfile.PhysicalFileName = $dbfile
        }
    else {
        $rsfile.PhysicalFileName = $logfile
        }
    $rs.RelocateFiles.Add($rsfile)
    }
 
# Restore the database
write "...........Restoring  $TargetDatabaseName  database in $TargetServer  Server...."
try{
	#$oTargetServer.KillAllProcesses($TargetDatabaseName)
	if ($oTargetServer.Databases[$TargetDatabaseName]){
		$oTargetServer.KillDatabase($TargetDatabaseName)
		Start-Sleep -s 20
		$oTargetServer.Databases[$TargetDatabaseName].Drop() 
	}
}
catch{
	$ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write "The error message was $ErrorMessage"
    Throw
}

try {
	$rs.SqlRestore($oTargetServer)
	}
catch {
	$error[0] | format-list -force
	Throw
	}

write "...........Restore Completed for $TargetDatabaseName database in $TargetServer Server...."