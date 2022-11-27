USE [Allegro]
GO

BEGIN TRANSACTION [Tran1]

BEGIN TRY
	--delete grid queue and put all grid schedule to be InActive
	DELETE
	FROM [gridqueue]

	UPDATE [gridschedule]
	SET active = 0
		,id = NULL
		,laststatus = 'SKIPPED'

	--reset Servers
	UPDATE [gridserver]
	SET SERVER = 'allegroappuat01'
		,url = 'http://allegroappuat01/allegro'
		,active = 1
		,userprocs = 1
		, bgslots = 8
	WHERE SERVER = 'allegroapp01'

	UPDATE [gridserver]
	SET SERVER = 'allegroappuat02'
		,url = 'http://allegroappuat02/allegro'
		,active = 1
		,userprocs = 1
		, bgslots = 8
	WHERE SERVER = 'allegroapp02'

	IF EXISTS 
		(SELECT * FROM gridserver WHERE server IN ('allegroapp03','allegroapp04','allegroapp05'))
	DELETE FROM [gridserver]
	WHERE SERVER IN ('allegroapp03','allegroapp04','allegroapp05')

	--reset Avalara username and password
	UPDATE interfaceuserid
	SET LOGIN = 'metroplexua.api'
		,password = 'VHadpqz7VtV9Wm+QjVvoLDn3VPavgcvp' --> Ih@v3t0c0nn3ctt0UA!
		,URL = 'https://exciseua.avalara.net'
	WHERE interfacename = 'Avalara'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'EndOfMonthExportFileName'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'EndOfMonthExportFileName'
			,'EndOfMonthExport'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'EndOfMonthExport'
		WHERE configkey = 'EndOfMonthExportFileName'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'EndOfMonthExportPath'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'EndOfMonthExportPath'
			,'\\rt-ops\Public\bfrost\'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\rt-ops\Public\bfrost\'
		WHERE configkey = 'EndOfMonthExportPath'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'FuelOpDb'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'FuelOpDb'
			,'Allegro_FuelPurchaseOpDb_UAT'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'Allegro_FuelPurchaseOpDb_UAT'
		WHERE configkey = 'FuelOpDb'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'FuelSqlSrvCl'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'FuelSqlSrvCl'
			,'SQLSRVCLDEPLOY'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'SQLSRVCLDEPLOY'
		WHERE configkey = 'FuelSqlSrvCl'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'FuelSqlSrvCleBOL'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'FuelSqlSrvCleBOL'
			,'SQLSRVCLDEPLOY'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'SQLSRVCLDEPLOY'
		WHERE configkey = 'FuelSqlSrvCleBOL'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'ICMSARExportPath'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'ICMSARExportPath'
			,'\\rtcorpappdev\AllegroICMSExport\'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\rtcorpappdev\AllegroICMSExport\'
		WHERE configkey = 'ICMSARExportPath'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'ICMSDatabase'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'ICMSDatabase'
			,'ICMS'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'ICMS'
		WHERE configkey = 'ICMSDatabase'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'ICMSServerName'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'ICMSServerName'
			,'SQLSTDDEV'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'SQLSTDDEV'
		WHERE configkey = 'ICMSServerName'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'MetroplexInventoryOutputPath'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'MetroplexInventoryOutputPath'
			,'\\fuelsqlsrvcl\share\Allegro_UAT\MetroplexInventory\'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\fuelsqlsrvcl\share\Allegro_UAT\MetroplexInventory\'
		WHERE configkey = 'MetroplexInventoryOutputPath'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'PDIBolFile'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'PDIBolFile'
			,'\\pdifile01\enterprisedata\QA\EnterpriseImports\Allegro EBOL\pdibol.txt'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\pdifile01\enterprisedata\QA\EnterpriseImports\Allegro EBOL\pdibol.txt'
		WHERE configkey = 'PDIBolFile'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'StagingDB'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'StagingDB'
			,'Allegro_Staging_UAT'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'Allegro_Staging_UAT'
		WHERE configkey = 'StagingDB'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'StagingDBeBOL'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'StagingDBeBOL'
			,'Allegro_Staging_UAT'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = 'Allegro_Staging_UAT'
		WHERE configkey = 'StagingDBeBOL'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'TransmontaigneCustodyPattern'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'TransmontaigneCustodyPattern'
			,'^*ta203dtl*$'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '^*ta203dtl*$'
		WHERE configkey = 'TransmontaigneCustodyPattern'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'TransmontaigneImportPath'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'TransmontaigneImportPath'
			,'\\rtfuelapp\Transmontaigne\uat\inventoryfiles\'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\rtfuelapp\Transmontaigne\uat\inventoryfiles\'
		WHERE configkey = 'TransmontaigneImportPath'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'TransmontaigneInventoryPattern'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'TransmontaigneInventoryPattern'
			,'^*ta203sum*$'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '^*ta203sum*$'
		WHERE configkey = 'TransmontaigneInventoryPattern'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'WellsFargoBAIFileMask'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'WellsFargoBAIFileMask'
			,'*.BAI'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '*.BAI'
		WHERE configkey = 'WellsFargoBAIFileMask'

	IF (
			SELECT Count(0)
			FROM userconfig
			WHERE configkey = 'WellsFargoBAIImportPath'
			) = 0
	BEGIN
		INSERT INTO dbo.userconfig (
			userid
			,configkey
			,configvalue
			,creationname
			,creationdate
			,revisionname
			,revisiondate
			)
		VALUES (
			'SYSTEM'
			,'WellsFargoBAIImportPath'
			,'\\rtfuelapp\Allegro\WellsFargo\uat\'
			,'ImportScript'
			,Getdate()
			,NULL
			,NULL
			)
	END
	ELSE
		UPDATE dbo.userconfig
		SET configvalue = '\\rtfuelapp\Allegro\WellsFargo\uat\'
		WHERE configkey = 'WellsFargoBAIImportPath'

	COMMIT TRANSACTION [Tran1]
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage;

	ROLLBACK TRANSACTION [Tran1]
END CATCH

--add qa contacts
BEGIN
	INSERT INTO dbo.contact (
		counterparty
		,NAME
		,title
		,salutation
		,contactclass
		,address
		,officephone
		,faxphone
		,homephone
		,mobilephone
		,email
		,telex
		,ftp
		,STATUS
		,creationname
		,creationdate
		,revisionname
		,revisiondate
		)
	VALUES (
		'Metroplex Energy Inc.'
		,'Keith Hudson'
		,'employee'
		,NULL
		,'Employee'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ACTIVE'
		,'Keith Hudson'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		)
		,(
		'Metroplex Energy Inc.'
		,'Greg Ranallo'
		,'employee'
		,NULL
		,'Employee'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ACTIVE'
		,'Keith Hudson'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		),
		(
		'Metroplex Energy Inc.'
		,'Colby McKnight'
		,'employee'
		,NULL
		,'Employee'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ACTIVE'
		,'Colby McKnight'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		),
		(
		'Metroplex Energy Inc.'
		,'Tim Curry'
		,'employee'
		,NULL
		,'Employee'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ACTIVE'
		,'Tim Curry'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		)
END

--add qa userids
BEGIN
	INSERT INTO dbo.userid (
		userid
		,company
		,NAME
		,email
		,readonly
		,showcustomerprocessonly
		,STATUS
		,creationname
		,creationdate
		,revisionname
		,revisiondate
		)
	VALUES (
		'kehudson'
		,'Metroplex Energy Inc.'
		,'Keith Hudson'
		,'kehudson@racetrac.com'
		,0
		,0
		,'ACTIVE'
		,'Keith Hudson'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		)
		,(
		'granallo'
		,'Metroplex Energy Inc.'
		,'Greg Ranallo'
		,'granallo@racetrac.com'
		,0
		,0
		,'ACTIVE'
		,'Keith Hudson'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		),
		(
		'cmcknight'
		,'Metroplex Energy Inc.'
		,'Colby McKnight'
		,'cmcknight@racetrac.com'
		,0
		,0
		,'ACTIVE'
		,'Colby McKnight'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		)
		,(
		'tcurry'
		,'Metroplex Energy Inc.'
		,'Tim Curry'
		,'tcurry@racetrac.com'
		,0
		,0
		,'ACTIVE'
		,'Tim Curry'
		,CAST(GETDATE() AS DATETIME)
		,NULL
		,NULL
		)
END

--update Priyankar's user permissions
UPDATE userid
SET readonly = 0
WHERE userid = 'v-priyankardatta'

--configure approval access
BEGIN
	INSERT INTO [dbo].[approvalname]
		([approvaltype]
		,[approvalname]
		,[creationname]
		,[creationdate]
		,[revisionname]
		,[revisiondate])
	VALUES
						--KEITH
		('AR Approved'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('AR Pending'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('AR New'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('AP Approved'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('AP Pending'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('AP New'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('JE Approved'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('JE Pending'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('JE New'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('Pending Approval'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('Approved'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('New'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
		('Void'
		,'Keith Hudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL),
						--COLBY
		('AR Approved'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('AR Pending'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('AR New'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('AP Approved'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('AP Pending'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('AP New'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('JE Approved'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('JE Pending'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('JE New'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('Pending Approval'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('Approved'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('New'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
		('Void'
		,'Colby McKnight'
		,'Colby McKnight'
		,GETDATE()
		,NULL
		,NULL),
						--GREG
		('AR Approved'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('AR Pending'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('AR New'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('AP Approved'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('AP Pending'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('AP New'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('JE Approved'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('JE Pending'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('JE New'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('Pending Approval'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('Approved'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('New'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
		('Void'
		,'Greg Ranallo'
		,'Greg Ranallo'
		,GETDATE()
		,NULL
		,NULL),
						--TIM
		('AR Approved'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('AR Pending'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('AR New'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('AP Approved'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('AP Pending'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('AP New'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('JE Approved'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('JE Pending'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('JE New'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('Pending Approval'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('Approved'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('New'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL),
		('Void'
		,'Tim Curry'
		,'Tim Curry'
		,GETDATE()
		,NULL
		,NULL)
END

--configure security settings
BEGIN	
	INSERT INTO securityuser (securitygroup
		,userid
		,creationname
		,creationdate
		,revisionname
		,revisiondate)
	VALUES ('SysAdmin'
		,'kehudson'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL)
		,('SysAdmin'
		,'cmcknight'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL)
		,('SysAdmin'
		,'granallo'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL)
		,('SysAdmin'
		,'s-AllegroQA'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL)
		,('SysAdmin'
		,'tcurry'
		,'Keith Hudson'
		,GETDATE()
		,NULL
		,NULL)
END