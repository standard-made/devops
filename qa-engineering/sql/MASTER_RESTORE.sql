/*******************************************************************************************************************/
/* RESTORE MASTER **************************************************************************************************/
/*******************************************************************************************************************/

/* LAST BACKUP DATE ***********************************/
/******************************************************/
SELECT sdb.Name AS DatabaseName,
COALESCE(CONVERT(VARCHAR(12), MAX(bus.backup_finish_date), 101),'-') AS LastBackUpTime
FROM sys.sysdatabases sdb
LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
GROUP BY sdb.name


/* LAST RESTORE DATE **********************************/
/******************************************************/
WITH LastRestores AS
(
SELECT
    [d].[name] AS DatabaseName,
    [d].[create_date] AS CreationDate,
	[bs].[database_name] AS SourceDatabase,
	[r].[destination_database_name] AS DestinationDatabase,
	[bmf].[physical_device_name] AS RestoreFile,
	[bs].[machine_name] AS MachineName,
    [r].[restore_date] AS RestoreDate,
	[bs].[user_name] AS UserName,
    ROW_NUMBER() OVER (PARTITION BY d.Name ORDER BY r.[restore_date] DESC) AS RowNum
FROM MASTER.SYS.DATABASES d
LEFT OUTER JOIN msdb.dbo.[restorehistory] r ON r.[destination_database_name] = d.name
LEFT OUTER JOIN msdb.dbo.backupset bs ON r.backup_set_id = bs.backup_set_id
LEFT OUTER JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
)
SELECT *
FROM [LastRestores]
WHERE [RowNum] = 1


/* RESTORE HISTORY ************************************/
/******************************************************/
SELECT [bs].[database_name] AS SourceDatabase,
	   [rh].[destination_database_name] AS DestinationDatabase, 
       [rh].[restore_date] AS RestoreDate,
       [bmf].[physical_device_name] AS RestoreFile,
       [bs].[machine_name] AS MachineName,
	   [bs].[user_name] AS UserName
FROM msdb.dbo.restorehistory rh 
INNER JOIN msdb.dbo.backupset bs ON rh.backup_set_id = bs.backup_set_id
INNER JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
ORDER BY [rh].[Destination_database_name]


/* SINGLE RESTORE DETAIL ******************************/
/******************************************************/
DECLARE @DB SYSNAME = 'Standard';
SELECT TOP 1 * FROM msdb.dbo.restorehistory 
WHERE destination_database_name = @DB
ORDER BY restore_date DESC


/* UN-ORPHAN USERS ************************************/
/******************************************************/
-- List all orphaned users
EXEC sp_change_users_login 'Report' 

-- Unorphan users
EXEC sp_change_users_login 'Auto_Fix', 'StandardAdmin'
	-- OR
ALTER USER StandardAdmin WITH LOGIN = StandardAdmin


/* SET TO SIMPLE RECOVERY *****************************/
/******************************************************/
USE MASTER
GO
ALTER DATABASE StandardQA SET RECOVERY SIMPLE
