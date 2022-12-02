USE [STANDARD]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [dbo]
DROP USER [STANDARDAdmin]
GO 
USE [master]
GO 

DECLARE @latestBackupName nvarchar(100)
DECLARE @DIR AS varchar(200)
DECLARE @backuplocation as varchar(300)
if (object_id('tempdb..#backupfiles') is not null)
    Drop table #backupfiles

Create Table #backupfiles( bkfilename varchar(250) )

Insert Into #backupfiles (bkfilename)
exec xp_cmdshell 'dir \\dbabkup01\prod_backups\STANDARDDB01\STANDARD\FULL\*.bak /B /O-D'

SET @DIR ='\\dbabkup01\prod_backups\STANDARDDB01\STANDARD\FULL\'

SeT @latestBackupName = (SELECT TOP 1 bkfilename from #backupfiles)
set @backuplocation = @DIR + @latestBackupName

SELECT * FROM #backupfiles
SELECT @latestBackupName

Drop Table #backupfiles

 --Remove any existing connections to the STANDARD database
CREATE TABLE #RunningSpids
(
       [spid] int 
       , [ecid] varchar(20) 
       , [status] varchar(120)
       , [loginame] varchar(128) 
       , [hostname] varchar(128) 
       , [blk] int
       , [dbname] varchar(128) 
       , [cmd] varchar(256) 
       , [request_id] varchar(10) 
)

WHILE EXISTS( SELECT 1 FROM sys.sysprocesses WHERE [dbid] = DB_ID('STANDARD'))
BEGIN 
    INSERT INTO #RunningSpids
    exec sp_who 

    DECLARE @dbName SYSNAME
    DECLARE @sqlCmd VARCHAR(MAX)
    DECLARE @loginname varchar(MAX) 

    SET @sqlCmd = ''
    SET @dbName = 'STANDARD' -- Change database name here
    SET @loginname = ''

    SELECT @sqlCmd = @sqlCmd + 'KILL ' + CAST(spid AS VARCHAR) + CHAR(13)
    FROM #RunningSpids
    WHERE dbname = @dbName

    EXEC (@sqlCmd) 
    TRUNCATE TABLE #RunningSpids
END 

DROP TABLE #RunningSpids

-- Perform the restore

RESTORE DATABASE [STANDARD] FILE = N'STANDARD_75_Data' 
FROM  DISK = @backuplocation
WITH  FILE = 1
,  MOVE N'STANDARD_75_Data' TO N'D:\sqldata\STANDARD_data.mdf'
,  MOVE N'STANDARD_75_Log' TO N'L:\sqllog\STANDARD_log.ldf'
,  NOUNLOAD
,  REPLACE
,  STATS = 10
GO

ALTER DATABASE STANDARDAutomation SET RECOVERY SIMPLE
GO

USE [STANDARDAutomation]
GO
GRANT CONNECT TO [STANDARDAdmin]

