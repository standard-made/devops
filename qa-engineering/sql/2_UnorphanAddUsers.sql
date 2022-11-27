USE [Allegro]
GO

IF NOT EXISTS (
		SELECT *
		FROM sysusers
		WHERE NAME = 'RT\s-AllegroQA'
		)
BEGIN
	CREATE USER [RT\s-AllegroQA]
	FOR LOGIN [RT\s-AllegroQA]
END
	ALTER ROLE [db_owner] ADD MEMBER [RT\s-AllegroQA]

GO

IF NOT EXISTS (
		SELECT *
		FROM sysusers
		WHERE NAME = 'RT\GS-ISQATeam'
		)
BEGIN 
	CREATE USER [RT\GS-ISQATeam]
	FOR LOGIN [RT\GS-ISQATeam]
END
	ALTER ROLE [db_owner] ADD MEMBER [RT\GS-ISQATeam]

GO
IF EXISTS (
		SELECT *
		FROM sysusers
		WHERE NAME = 'RT\s-AllegroPrd'
		)
BEGIN 
DROP USER [RT\s-AllegroPrd]
END 

GO


USE Allegro
GO 

--Decide if you want to just print unmapped users
DECLARE @pPrintOnly BIT = 0
DECLARE @Environment BIT = 1 -- 0 for dev 1 for deploy

SET NOCOUNT ON

--Declare variables
DECLARE @vuNAME SYSNAME,
		@vRowID INT,
		@vTrows INT,
		@vSQL VARCHAR(200)

--Create work table		
CREATE TABLE #tmpDBUsers
	(
	uRowID INT IDENTITY(1,1) NOT NULL,
	uName SYSNAME NOT NULL
	)

--Load unmapped entries
--Taken this from the sp_change_users_login source code!
INSERT INTO #tmpDBUsers (uName)
	SELECT su.name FROM sysusers su
	JOIN master.sys.syslogins sl
		ON su.name COLLATE SQL_Latin1_General_CP1_CI_AS= sl.name COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE issqluser = 1
	AND   (su.sid is not null and su.sid <> 0x0)
	AND   (len(su.sid) <= 16)
	AND   suser_sname(su.sid) is null
	ORDER BY su.name

--Set variables
SET @vTrows = (SELECT COUNT(*) FROM #tmpDBUsers)
SET @vRowID = 1

--Print database name heading based on bit
IF (@vTrows > 0) 
	PRINT DB_NAME() + '  --- Unmapped Users ---'
ELSE
	PRINT DB_NAME() + '  --- All users mapped ---'

--Process all unmapped database users
WHILE @vRowID <= @vTRows
BEGIN 
	SELECT @vuName = uName FROM #tmpDBUsers where uRowID = @vRowID
	
	--Set command
	SET @vSQL = 'ALTER USER ' + QUOTENAME(@vuNAME) + ' WITH LOGIN = ' + QUOTENAME(@vuNAME)

	--Print only if bit is set
	IF (@pPrintOnly = 1) PRINT @vSQL
	
	--Fix mapping for user
	IF (@pPrintOnly = 0)
	BEGIN
		EXEC (@vSQL)
		PRINT @vSQL + '		-- Fixed --'
	END
	
	--Increment row counter
	SET @vRowID = @vRowID + 1
	
END

--Drop working table
DROP TABLE #tmpDBUsers