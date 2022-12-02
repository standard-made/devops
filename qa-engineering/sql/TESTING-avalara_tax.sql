DECLARE @ymd varchar(8)
DECLARE @hms varchar(4)
DECLARE @tradecountmax int
DECLARE @dealtype VARCHAR(64)
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
SET @dealtype = 'Third Party Rack Deal'

---> number of unique 3rd party Rack Deal ln combos
SELECT TOP 1 @tradecountmax = COUNT(*) OVER ()
	FROM mxe_loadingnumbers_mapping 
	WHERE dealtype = @dealtype
	GROUP BY terminal, customer, supplier

SET @posdetailmax = (SELECT MIN(CAST(pp.posdetail AS NUMERIC)) FROM physicalposition pp WHERE pp.creationname = 'STANDARD Regression Automation')
SET @surrogatemax = (SELECT MAX(CAST(pq.surrogate AS NUMERIC)+1) FROM physicalquantity pq)
DECLARE @positionmin INT
SET @positionmin = (SELECT MIN(CAST(p.position AS NUMERIC)) FROM position p WHERE creationname = 'STANDARD Regression Automation')
SELECT @positioncountmax = (SELECT COUNT(*) FROM position WHERE creationname = 'STANDARD Regression Automation')
SELECT @phyquanmin, @positioncountmax, @positionmin, @posdetailmax, @surrogatemax
--dbo.physicalquantity
WHILE @phyquanmin < @positioncountmax
BEGIN TRY  
  --insert physical quantity
  INSERT INTO [dbo].[physicalquantity] ([position], [posdetail], [surrogate], [quantitytype], [begtime], [endtime], [component], [carriermode], [shipment], [cycle], [measure], [quantitystatus], [posstatus], [mass], [massunit], [volume], [volumeunit], [energy], [gravity], [energyunit], [gravityunit], [altquantity], [settlementexchangeflag], [altunit], [timeunit], [origshipment], [sched], [batchid], [creationname], [creationdate], [revisionname], [revisiondate], [rt_notes])
  VALUES (@positionmin, @posdetailmax, @surrogatemax, 'DELIVERY', @firstdaycm, @lastdaynm, NULL  , NULL, NULL, NULL, NULL, 'TRADE', 0, 16979.0000, 'mt', 100000.0000, 'bbl', 0.0000, 1.00000000, NULL, 'API', 0.0000, 0, NULL, 'TOTAL', NULL, NULL, NULL, 'STANDARD Regression Automation', GETDATE(), NULL, NULL, NULL)
  , (@positionmin, @posdetailmax, (@surrogatemax + 1), 'DELIVERY', @firstdaycm, @lastdaynm, NULL  , NULL, NULL, NULL, NULL, 'FORECAST', 1, 16979.0000, 'mt', 100000.0000, 'bbl', 0.0000, 1.00000000, NULL, 'API', 0.0000, 0, NULL, 'TOTAL', NULL, NULL, NULL, 'STANDARD Regression Automation', GETDATE(), NULL, NULL, NULL)

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

--TEST---------------------------------------------------------------------------------------------------
SELECT @phyquanmin AS 'number of dbo.physicalquantity rows inserted'
SELECT * FROM physicalquantity WHERE creationname = 'STANDARD Regression Automation' AND revisionname LIKE 'Third Party Rack%' ORDER BY position
---------------------------------------------------------------------------------------------------------


/* TESTING ********************************************************/
/******************************************************************/
BEGIN	
	--SUCCESS
	SELECT s.validation, m.dealtype, COUNT(*) AS 'count', 'SUCCESS' AS 'status' FROM rt_dtnfueladminstaging s 
	LEFT JOIN mxe_loadingnumbers_mapping m ON m.loadingnumber = s.destinationcustomernum 
	WHERE s.processed IS NOT NULL GROUP BY m.dealtype, s.validation HAVING COUNT(*) >= 1 
	UNION 
	--ERROR
	SELECT LEFT(s.validation, 25), m.dealtype, COUNT(*) AS 'count', 'ERROR' AS 'status' FROM rt_dtnfueladminstaging s 
	LEFT JOIN mxe_loadingnumbers_mapping m ON m.loadingnumber = s.destinationcustomernum 
	WHERE s.processed IS NULL AND s.validation IS NOT NULL
	GROUP BY m.dealtype, LEFT(s.validation, 25) HAVING COUNT(*) >= 1 
	UNION
	--NOT PROCESSED
	SELECT LEFT(s.validation, 25), m.dealtype, COUNT(*) AS 'count', 'NOT PROCESSED' AS 'status' FROM rt_dtnfueladminstaging s 
	LEFT JOIN mxe_loadingnumbers_mapping m ON m.loadingnumber = s.destinationcustomernum 
	WHERE s.processed IS NULL AND s.validation IS NULL
	GROUP BY m.dealtype, LEFT(s.validation, 25) HAVING COUNT(*) >= 1 ORDER BY 'status', m.dealtype, 'count' DESC
END
/******************************************************************/
/******************************************************************/

--DEBUG
SELECT COUNT(*) FROM rt_dtnfueladminstaging WHERE processed IS NOT NULL
UPDATE rt_dtnfueladminstaging SET validation = NULL WHERE processed IS NULL
SELECT m.dealtype, COUNT(*) AS 'count', 'SUCCESS' AS 'status' FROM rt_dtnfueladminstaging s 
	INNER JOIN mxe_loadingnumbers_mapping m ON m.loadingnumber = s.destinationcustomernum 
	WHERE s.processed IS NULL GROUP BY m.dealtype

SELECT s.validation, m.dealtype, s.destinationcustomernum, s.supplier, s.terminalname, 
	s.destinationstate, s.tdtnownername, s.carriername, s.carrierscac, s.metroplexiscustomer
FROM rt_dtnfueladminstaging s LEFT JOIN mxe_loadingnumbers_mapping m ON m.loadingnumber = s.destinationcustomernum 
WHERE s.processed IS NULL AND validation IS NOT NULL ORDER BY s.validation
--Third Party Rack Deal
--Exchange
--Rack Contract Purchase

SELECT * FROM classevent WHERE name = 'UpdateTradeExecution_BeforeWS_3' 

SELECT * FROM creditlimit
UPDATE creditlimit SET creditstatus = 'APPROVED', exposurelimit = '100000000.00'

/******************************************************************/