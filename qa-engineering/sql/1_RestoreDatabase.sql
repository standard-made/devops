USE [Allegro]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [dbo]
DROP USER [AllegroAdmin]
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
exec xp_cmdshell 'dir \\dbabkup01\prod_backups\ALLEGRODB01\Allegro\FULL\*.bak /B /O-D'

SET @DIR ='\\dbabkup01\prod_backups\ALLEGRODB01\Allegro\FULL\'

SeT @latestBackupName = (SELECT TOP 1 bkfilename from #backupfiles)
set @backuplocation = @DIR + @latestBackupName

SELECT * FROM #backupfiles
SELECT @latestBackupName

Drop Table #backupfiles

 --Remove any existing connections to the Allegro database
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

WHILE EXISTS( SELECT 1 FROM sys.sysprocesses WHERE [dbid] = DB_ID('Allegro'))
BEGIN 
    INSERT INTO #RunningSpids
    exec sp_who 

    DECLARE @dbName SYSNAME
    DECLARE @sqlCmd VARCHAR(MAX)
    DECLARE @loginname varchar(MAX) 

    SET @sqlCmd = ''
    SET @dbName = 'Allegro' -- Change database name here
    SET @loginname = ''

    SELECT @sqlCmd = @sqlCmd + 'KILL ' + CAST(spid AS VARCHAR) + CHAR(13)
    FROM #RunningSpids
    WHERE dbname = @dbName

    EXEC (@sqlCmd) 
    TRUNCATE TABLE #RunningSpids
END 

DROP TABLE #RunningSpids

-- Perform the restore

RESTORE DATABASE [Allegro] FILE = N'allegro_75_Data' 
FROM  DISK = @backuplocation
WITH  FILE = 1
,  MOVE N'allegro_75_Data' TO N'D:\sqldata\Allegro_data.mdf'
,  MOVE N'allegro_75_Log' TO N'L:\sqllog\Allegro_log.ldf'
,  NOUNLOAD
,  REPLACE
,  STATS = 10
GO

ALTER DATABASE AllegroAutomation SET RECOVERY SIMPLE
GO

USE [AllegroAutomation]
GO
GRANT CONNECT TO [AllegroAdmin]

