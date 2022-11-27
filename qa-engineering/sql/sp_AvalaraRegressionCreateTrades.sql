USE [Allegro]
GO

/****** Object:  StoredProcedure [dbo].[sp_AvalaraRegressionCreateTrades]]    Script Date: 3/25/2020 11:22:25 AM ******/
IF (OBJECT_ID('sp_AvalaraRegressionCreateTrades') IS NOT NULL) DROP PROCEDURE [dbo].[sp_AvalaraRegressionCreateTrades]
GO

BEGIN
	EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'
		DELETE FROM trade WHERE creationname = 'Avalara Regression Automation'
		DELETE FROM position WHERE creationname = 'Avalara Regression Automation'
		DELETE FROM physicalposition WHERE creationname = 'Avalara Regression Automation'
		DELETE FROM physicalquantity WHERE creationname = 'Avalara Regression Automation'
		DELETE FROM fee WHERE creationname = 'Avalara Regression Automation'

	--position
	IF EXISTS (SELECT 1
				   FROM   INFORMATION_SCHEMA.COLUMNS
				   WHERE  TABLE_NAME = 'position'
						  AND COLUMN_NAME = 'id'
						  AND TABLE_SCHEMA='DBO')
	  BEGIN
		  ALTER TABLE position
			DROP COLUMN id
	  END
	ALTER TABLE position ADD id INT

	--physicalposition
	IF EXISTS (SELECT 1
				   FROM   INFORMATION_SCHEMA.COLUMNS
				   WHERE  TABLE_NAME = 'physicalposition'
						  AND COLUMN_NAME = 'id'
						  AND TABLE_SCHEMA='DBO')
	  BEGIN
		  ALTER TABLE physicalposition
			DROP COLUMN id
	  END
	ALTER TABLE physicalposition ADD id INT

	--physicalquantity
	IF EXISTS (SELECT 1
				   FROM   INFORMATION_SCHEMA.COLUMNS
				   WHERE  TABLE_NAME = 'physicalquantity'
						  AND COLUMN_NAME = 'id'
						  AND TABLE_SCHEMA='DBO')
	  BEGIN
		  ALTER TABLE physicalquantity
			DROP COLUMN id
	  END
	ALTER TABLE physicalquantity ADD id INT

	----fee
	IF EXISTS (SELECT 1
	               FROM   INFORMATION_SCHEMA.COLUMNS
	               WHERE  TABLE_NAME = 'fee'
	                      AND COLUMN_NAME = 'id'
	                      AND TABLE_SCHEMA='DBO')
	  BEGIN
	      ALTER TABLE fee
	        DROP COLUMN id
	  END
	ALTER TABLE fee ADD id INT
END

/****** Object:  StoredProcedure [dbo].[sp_AvalaraRegressionCreateTrades]    Script Date: 3/25/2020 11:22:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_AvalaraRegressionCreateTrades] (
	@dealtype VARCHAR(64)
)
AS
BEGIN

	DECLARE @ymd varchar(8)
	DECLARE @hms varchar(4)
	DECLARE @tradecountmax int
	DECLARE @firstdaycm DATETIME = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101) /* first day of current month */
	DECLARE @lastdaynm DATETIME = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+2,0)), 101) /* last day of next month */
	DECLARE @tradenummax VARCHAR(8)
	DECLARE @positionmax VARCHAR(8)
	DECLARE @posdetailmax VARCHAR(8)
	DECLARE @feemax VARCHAR(8)
	DECLARE @trade VARCHAR(8)
	DECLARE @tradeummax VARCHAR(8)
	DECLARE @contract VARCHAR(8)
	DECLARE @surrogatemax VARCHAR(8)
	DECLARE @phyquanmin INT = 1
	DECLARE @positioncountmax INT

	SELECT @ymd = CONVERT(varchar(8), GETDATE(), 112) --MODIFY AS NEEDED
	SELECT @hms = RIGHT('00' + CAST(DATEPART(hh, GETDATE()) AS varchar), 2) + RIGHT('00' + CAST(DATEPART(mi, GETDATE()) AS varchar), 2)
	SET @tradenummax = (SELECT MAX(CAST(t.trade AS NUMERIC)) + 1 FROM trade t)
	SET @dealtype = @dealtype

	---> number of unique 3rd party Rack Deal ln combos
	SELECT TOP 1 @tradecountmax = COUNT(*) OVER ()
		FROM mxe_loadingnumbers_mapping 
		WHERE dealtype = @dealtype
		GROUP BY terminal, customer, supplier


	/* INSERTS NEW TPR DEAL TRADE INTO ALLEGRO THEN ADDS TRADE DETAILS BASED ON LN MAPPING DATA ************/
	/*******************************************************************************************************/
	--START dbo.trade----------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	INSERT INTO [dbo].[trade] ([trade], [tradetype], [supplybbl], [tradedate], [company], [timeperiod], [begtime], [endtime], [timezone], [ferctransactionclass], [broker], [sourcetrade], [tradestatus], [contractprep], [status], [confirmstatus], [pricetype], [tradeclass], [counterpartytrade], [trader], [counterpartytrader], [brokertrader], [settlementfreq], [currency], [taxable], [evergreen], [evergreennotice], [evergreenrenewal], [internal], [internaltrade], [begdate], [enddate], [physicalexchange], [holidaycalendar], [titletransfer], [executetrade], [evergreenforecast], [fallback], [contractsymbol], [physicalbroker], [floorbroker], [electronicconfirmstatus], [cascadereference], [tradenote], [document], [calendar], [correspondence], [remark], [collaboration], [creationname], [creationdate], [revisionname], [revisiondate], [rt_confirmdate], [rt_prepayreceived], [rt_prepaydeal], [physicalbalance], [settlementquantity], [rt_exchangesettleunit])
	VALUES (@tradenummax, @dealtype, 0, GETDATE(), 'Metroplex Energy Inc.', CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + FORMAT(GETDATE(),'MM'), @firstdaycm, @lastdaynm, NULL, NULL, NULL, NULL, 'Approved', 0, 'ACTIVE', 'NEW', NULL, NULL, NULL, 'Avalara Regression Automation', NULL, NULL, 'MONTH', 'USD', 1, 0, NULL, NULL, 0, NULL, @firstdaycm, @lastdaynm, 0, 'US', 0, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, 'Avalara Regression Automation', 0, 0, 0, 0, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE(), NULL, 0, 0, 0, NULL, NULL)
	--END dbo.trade------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------


	/* start position handling */
	SELECT @trade = MAX(CAST(t.trade AS NUMERIC)) FROM trade t WHERE t.creationname = 'Avalara Regression Automation' AND t.tradetype = @dealtype
	SELECT @contract = MAX(CAST(c.contract AS NUMERIC)) FROM contract c WHERE c.creationname = 'Avalara Regression Automation'
	DECLARE @ninjarich AS VARCHAR(64);
	SELECT @ninjarich = COUNT(*) FROM position WHERE creationname = 'Avalara Regression Automation'
	IF @ninjarich != 0
	  BEGIN
		SET @positionmax = (SELECT MAX(CAST(p.position AS NUMERIC)) + 1 FROM position p WHERE p.creationname = 'Avalara Regression Automation');
		SET @posdetailmax = (SELECT MAX(CAST(pp.posdetail AS NUMERIC)) + 1 FROM physicalposition pp WHERE pp.creationname = 'Avalara Regression Automation');
	  END
	ELSE
	  BEGIN
		SET @positionmax = (SELECT MAX(CAST(p.position AS NUMERIC)) + 1 FROM position p);
		SET @posdetailmax = (SELECT MAX(CAST(pp.posdetail AS NUMERIC)) + 1 FROM physicalposition pp);
	  END
	SELECT @ninjarich AS 'position count', @trade AS 'trade', @positionmax AS 'positionmax', @posdetailmax AS 'posdetailmax' --<----TEST
	/* end position handling */


	--START dbo.position-------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	DECLARE @posmin INT = 1
	WHILE @posmin < @tradecountmax
	BEGIN TRY
	  --insert postion
	  INSERT INTO [dbo].[position] ([position], [prospectivetrade], [contract], [trade], [positionmode], [positiontype], [marketarea], [counterparty], [unit], [company], [product], [tradebook], [block], [exchange], [loadshape], [settlementdate], [paymentterms], [settlementcurrency], [optionposition], [optiontype], [optionstyle], [premium], [premiumduedate], [premiummethod], [optionfrequency], [expirationdate], [settlementunit], [production], [consumption], [strikeprice], [swingtolerance], [cycle], [rt_salelocation], [rt_rvp], [document], [calendar], [correspondence], [remark], [collaboration], [internalposition], [tradeexercise], [swaptype], [rt_loadingnumber], [rt_expecteddeliverymonth], [creationname], [creationdate], [revisionname], [revisiondate], [balancing], [rt_strategylvl1], [rt_strategylvl2], [rt_assignmentcode], [rt_tradecomment], [customtradecomment], [customtradecommentstatus], [rt_rinsincluded], [rt_notes], [mxe_closestatus]) 
	  VALUES (@positionmax, NULL, @contract, @trade, 'PHYSICAL', 'SELL', NULL /*update later*/, NULL /*update later*/, 'bbl', 'Metroplex Energy Inc.', 'CONV-87-E10', 'Physical Book', NULL, NULL, NULL, NULL, '10 Days After Delivery', 'USD', 0, NULL, NULL, 0.000000, NULL, 'VARIABLE', 'MONTH', NULL, 'gal', 0, 0, 0.000000, 0.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE(), 0, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, 'Open')
  
	  -- increment inner loop
	  SELECT @posmin = @posmin + 1
	  SELECT @positionmax = @positionmax + 1;
	  SELECT @posdetailmax = @posdetailmax + 1; 
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS [Error Message]
		,ERROR_LINE() AS ErrorLine
		,ERROR_NUMBER() AS [Error Number]  
		,ERROR_SEVERITY() AS [Error Severity]  
		,ERROR_STATE() AS [Error State]
	END CATCH
	--END dbo.position---------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------


	--> reset position ids
	;WITH a AS(
		SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, p.id
	FROM position p WHERE trade = @trade AND revisionname = @dealtype
	) 
	UPDATE a SET id=rn 


	--START dbo.physicalposition-----------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	DECLARE @positionmin INT
	SET @positionmin = (SELECT MIN(CAST(p.position AS NUMERIC)) FROM position p WHERE creationname = 'Avalara Regression Automation' AND revisionname = @dealtype AND trade = @trade)
	--SELECT @posdetailmax = MAX(CAST(pp.posdetail AS NUMERIC)) + 1 FROM physicalposition pp; 

	DECLARE @phyposmin INT = 1
	WHILE @phyposmin < @tradecountmax
	BEGIN TRY
	  --insert physicalposition
	  INSERT INTO [dbo].[physicalposition] ([position], [posdetail], [product], [location], [origin], [destination], [tank], [pile], [property], [totalquantity], [carrier], [delmethod], [incoterms], [custodychain], [forwardquantity], [hvunit], [feecode], [alternate], [decint], [evergreentermdate], [locationbasis], [productbasis], [demurragehours], [demurragerate], [demurragecurrency], [despatchrate], [demurrageunit], [ngcontract], [creationname], [creationdate], [revisionname], [revisiondate]) 
	  VALUES (@positionmin, @posdetailmax, 'CONV-87-E10', NULL /*update later*/, NULL, NULL, NULL, NULL, NULL, 100000000, NULL, 'RACK TRUCK', 'FOB', NULL, 0, NULL, NULL, 0, 1.00000000, NULL, NULL, NULL, NULL, NULL, 'USD', NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE())	
  
	  -- increment inner loop
	  SELECT @phyposmin = @phyposmin + 1
	  SELECT @positionmin = @positionmin + 1
	  SELECT @posdetailmax = @posdetailmax + 1
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS [Error Message]
		,ERROR_LINE() AS ErrorLine
		,ERROR_NUMBER() AS [Error Number]  
		,ERROR_SEVERITY() AS [Error Severity]  
		,ERROR_STATE() AS [Error State]
	END CATCH
	--END dbo.physicalposition-------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------


	SET @posdetailmax = (SELECT MIN(CAST(pp.posdetail AS NUMERIC)) FROM physicalposition pp WHERE pp.creationname = 'Avalara Regression Automation' AND revisionname = @dealtype AND pp.position IN (SELECT position FROM position WHERE trade = @trade AND revisionname = @dealtype))
	SET @surrogatemax = (SELECT MAX(CAST(pq.surrogate AS NUMERIC) + 1) FROM physicalquantity pq)
	SET @positionmin = (SELECT MIN(CAST(p.position AS NUMERIC)) FROM position p WHERE creationname = 'Avalara Regression Automation' AND revisionname = @dealtype AND trade = @trade)
	SELECT @positioncountmax = (SELECT COUNT(*) FROM position WHERE creationname = 'Avalara Regression Automation' AND revisionname = @dealtype AND trade = @trade)


	--START dbo.physicalquantity-----------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	WHILE @phyquanmin < @positioncountmax
	BEGIN TRY  
	  --insert physical quantity
	  INSERT INTO [dbo].[physicalquantity] ([position], [posdetail], [surrogate], [quantitytype], [begtime], [endtime], [component], [carriermode], [shipment], [cycle], [measure], [quantitystatus], [posstatus], [mass], [massunit], [volume], [volumeunit], [energy], [gravity], [energyunit], [gravityunit], [altquantity], [settlementexchangeflag], [altunit], [timeunit], [origshipment], [sched], [batchid], [creationname], [creationdate], [revisionname], [revisiondate], [rt_notes])
	  VALUES (@positionmin, @posdetailmax, @surrogatemax, 'DELIVERY', @firstdaycm, @lastdaynm, NULL  , NULL, NULL, NULL, NULL, 'TRADE', 0, 16979.0000, 'mt', 100000.0000, 'bbl', 0.0000, 1.00000000, NULL, 'API', 0.0000, 0, NULL, 'TOTAL', NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE(), NULL)
	  , (@positionmin, @posdetailmax, (@surrogatemax + 1), 'DELIVERY', @firstdaycm, @lastdaynm, NULL  , NULL, NULL, NULL, NULL, 'FORECAST', 1, 16979.0000, 'mt', 100000.0000, 'bbl', 0.0000, 1.00000000, NULL, 'API', 0.0000, 0, NULL, 'TOTAL', NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE(), NULL)

	  -- increment inner loops
	  SELECT @phyquanmin = @phyquanmin + 1
	  SELECT @posdetailmax = @posdetailmax + 1
	  SELECT @surrogatemax = @surrogatemax + 1
	  SELECT @positionmin = @positionmin + 1
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS [Error Message]
		,ERROR_LINE() AS ErrorLine
		,ERROR_NUMBER() AS [Error Number]  
		,ERROR_SEVERITY() AS [Error Severity]  
		,ERROR_STATE() AS [Error State]
	END CATCH
	--END dbo.physicalquantity-------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------


	--START dbo.fee------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	SET @positionmin = (SELECT MIN(CAST(p.position AS NUMERIC)) FROM position p WHERE creationname = 'Avalara Regression Automation' AND revisionname = @dealtype AND trade = @trade)
	SELECT @feemax = MAX(CAST(f.fee AS NUMERIC)) + 1 FROM fee f WHERE f.fee NOT LIKE '%[A-Z]%';

	DECLARE @feemin INT = 1
	WHILE @feemin < @tradecountmax
	BEGIN TRY
		--insert fee
	  INSERT INTO [dbo].[fee] ([fee], [dbcolumn], [dbvalue], [feemode], [feetype], [description], [company], [counterparty], [paystatus], [optionpricetype], [feecode], [unit], [priceindex], [pricelevel], [pricediff], [currency], [postdate], [postprice], [feemethod], [rt_nymex], [factor], [quantityfactor], [indexfactor], [feetier], [feeproduct], [feetimeperiod], [feesettlement], [feetag], [feegasprocessing], [functiontag], [internalfee], [rt_templatefee], [rt_mercbot], [creationname], [creationdate], [revisionname], [revisiondate]) 
	  VALUES (@feemax, 'POSITION', @positionmin, 'FIXED', NULL, NULL, 'Metroplex Energy Inc.', NULL /*update later*/, NULL, NULL, NULL, 'gal', NULL, 'AVG', 1.123456, 'USD', NULL, NULL, 'COMMODITY PRICE', NULL, 1.00000000, 1.00000000, 1.00000000, NULL, NULL, @feemax, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), @dealtype, GETDATE())

	  -- increment inner loop
	  SELECT @feemin = @feemin + 1
	  SELECT @feemax = @feemax + 1
	  SELECT @positionmin = @positionmin + 1
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS [Error Message]
		,ERROR_LINE() AS ErrorLine
		,ERROR_NUMBER() AS [Error Number]  
		,ERROR_SEVERITY() AS [Error Severity]  
		,ERROR_STATE() AS [Error State]
	END CATCH
	----END dbo.fee--------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------


	/* STAGE TEMP DATA *************************************************************************************/
	/*******************************************************************************************************/
	IF (OBJECT_ID('tempdb..#loadingnumbers') IS NOT NULL)
	  DROP TABLE #loadingnumbers
	IF (OBJECT_ID('tempdb..#counterparty') IS NOT NULL)
	  DROP TABLE #counterparty
	IF (OBJECT_ID('tempdb..#location') IS NOT NULL)
	  DROP TABLE #location

	---> #loadingnumbers
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
	WHERE m.dealtype = @dealtype
	---> #counterparty
	SELECT
	  cp.counterparty,
	  i.interface INTO #counterparty
	FROM dbo.interface i
	INNER JOIN dbo.counterparty cp
	  ON i.collaboration = cp.collaboration
	WHERE interfaceclass = 'PDIID'
	AND dbtable = 'counterparty'
	---> #location
	SELECT
	  l.location,
	  i.interface INTO #location
	FROM interface i
	JOIN location l
	  ON l.collaboration = i.collaboration
	WHERE interfaceclass = 'PDIID'
	AND i.dbtable = 'location'

	/* CLEAN UP & MAP TEMP DATA ****************************************************************************/
	/*******************************************************************************************************/
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
	  LEFT JOIN #counterparty c
		ON c.counterparty = ln.customer
	  LEFT JOIN #location l
		ON l.location = ln.terminal

	--update RT & MXE ids	  
	UPDATE #loadingnumbers  
	SET counterpartyid = CASE customer  
	WHEN 'RaceTrac' THEN '640010'  
	WHEN 'Metroplex Energy Inc.' THEN '640009'  
	END
  
	UPDATE #loadingnumbers  
	SET companyid = CASE supplier  
	WHEN 'RaceTrac' THEN '640010'  
	WHEN 'Metroplex Energy Inc.' THEN '640009'  
	END

	--update locations
	MERGE INTO #loadingnumbers ln
	   USING #location l 
		  ON ln.terminal = l.location 
	WHEN MATCHED THEN
	   UPDATE 
		  SET locationid = l.interface;

	--update counterparty/company
	MERGE INTO #loadingnumbers ln
	   USING #counterparty cp 
		  ON ln.customer = cp.counterparty
	WHEN MATCHED THEN
	   UPDATE 
		  SET counterpartyid = cp.interface,
		  companyid = cp.interface;
	----END STAGE DATA-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------


	---> resets rowid to 1 if needed
	SELECT
	  *,
	  ROW_NUMBER() OVER (ORDER BY rowid) AS 'rowcount'
	FROM #loadingnumbers

	--> reset all new ids 
		--position
		;WITH a AS(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, p.id
		FROM position p WHERE trade = @trade AND revisionname = @dealtype
		) 
		UPDATE a SET id=rn
		OPTION (MAXDOP 1)
		--physicalposition
		;WITH b AS(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, pp.id
		FROM physicalposition pp WHERE pp.position IN (SELECT position FROM position WHERE trade = @trade AND revisionname = @dealtype)
		) 
		UPDATE b SET id=rn
		OPTION (MAXDOP 1)
		--physicalquantity
		;WITH c AS(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, pq.id
		FROM physicalquantity pq WHERE pq.position IN (SELECT position FROM position WHERE trade = @trade AND revisionname = @dealtype)
		) 
		UPDATE c SET id=rn
		OPTION (MAXDOP 1)
		--fee
		;WITH d AS(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, f.id
		FROM fee f WHERE f.fee IN (SELECT fee FROM position WHERE trade = @trade AND revisionname = @dealtype)
		) 
		UPDATE d SET id=rn
		OPTION (MAXDOP 1)


	/* UPDATE EACH CREATED TRADE DETAIL ROW IN EACH TABLE WITH DATA FROM LN MAPPING ************************/
	/*******************************************************************************************************/
	--position
	ALTER TABLE position NOCHECK CONSTRAINT ALL
		UPDATE position
		SET position.counterparty = ln.customer
		FROM position p
		INNER JOIN #loadingnumbers ln ON p.id = ln.rowid
	--physicalposition
	ALTER TABLE physicalposition NOCHECK CONSTRAINT ALL
		UPDATE physicalposition
		SET physicalposition.location = ln.terminal
		FROM physicalposition pp
		INNER JOIN #loadingnumbers ln ON pp.id = ln.rowid
	--fee
	ALTER TABLE fee NOCHECK CONSTRAINT ALL
		UPDATE fee
		SET fee.counterparty = ln.customer
		FROM fee f
		INNER JOIN #loadingnumbers ln ON f.id = ln.rowid


	/* UPDATE EACH POSITION'S MARKET AREA BASED ON PHYSICALQUANTITY.LOCATION *******************************/
	/*******************************************************************************************************/
	;WITH CTE_Locations
	AS (SELECT DISTINCT
	  pp.position,
	  pp.posdetail,
	  l.location,
	  l.marketarea
	FROM location l
	INNER JOIN physicalposition pp
	  ON pp.location = l.location
	WHERE pp.creationname = 'Avalara regression Automation'
	AND pp.revisionname = @dealtype)
	UPDATE position
	SET position.marketarea = CTE_Locations.marketarea
	FROM CTE_Locations
	INNER JOIN position
	  ON position.position = CTE_Locations.position;

	--update credit limit to prevent allocation errors
	UPDATE creditlimit SET creditstatus = 'APPROVED', exposurelimit = '100000000.00'

	/* UPDATE EACH POSITION W/CHILD VENDORS ****************************************************************/
	/*******************************************************************************************************/
	;WITH CTE_Locations
	AS (SELECT DISTINCT
	  pp.position,
	  pp.posdetail,
	  l.location,
	  l.marketarea
	FROM location l
	INNER JOIN physicalposition pp
	  ON pp.location = l.location
	WHERE pp.creationname = 'Avalara regression Automation'
	AND pp.revisionname = @dealtype)
	UPDATE position
	SET position.marketarea = CTE_Locations.marketarea
	FROM CTE_Locations
	INNER JOIN position
	  ON position.position = CTE_Locations.position;

END