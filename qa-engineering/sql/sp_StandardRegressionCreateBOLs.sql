USE [STANDARD]
GO

--/****** Object:  StoredProcedure [dbo].[sp_STANDARDRegressionCreateBOLs]]    Script Date: 3/26/2020 11:22:25 AM ******/
--IF (OBJECT_ID('sp_STANDARDRegressionCreateBOLs') IS NOT NULL) DROP PROCEDURE [dbo].[sp_STANDARDRegressionCreteBOLs]
--GO

--/****** Object:  StoredProcedure [dbo].[sp_STANDARDRegressionCreateBOLs]    Script Date: 3/26/2020 11:22:25 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROC [dbo].[sp_STANDARDRegressionCreateBOLs]
--AS
BEGIN

	DELETE FROM rt_dtnfueladminstaging WHERE creationname = 'STANDARD Regression Automation'

	DECLARE @ymd varchar(8)
	DECLARE @hms varchar(4)
	DECLARE @loadmax int
	DECLARE @loadmin int = 1
	DECLARE @loadid int = 1
	SELECT
	  @ymd = CONVERT(varchar(8), GETDATE(), 112)
	SELECT
	  @hms = RIGHT('00' + CAST(DATEPART(hh, GETDATE()) AS varchar), 2) + RIGHT('00' + CAST(DATEPART(mi, GETDATE()) AS varchar), 2)
	SELECT
	  @loadmax = COUNT(*)
	FROM mxe_loadingnumbers_mapping m
	JOIN mxe_loadingnumbers_dealgrouping dgi
	  ON dgi.dealtype = m.dealtype
	JOIN mxe_loadingnumbers_dealgroups dg
	  ON dg.dealgroup = dgi.dealgroup
	LEFT JOIN mxe_rackpricingmarket pm
	  ON pm.mxe_rackpricingmarket = m.pricingmarketsurrogate
	WHERE m.active = 1
	IF (OBJECT_ID('tempdb..#loadingnumbers') IS NOT NULL)
	  DROP TABLE #loadingnumbers
	IF (OBJECT_ID('tempdb..#counterparty') IS NOT NULL)
	  DROP TABLE #counterparty
	IF (OBJECT_ID('tempdb..#location') IS NOT NULL)
	  DROP TABLE #location
	SELECT
	  IDENTITY(int) AS rowid,
	  m.loadingnumber,
	  m.terminal,
	  NULL AS 'locationid',
	  m.customer,
	  NULL AS 'counterpartyid',
	  m.supplier,
	  NULL AS 'companyid',
	  destinationstate,
	  destinationcounty,
	  destinationcity,
	  destinationstore INTO #loadingnumbers
	FROM mxe_loadingnumbers_mapping m
	JOIN mxe_loadingnumbers_dealgrouping dgi
	  ON dgi.dealtype = m.dealtype
	JOIN mxe_loadingnumbers_dealgroups dg
	  ON dg.dealgroup = dgi.dealgroup
	LEFT JOIN mxe_rackpricingmarket pm
	  ON pm.mxe_rackpricingmarket = m.pricingmarketsurrogate
	WHERE m.active = 1
	SELECT
	  cp.counterparty,
	  i.interface INTO #counterparty
	FROM dbo.interface i
	INNER JOIN dbo.counterparty cp
	  ON i.collaboration = cp.collaboration
	WHERE interfaceclass = 'PDIID'
	AND dbtable = 'counterparty'
	SELECT
	  l.location,
	  i.interface INTO #location
	FROM interface i
	JOIN location l
	  ON l.collaboration = i.collaboration
	WHERE interfaceclass = 'PDIID'
	AND i.dbtable = 'location'
	INSERT INTO #loadingnumbers
	  SELECT
		ln.loadingnumber,
		ln.terminal AS 'location',
		l.interface,
		ln.customer AS 'counterparty',
		c.interface,
		ln.supplier AS 'company',
		c.interface,
		destinationstate,
		destinationcounty,
		destinationcity,
		destinationstore
	  FROM #loadingnumbers ln
	  INNER JOIN #counterparty c
		ON c.counterparty = ln.customer
	  INNER JOIN #location l
		ON l.location = ln.terminal
	SELECT
	  *,
	  ROW_NUMBER() OVER (ORDER BY rowid) AS 'rowcount'
	FROM #loadingnumbers
	TRUNCATE TABLE rt_dtnfueladminstaging
	WHILE @loadmin < @loadmax
	BEGIN
	  INSERT INTO [dbo].[rt_dtnfueladminstaging] ([rowid], [fk_extractlog], [transmissionid], [transmissiondate], [supplier]
	  , [transmissiondatetime], [transmissionstatus], [transmissiontime], [terminalname], [splc]
	  , [terminalcontrolnum], [carriername], [carrierscac], [carrierfein], [drivernum], [vehicletype]
	  , [vehiclenumber], [destinationcustomername], [destinationcustomernum], [destinationaddress], [destinationcity]
	  , [destinationstate], [destinationcode], [customernum_additional], [bol_number], [bol_date], [ponumber], [invoicenumber]
	  , [releasenumber], [gateindate], [gateintime], [startloaddate], [startloadtime], [endloaddate], [endloadtime]
	  , [productdescription], [productcode], [unitofmeasure], [grossgallons], [netgallons], [temperature], [gravity]
	  , [apigravity], [specificgravity], [tdtnownername], [supplierdefinedterminal], [tdtnbrandindicator], [supplierdefinedproduct]
	  , [reserved1], [reserved2], [reserved3], [reserved4], [reserved5], [reserved6], [reserved7], [reserved8], [reserved9]
	  , [metroplexiscustomer], [processedforSTANDARD], [processed], [pdi_processeddate], [validation], [creationname], [creationdate]
	  , [revisionname], [revisiondate], [mxe_note])
		VALUES (@loadmin, '137137', CAST((ROUND((RAND() * 1000000), 0)) AS varchar(6)) + CONVERT(varchar(8), GETDATE(), 112), @ymd, '', GETDATE(), '', @hms, '', '', '', 600060, 'ENYD', 0000000000, 000137137, 'T', 000137, '', '', '', '', '', '', 137137, '', '', '', '', '', '', '', @ymd, @hms, @ymd, @hms, 'CONV-87-E10', NULL, 'G', 1000, 1000, '', '', '', '', ''/* destination state + location */, '', '', 'D8G', '', '', '', '', '', '', '', '', '', 1, GETDATE(), NULL, NULL, '', 'STANDARD Regression Automation', GETDATE(), NULL, NULL, '')
	  SELECT
		@loadmin = @loadmin + 1
	  SELECT
		@loadid = @loadid + 1
	END
	/* update temp */
	UPDATE #loadingnumbers
	SET counterpartyid =
						CASE customer
						  WHEN 'RaceTrac' THEN '640010'
						  WHEN 'Metroplex Energy Inc.' THEN '640009'
						END
	UPDATE #loadingnumbers
	SET companyid =
				   CASE supplier
					 WHEN 'RaceTrac' THEN '640010'
					 WHEN 'Metroplex Energy Inc.' THEN '640009'
				   END
	MERGE INTO #loadingnumbers ln
	USING #location l
	ON ln.terminal = l.location
	WHEN MATCHED THEN
	UPDATE
	SET locationid = l.interface;
	MERGE INTO #loadingnumbers ln
	USING #counterparty cp
	ON ln.customer = cp.counterparty
	WHEN MATCHED THEN
	UPDATE
	SET counterpartyid = cp.interface;
	MERGE INTO #loadingnumbers ln
	USING #counterparty cp
	ON ln.supplier = cp.counterparty
	WHEN MATCHED THEN
	UPDATE
	SET companyid = cp.interface;
	UPDATE rt_dtnfueladminstaging
	SET rt_dtnfueladminstaging.destinationcustomernum = ln.loadingnumber,
		rt_dtnfueladminstaging.supplier = ln.companyid,
		rt_dtnfueladminstaging.terminalname = CAST(ln.locationid AS varchar(80)),
		rt_dtnfueladminstaging.destinationcity = ln.destinationcity,
		rt_dtnfueladminstaging.destinationstate = CAST(ln.destinationstate AS varchar(2)),
		rt_dtnfueladminstaging.tdtnownername = ln.destinationstate + ' ' + ln.terminal,
		rt_dtnfueladminstaging.destinationcode = ln.loadingnumber,
		rt_dtnfueladminstaging.bol_number = CAST(ABS(CHECKSUM(NEWID()) % 1000000) AS varchar(10)) + ln.destinationstate
	FROM rt_dtnfueladminstaging dtn
	INNER JOIN #loadingnumbers ln
	  ON dtn.rowid = ln.rowid
	/* ris */
	UPDATE rt_dtnfueladminstaging
	SET supplier = '640009',
		carriername = '600060',
		carrierscac = 'ENYD',
		carrierfein = '0000000000',
		drivernum = '00000137',
		vehicletype = 'T',
		metroplexiscustomer = 1
	WHERE destinationcustomernum IN (SELECT
	  loadingnumber
	FROM mxe_loadingnumbers_mapping
	WHERE dealtype = 'Rack Inventory Sale')
	/* tprs */
	UPDATE rt_dtnfueladminstaging
	SET supplier = '640009',
		splc = '497800',
		carriername = '600111',
		carrierscac = 'CWCL',
		carrierfein = '0000000000',
		drivernum = '00001137',
		vehicletype = 'T',
		destinationcity = '',
		destinationcode = '',
		metroplexiscustomer = 0
	WHERE destinationcustomernum IN (SELECT
	  loadingnumber
	FROM mxe_loadingnumbers_mapping
	WHERE dealtype LIKE 'Third Party%')
	/* child vendor handling */
	IF (OBJECT_ID('tempdb..#childvendors') IS NOT NULL)
	  DROP TABLE #childvendors
	SELECT
	  cv.childvendor,
	  cv.supplier INTO #childvendors
	FROM dbo.mxe_counterpartychildvendors cv
	UPDATE rt_dtnfueladminstaging
	SET rt_dtnfueladminstaging.supplier = cv.supplier
	FROM rt_dtnfueladminstaging dtn
	INNER JOIN mxe_loadingnumbers_mapping ln
	  ON ln.loadingnumber = dtn.destinationcustomernum
	INNER JOIN #childvendors cv
	  ON cv.childvendor = ln.supplier

END



/* TESTING ***********************************************/
--SELECT processed, * FROM rt_dtnfueladminstaging r ORDER BY r.processed DESC

--SELECT * FROM pricevalue WHERE CAST(creationdate AS DATE) = CAST(GETDATE() AS DATE)

--SELECT dealtype, COUNT(*) AS 'count' FROM mxe_loadingnumbers_mapping GROUP BY dealtype HAVING COUNT(*) > 1 ORDER BY 'count' DESC
/*********************************************************/