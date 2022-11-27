/*******************************************************************************************************************/
/* SQL MASTER ******************************************************************************************************/
/*******************************************************************************************************************/

/* SQL DATE AND TIME **********************************/
/******************************************************/
/* DATEADD(datepart,number,date) */
	-- DatePart = which part of the date format (YYYY-MM-DD HH:MI:SS.MMM)
	-- Number = number interval added or subtracted
	-- Date = valid date expression
SELECT DATEADD(MINUTE, -60, GETDATE()) AS PastDate --ONE HOUR AGO
SELECT DATEADD(DAY, -1, GETDATE()) --24 HOURS AGO

/* DATEDIFF(datepart,startdate,enddate) */
	-- DatePart = which part of the date format (YYYY-MM-DD HH:MI:SS.MMM)
	-- StartDate = valid date expression
	-- EndDate = valid date expression
SELECT DATEDIFF(MONTH,'1985-11-13',GETDATE()) AS MonthsAlive --MONTHS SINCE BIRTH
SELECT DATEDIFF(DAY,'1985-11-13',GETDATE()) AS DaysAlive --DAYS SINCE BIRTH
SELECT DATEDIFF(MINUTE,'1985-11-13',GETDATE()) AS MinutesAlive --MINUTES SINCE BIRTH
SELECT DATEDIFF(SECOND,'1985-11-13',GETDATE()) AS SecondsAlive --SECONDS SINCE BIRTH

/* DATEPART(datepart,date) */
	-- DatePart = which part of the date format (YYYY-MM-DD HH:MI:SS.MMM)
	-- Date = valid date expression
SELECT DATEPART(yyyy,GETDATE()) AS Year,
	DATEPART(qq,GETDATE()) AS Quarter,
	DATEPART(mm,GETDATE()) AS Month,
	DATEPART(wk,GETDATE()) AS Week,
	DATEPART(dd,GETDATE()) AS Day,
	DATEPART(dy,GETDATE()) AS DayOfYear,
	DATEPART(hh,GETDATE()) AS Hour,
	DATEPART(mi,GETDATE()) AS Minute,
	DATEPART(ss,GETDATE()) AS Second,
	DATEPART(dw,GETDATE()) AS Weekday

/* CAST(expression AS datatype(length) */
	-- Expression = any valid expression
	-- DataType = target datatype
	-- Length = optional integer that specifies the length of the target datatype (default:30)
SELECT CAST(GETDATE()-1 AS DATE) --YESTERDAY
SELECT CAST(GETDATE()+1 AS DATE) --TOMORROW
SELECT CAST(GETDATE() AS DATETIME) --(YYYY-MM-DD HH:MI:SS.MMM)
SELECT CAST(GETDATE() AS DATETIME2) --(YYYY-MM-DD HH:MI:SS.MMMMMMM)
SELECT DATENAME(m,GETDATE()) + ' ' + CAST(DATEPART(yyyy, GETDATE()) AS VARCHAR) AS DATE -- MONTH YEAR
SELECT DAY(DATEADD(DD, -1, DATEADD(MM, DATEDIFF(MM, -1, GETDATE()), 0))) -- NUMBER OF DAYS IN CURRENT MONTH
SELECT DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) -- LAST DAY OF MONTH 
SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), 101)  -- LAST DAY OF PREVIOUS MONTH (MM/DD/YYYY)
SELECT DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)  -- LAST DAY OF PREVIOUS MONTH (DATETIME)
SELECT CONVERT(VARCHAR(10),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), 101) + ' 23:59:59.999' -- LAST DAY OF PREVIOUS MONTH (DATETIME EOD)
SELECT DATEADD(HOUR,23,CONVERT(VARCHAR(10), GETDATE(),110)) -- SPECIFY TIME FOR CURRENT DAY (11PM)

/* LIST ALL DAYS IN THE PREVIOUS MONTH  M/D/YYYY */
DECLARE @DateFrom DATE, @DateTo DATE;
SET @DateFrom = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101); -- FIRST DAY OF PREVIOUS MONTH
SET @DateTo = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)), 101); -- LAST DAY OF PREVIOUS MONTH
--SET @DateFrom = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101); -- FIRST DAY OF CURRENT MONTH
--SET @DateTo = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)), 101); -- LAST DAY OF CURRENT MONTH
--SET @DateFrom = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+2, 0)), 101); -- FIRST DAY OF NEXT MONTH
--SET @DateTo = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+2,0)), 101); -- LAST DAY OF NEXT MONTH
WITH Dates AS (
    SELECT @DateFrom AS DatesInMonth
    UNION ALL
    SELECT DATEADD(d,1,DatesInMonth) FROM Dates WHERE DatesInMonth < @DateTo
)
SELECT FORMAT(DatesInMonth, 'M/d/yyyy') FROM Dates

/* FORMAT DATE TO M/DD/YYYY */
DECLARE @datetime DATETIME;
SET @datetime = GETDATE();
	SELECT FORMAT(@datetime, 'M/dd/yyyy')
/******************************************************/


/* ADD RANDOM MILLISECOND DELAY TO DATETIME ***********/
/******************************************************/
DECLARE @MyDateTime DATETIME;
SET @MyDateTime = DATEADD(ms,RAND()*(1000-1)+1,GETDATE());
	SELECT GETDATE() CurrentTime
	WAITFOR TIME @MyDateTime
	SELECT GETDATE() CurrentTime
/******************************************************/


/* CALCULATE AGE DOWN TO THE NANOSECOND ***************/
/******************************************************/
DECLARE @date DATETIME;
SET @date = '11/13/1985 09:57:00.000 AM';
    SELECT (DATEDIFF(yy, @date, GETDATE()) - CASE WHEN (MONTH(@date) > MONTH(GETDATE())) OR (MONTH(@date)
    = MONTH(GETDATE()) AND DAY(@date) > DAY(GETDATE())) THEN 1 ELSE 0 END) AS "Age in Years", 
    (DATEDIFF(MONTH, @date, GETDATE()) - CASE WHEN DAY(@date) > DAY(GETDATE()) THEN 1 ELSE 0 END) AS "Months", 
    (DATEDIFF(DAY, @date, GETDATE())) AS "DAYS",
    DATEDIFF(Hour,@date,GETDATE()) AS [Hour],DATEDIFF(Minute,@date, GETDATE()) AS [Minutes],DATEDIFF(Second,@date,GETDATE()) AS [Seconds],
    RIGHT(CONVERT(VARCHAR, @date, 100),2) AS "AM/PM",
    CAST(DATEDIFF(Second,@date,GETDATE()) AS DECIMAL) * 1000 AS MiliSeconds,
    CAST(DATEDIFF(Second,@date,GETDATE()) AS DECIMAL) * 1000000000 AS NanoSeconds
/******************************************************/


/* CALCULATING RANDOM NUMBERS *************************/
/******************************************************/
/* METHOD 1: Generate Random Number Between 1 and 999999 */
DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT;
	SET @Lower = 1; -- The lowest random number
	SET @Upper = 999999; -- The highest random number
	SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SELECT @Random

/* METHOD 2: Generate Random Float Numbers */
SELECT RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )

/* METHOD 3: Generate Random Numbers Quick Scripts */
SELECT 20 * RAND() -- [0, 20]
SELECT 10 + (30-10)*RAND() -- [10, 30]

/* METHOD 4: Generate Random Numbers (Float, Int) Tables Based with Time */
DECLARE @t TABLE( randnum FLOAT );
DECLARE @cnt INT; SET @cnt = 0;
	WHILE @cnt <=10000
	BEGIN
	SET @cnt = @cnt + 1;
	INSERT INTO @t
	SELECT RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )
	END
	SELECT randnum, COUNT(*)
	FROM @t
	GROUP BY randnum

/* METHOD 5: Generate Random Number on a Per Row Basis */
SELECT randomNumber, COUNT(1) countOfRandomNumber
	FROM (SELECT ABS(CAST(NEWID() AS BINARY(6)) %1000) + 1 randomNumber
	FROM SYSOBJECTS) SAMPLE
	GROUP BY randomNumber
	ORDER BY randomNumber
/******************************************************/


/* ASCII CONVERSION ***********************************/
/******************************************************/
/* Decimal to ASCII */
SELECT CHAR(72)+CHAR(85)+CHAR(68)+CHAR(83)+CHAR(79)+CHAR(78) AS LastName

/* ASCII to Decimal */
SELECT ASCII('H') AS LastName
		UNION ALL
	SELECT ASCII('U')
		UNION ALL
	SELECT ASCII('D')
		UNION ALL
	SELECT ASCII('S')
		UNION ALL
	SELECT ASCII('O')
		UNION ALL
	SELECT ASCII('N')
/******************************************************/


/* SQL INSTANCE DETAILS *******************************/
/******************************************************/
/* List Stored Procedures */
SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_TYPE = 'PROCEDURE'

/* List Table Details */
SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT
	FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'physicalmeasure' 
	ORDER BY ORDINAL_POSITION 

/* List Tables in Database */
SELECT TABLE_NAME AS 'TABLES IN DATABASE'
	FROM INFORMATION_SCHEMA.TABLES
	ORDER BY 'TABLES IN DATABASE'

/* List Server Details */
SELECT SERVERPROPERTY('MachineName') AS [ServerName], 
	SERVERPROPERTY('ServerName') AS [ServerInstanceName], 
    SERVERPROPERTY('InstanceName') AS [Instance], 
    SERVERPROPERTY('Edition') AS [Edition],
    SERVERPROPERTY('ProductVersion') AS [ProductVersion], 
	Left(@@Version, Charindex('-', @@version) - 2) AS VersionName

/* List User Details */
SELECT HOST_NAME() AS HostName, SUSER_NAME() LoggedInUser

/* List Connection String */
SELECT 'data source=' + @@SERVERNAME +
    ';initial catalog=' + DB_NAME() +
    CASE type_desc
	WHEN 'WINDOWS_LOGIN' 
    THEN ';trusted_connection=true'
	ELSE ';user id=' + SUSER_NAME() 
	END AS ConnectionString
	FROM SYS.SERVER_PRINCIPALS
	WHERE name = SUSER_NAME()
/******************************************************/


/* DATABASE RESTORE ***********************************/
/******************************************************/
RESTORE DATABASE FuelPurchaseOpDb FROM DISK = 'F:\FuelPurchaseOpDb_backup_2015_08_24_230154_0000000.BAK' 
	WITH MOVE 'FuelPurchaseOpDb' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\FuelPurchaseOpDb.mdf',
	MOVE 'FuelPurchaseOpDb_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\FuelPurchaseOpDb.ldf',
	MOVE 'FuelOpCDC' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\FuelPurchaseOpDb.ndf',keep_cdc
/******************************************************/


/* BULK INSERT INTO SQL *******************************/
/******************************************************/
/* Create Test Table */
CREATE TABLE CSVTest
	(ID INT,
	FirstName VARCHAR(40),
	LastName VARCHAR(40),
	BirthDate SMALLDATETIME)

/* Insert CSV into Test Table */
BULK INSERT CSVTest
	FROM 'C:\Users\kehudson\Documents\csvtest.txt'
	WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')

/* Insert Using Command Prompt */
SELECT 'bcp "'Standard'QA.dbo.CSVTest" in "C:\Users\kehudson\Documents\csvtest.txt" -S'Standard'dbqa01 - T -t, -r\n -c -k' AS CMD
/* Check Test Table Contents */
SELECT * FROM CSVTest

/* Drop Test Table */
DROP TABLE CSVTest
/******************************************************/


/* SQL CURENCIES **************************************/
/******************************************************/
/* Dollar */
SELECT FORMAT(123456.789, 'C', 'en-us') AS Dollar

/* Euro */
SELECT FORMAT(123456.789, 'C', 'fr-fr') AS Euro

/* Pound */
SELECT FORMAT(123456.789, 'C', 'en-gb') AS Pound

/* Yin */
SELECT FORMAT(123456.789, 'C', 'zh-cn') AS Yin

SELECT CAST(4387672143 / 1073741824.0E AS DECIMAL(10, 2)) AS GB


/* GET LAST RESTORE DATE ******************************/
/******************************************************/
/* Get Last Restore Date For All Databases */
WITH LastRestores AS
(
SELECT
    [d].[name] AS DatabaseName,
	[r].[restore_date] AS RestoreDate,
	[bs].[database_name] AS SourceDatabase,
	[r].[destination_database_name] AS DestinationDatabase,
	[bmf].[physical_device_name] AS RestoreFile,
	[bs].[machine_name] AS MachineName,
    [d].[create_date] AS CreationDate,
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


/* Get Restore History For All Databases */
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


/*Get Latest Restore For Single Database */
DECLARE @DB SYSNAME = ''Standard'QA';
SELECT TOP 1 * FROM msdb.dbo.restorehistory 
WHERE destination_database_name = @DB
ORDER BY restore_date DESC


/* GET TABLE SIZE *************************************/
/******************************************************/
/* Get Table Sizes In KB */
USE ['Standard'Automation]
GO
CREATE TABLE #temp (
    table_name sysname,
    row_count int,
    reserved_size varchar(50),
    data_size varchar(50),

    index_size varchar(50),
    unused_size varchar(50)
)
SET NOCOUNT ON
INSERT #temp
EXEC sp_msforeachtable 'sp_spaceused ''?'''
SELECT TOP 15
    a.table_name,
    a.row_count,
    COUNT(*) AS col_count,
    a.data_size
FROM #temp a
INNER JOIN information_schema.columns b
    ON a.table_name COLLATE database_default
    = b.table_name COLLATE database_default
GROUP BY a.table_name,
         a.row_count,
         a.data_size
ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC
DROP TABLE #temp


/* Get Table Sizes In GB */
USE 'Standard'Automation
GO
SELECT 
 t.Name AS [TableName],
 CAST((SUM( DISTINCT au.Total_pages) * 8 ) / 1024.000 / 1024.000 AS NUMERIC(18, 3)) 
 AS [TableSpace(GB)]
FROM 
 SYS.Tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
 INNER JOIN SYS.Indexes idx ON t.Object_id = idx.Object_id
 INNER JOIN SYS.Partitions part ON idx.Object_id = part.Object_id 
                    AND idx.Index_id = part.Index_id
 INNER JOIN SYS.Allocation_units au ON part.Partition_id = au.Container_id
 INNER JOIN SYS.Filegroups fGrp ON idx.Data_space_id = fGrp.Data_space_id
 INNER JOIN SYS.Database_files Df ON Df.Data_space_id = fGrp.Data_space_id
WHERE t.Is_ms_shipped = 0 AND idx.Object_id > 255 
GROUP BY t.name
HAVING CAST((SUM( DISTINCT au.Total_pages) * 8 ) / 1024.000 / 1024.000 AS NUMERIC(18, 3)) >= '0.100' -->100MB
ORDER BY [TableSpace(GB)] DESC


/* Get Database Size in GB */
SELECT 
  dbs.NAME, 
  CAST((SUM(mFiles.SIZE) * 8 / 1024.00 / 1024.00) AS NUMERIC(18,2)) 
      AS [DB SIZE (In GB)]
FROM
   SYS.MASTER_FILES mFiles INNER JOIN SYS.DATABASES dbs
      ON dbs.DATABASE_ID = mFiles.DATABASE_ID
WHERE dbs.DATABASE_ID > 4 
             -- FILTER OUT THE DATABSES AS "master", 
             -- "tempdb", "model" AND "msdb"
GROUP BY dbs.NAME
ORDER BY [DB SIZE (In GB)] DESC


/* Get Data & Log File Sizes */
SELECT 
  dbs.NAME, 
  CAST(SUM(CASE WHEN type = 0 THEN mFiles.size * 8 / POWER(2.00,30.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [DataFile SIZE (In TB)],
  CAST(SUM(CASE WHEN type = 1 THEN mFiles.size * 8 / POWER(2.00,30.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [LogFile SIZE (In TB)],
  CAST(SUM(CASE WHEN type = 0 THEN mFiles.size * 8 / POWER(2.00,20.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [DataFile SIZE (In GB)],
  CAST(SUM(CASE WHEN type = 1 THEN mFiles.size * 8 / POWER(2.00,20.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [LogFile SIZE (In GB)],
  CAST(SUM(CASE WHEN type = 0 THEN mFiles.size * 8 / POWER(2.00,10.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [DataFile SIZE (In MB)],
  CAST(SUM(CASE WHEN type = 1 THEN mFiles.size * 8 / POWER(2.00,10.00) ELSE 0 END) AS NUMERIC(18,2)) 
      AS [LogFile SIZE (In MB)],
  CAST(SUM(CASE WHEN type = 0 THEN mFiles.size * 8 ELSE 0 END) AS NUMERIC(18,2)) 
      AS [DataFile SIZE (In KB)],
  CAST(SUM(CASE WHEN type = 1 THEN mFiles.size * 8 ELSE 0 END) AS NUMERIC(18,2)) 
      AS [LogFile SIZE (In KB)]
FROM
   SYS.MASTER_FILES mFiles INNER JOIN SYS.DATABASES dbs
      ON dbs.DATABASE_ID = mFiles.DATABASE_ID
WHERE dbs.DATABASE_ID > 4 
             -- FILTER OUT THE DATABSES AS "master", 
             -- "tempdb", "model" AND "msdb"
GROUP BY dbs.NAME
ORDER BY [DataFile SIZE (In TB)] DESC

/* Get Single Table Size */
EXEC sp_spaceused 'gridlog'


/* DATABASE SIZE AND INFO *****************************/
/******************************************************/
EXEC sp_helpdb @dbname= ''Standard''


/* GET ALL DATES FOR CURRENT MONTH ********************/
/* WITH DATE NAME AS COLUMN NAME **********************/
/******************************************************/
/* W/SCALER FUNCTION */
	--STEP 1--
IF (OBJECT_ID('GetMonthName') IS NOT NULL)
  DROP FUNCTION GetMonthName
GO
CREATE FUNCTION GetMonthName()
RETURNS NVARCHAR(MAX)
AS BEGIN
	DECLARE @string NVARCHAR(MAX);
	SET @string = (SELECT DATENAME(MONTH, DATEADD(MONTH, MONTH(GETDATE()), 0) -1));

	RETURN @string
END
GO
	--STEP 2--
DECLARE @month NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

SET @month = dbo.GetMonthName();
SET @sql = 'DECLARE @DateFrom DATE, @DateTo DATE;
SET @DateFrom = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101); -- FIRST DAY OF PREVIOUS MONTH
SET @DateTo = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)), 101); -- LAST DAY OF CURRENT MONTH
WITH Dates AS (
    SELECT @DateFrom AS DatesInMonth
    UNION ALL
    SELECT DATEADD(d,1,DatesInMonth) FROM Dates WHERE DatesInMonth < @DateTo
)
SELECT FORMAT(DatesInMonth, ''M/d/yyyy'') AS ' + @month + ' FROM Dates ORDER BY ';
EXEC sp_executesql @sql
GO
	--STEP 3--
IF (OBJECT_ID('GetMonthName') IS NOT NULL)
  DROP FUNCTION GetMonthName
GO


/* W/OUT SCALER FUNCTION */
DECLARE @sql NVARCHAR(MAX);
SET @sql = 'DECLARE @DateFrom DATE, @DateTo DATE;
SET @DateFrom = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101); -- FIRST DAY OF PREVIOUS MONTH
SET @DateTo = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)), 101); -- LAST DAY OF CURRENT MONTH
WITH Dates AS (
    SELECT @DateFrom AS DatesInMonth
    UNION ALL
    SELECT DATEADD(d,1,DatesInMonth) FROM Dates WHERE DatesInMonth < @DateTo
)
SELECT FORMAT(DatesInMonth, ''M/d/yyyy'') AS '+ DATENAME(MONTH, GETDATE()) +' FROM Dates';
EXEC sp_executesql @sql


/* DYNAMIC SQL ****************************************/
/******************************************************/
/* Set Variable as Database in FROM Statement */
DECLARE @query VARCHAR(MAX)
DECLARE @CONNECTION VARCHAR(50)
SELECT  @CONNECTION = ''Standard'QA'

SET @query = 'SELECT TOP 1000 * FROM ' + @CONNECTION + '.dbo.findetail'

EXEC (@query)


/* DYNAMIC SQL ****************************************/
/******************************************************/
/* Case Statement */
SELECT 
     CASE
       WHEN g.status IS NOT NULL THEN g.status
       ELSE 'Not Running'
     END AS CurrentStatus
FROM gridservice g
WHERE g.servicename = 'CMEDeal'

/* IF Statement */
IF EXISTS (SELECT * FROM gridservice WHERE servicename = 'CMEDeal') 
	(SELECT status AS CurrentStatus FROM gridservice 
	WHERE servicename = 'CMEDeal') 
ELSE SELECT 'Service Not Configured' AS CurrentStatus


/* BATCH DELETE ***************************************/
/******************************************************/
/* Delete 1k Rows at a Time */
SELECT 'Starting' --sets @@ROWCOUNT
WHILE @@ROWCOUNT <> 0
    DELETE TOP (10000) gridlog

/* Keep Certain Data From Being Deleted */
SELECT * INTO #gridlog
	FROM gridlog WHERE eventtime > '2017-01-01 00:00:00.000'

SELECT 'Starting' --sets @@ROWCOUNT
WHILE @@ROWCOUNT <> 0
    DELETE TOP (10000) gridlog

INSERT INTO gridlog
	SELECT * FROM #gridlog


/* BCP BULK INSERT FROM FILE **************************/
/******************************************************/
BULK INSERT #temp
FROM 'c:\test.csv'
WITH
(
   FIELDTERMINATOR = '~', --column seperator
   ROWTERMINATOR = '\n' --next row
)