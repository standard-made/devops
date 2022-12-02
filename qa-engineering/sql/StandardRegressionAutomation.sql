

DROP TABLE IF EXISTS dbo.STANDARDautomation_findetail_prodtemp; 
DROP TABLE IF EXISTS dbo.STANDARDautomation_findetail_uatemp;
DECLARE @valuation AS VARCHAR(10);
SET @valuation = (SELECT TOP 1 valuation
	FROM valuation v
	WHERE EXISTS (SELECT 1 FROM valuationmode vm 
		WHERE vm.valuationmode = v.valuationmode 
		AND vm.valuationmode = 'Settlement - Manual')
	ORDER BY revisiondate DESC);

SELECT * FROM STANDARDautomation_findetail_uatemp
--PROD
BEGIN
	SELECT * INTO STANDARDautomation_findetail_prodtemp FROM findetail
	WHERE posdetail IN (SELECT 
		DISTINCT posdetail
	FROM valuationdetail
	WHERE valuation = 110342) --@valuation
END


--UA
BEGIN
	SELECT * INTO STANDARDautomation_findetail_uatemp FROM findetail
	WHERE posdetail IN (SELECT 
		DISTINCT posdetail
	FROM valuationdetail
	WHERE valuation = 110343) --@valuation
END

--COMPARE
SELECT ua.findetail
FROM STANDARDautomation_findetail_uatemp ua
WHERE NOT EXISTS (SELECT prod.findetail 
FROM STANDARDautomation_findetail_prodtemp prod
WHERE ua.findetail = prod.findetail);


/* TPR DAY DEAL */
BEGIN
	WITH CTE_DayTradeInfo AS (
	SELECT DISTINCT terminal, customer, supplier 
	FROM mxe_loadingnumbers_mapping 
	WHERE dealtype = 'Third Party Rack Day Deal' 
	GROUP BY terminal, customer, supplier
	)
	SELECT t.* FROM trade t 
	INNER JOIN position p ON t.trade = p.trade 
	INNER JOIN physicalposition pp ON p.position = pp.position
	WHERE t.tradetype LIKE 'Third Party Rack%'
	AND pp.location IN (SELECT DISTINCT terminal FROM CTE_DayTradeInfo)
	AND p.counterparty IN (SELECT DISTINCT customer FROM CTE_DayTradeInfo)
	AND t.company IN (SELECT DISTINCT supplier FROM CTE_DayTradeInfo)
	AND t.tradestatus = 'Approved' AND t.taxable = 1
	AND YEAR(t.tradedate) >= YEAR(GETDATE()) - 1
	ORDER BY t.enddate DESC
END


/* TPR TERM DEAL */
BEGIN
	WITH CTE_TermTradeInfo AS (
	SELECT DISTINCT terminal, customer, supplier 
	FROM mxe_loadingnumbers_mapping 
	WHERE dealtype = 'Third Party Rack Term Deal' 
	GROUP BY terminal, customer, supplier
	)
	SELECT DISTINCT t.* FROM trade t 
	INNER JOIN position p ON t.trade = p.trade 
	INNER JOIN physicalposition pp ON p.position = pp.position
	WHERE t.tradetype = 'Third Party Rack Term Deal'
	AND pp.location IN (SELECT DISTINCT terminal FROM CTE_TermTradeInfo)
	AND p.counterparty IN (SELECT DISTINCT customer FROM CTE_TermTradeInfo)
	AND t.company IN (SELECT DISTINCT supplier FROM CTE_TermTradeInfo)
	AND t.tradestatus = 'Approved' AND t.taxable = 1
	ORDER BY t.enddate DESC
END


/* ALL NEW/APPROVED TRADE DEALS WITHIN THE LAST YEAR */
BEGIN
	DECLARE @firstdaycm DATETIME = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101) /* first day of current month */
	DECLARE @lastdaynm DATETIME = CONVERT(VARCHAR(10),DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+2,0)), 101) /* last day of next month */
	DECLARE @currentmonth VARCHAR(7) = CONVERT(VARCHAR(7), @firstdaycm, 126);

	WITH CTE_TermTradeInfo AS (
	SELECT DISTINCT terminal, customer, supplier 
	FROM mxe_loadingnumbers_mapping 
	--WHERE dealtype LIKE 'Third Party Rack%' 
	GROUP BY terminal, customer, supplier
	)
	UPDATE trade SET begtime = @firstdaycm, begdate = @firstdaycm, endtime = @lastdaynm
		, enddate = @lastdaynm, tradedate = @firstdaycm, timeperiod = @currentmonth
		, revisiondate = GETDATE(), revisionname = 'STANDARD Regression Automation'
		, tradestatus = 'Approved', confirmstatus = 'NEW'
	FROM trade t 
	INNER JOIN position p ON t.trade = p.trade 
	INNER JOIN physicalposition pp ON p.position = pp.position
	WHERE t.tradetype LIKE 'Third Party Rack%'
	AND pp.location IN (SELECT DISTINCT terminal FROM CTE_TermTradeInfo)
	AND p.counterparty IN (SELECT DISTINCT customer FROM CTE_TermTradeInfo)
	AND t.company IN (SELECT DISTINCT supplier FROM CTE_TermTradeInfo)
	AND t.tradestatus IN ('Approved', 'NEW') AND t.taxable = 1
	AND YEAR(tradedate) BETWEEN YEAR(GETDATE())-1 AND YEAR(GETDATE())+1

	DECLARE @newcontract VARCHAR(8)
	DECLARE @deliverymonth VARCHAR(7) = CONVERT(VARCHAR(7), @lastdaynm, 126)
	SELECT @newcontract = MAX(CAST(c.contract AS NUMERIC)) FROM contract c WHERE c.creationname = 'STANDARD Regression Automation';

	UPDATE position SET contract = @newcontract, product = 'CONV-87-E10', rt_expecteddeliverymonth = @deliverymonth
	, revisiondate = GETDATE(), revisionname = 'STANDARD Regression Automation' 
	WHERE trade IN (SELECT trade FROM trade WHERE revisionname = 'STANDARD Regression Automation')
END

--------------------------------------------------------------------------
--------------------------------------------------------------------------
DECLARE @test int
SELECT @test = MAX(CAST(t.trade AS NUMERIC)) FROM trade t WHERE creationdate >= CAST(GETDATE()-1 AS DATE) AND creationname = 'STANDARD Regression Automation'
SELECT @test
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--CREATES DELETE STATEMENTS BASED ON TABLE CONSTRAINTS
Declare @sql1 varchar(max)
      , @ptn1 varchar(200)
      , @ctn1 varchar(200)
      , @ptn2 varchar(200)
      , @ctn2 varchar(200)
--
SET @ptn1 = ''
--
SET @ctn1 = ''
--
SET @ptn2 = ''
--
SET @ctn2 = ''
--
SELECT @sql1 = case when (@ptn1 <> OBJECT_NAME (f.referenced_object_id)) then
                         COALESCE( @sql1 + char(10), '') + 'DELETE' + char(10) + ' ' + OBJECT_NAME (f.referenced_object_id) + ' FROM ' + OBJECT_NAME(f.parent_object_id) + ', '+OBJECT_NAME (f.referenced_object_id) + char(10) +' WHERE ' + OBJECT_NAME(f.parent_object_id) + '.' + COL_NAME(fc.parent_object_id, fc.parent_column_id) +'='+OBJECT_NAME (f.referenced_object_id)+'.'+COL_NAME(fc.referenced_object_id, fc.referenced_column_id)
                    else
                         @sql1 + ' AND ' + OBJECT_NAME(f.parent_object_id) + '.' + COL_NAME(fc.parent_object_id, fc.parent_column_id) +'='+OBJECT_NAME (f.referenced_object_id)+'.'+COL_NAME(fc.referenced_object_id, fc.referenced_column_id)
                    end + char(10)
     , @ptn1 = OBJECT_NAME (f.referenced_object_id)
     , @ptn2  = object_name(f.parent_object_id)
FROM   sys.foreign_keys AS f
       INNER JOIN
       sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id
WHERE  f.parent_object_id = OBJECT_ID('dbo.physicalposition'); -- CHANGE here schema.table_name
--
print  '--Table Depended on ' + @ptn2 + char(10) + @sql1



--PROD
IF (OBJECT_ID('tempdb..#STANDARDautomation_findetail_prodtemp') IS NOT NULL) DROP TABLE #STANDARDautomation_findetail_prodtemp
DECLARE @valuation1 AS VARCHAR(10); SET @valuation1 = (SELECT TOP 1 valuation FROM valuation v
WHERE EXISTS (SELECT 1 FROM valuationmode vm WHERE vm.valuationmode = v.valuationmode AND vm.valuationmode = 'Settlement - Manual')
ORDER BY revisiondate DESC); BEGIN SELECT * INTO #STANDARDautomation_findetail_prodtemp FROM findetail
WHERE posdetail IN (SELECT DISTINCT posdetail FROM valuationdetail WHERE valuation = @valuation1) END

--UA
IF (OBJECT_ID('tempdb..#STANDARDautomation_findetail_prodtemp') IS NOT NULL) DROP TABLE #STANDARDautomation_findetail_prodtemp
DECLARE @valuation2 AS VARCHAR(10); SET @valuation2 = (SELECT TOP 1 valuation FROM valuation v
WHERE EXISTS (SELECT 1 FROM valuationmode vm WHERE vm.valuationmode = v.valuationmode AND vm.valuationmode = 'Settlement - Manual')
ORDER BY revisiondate DESC); BEGIN SELECT * INTO #STANDARDautomation_findetail_prodtemp FROM findetail
WHERE posdetail IN (SELECT DISTINCT posdetail FROM valuationdetail WHERE valuation = @valuation2) END


--COMPARE
SELECT findetail FROM STANDARDautomation_findetail_prodtemp prod WHERE NOT EXISTS
    (SELECT ua.* FROM STANDARDautomation_findetail_uatemp ua WHERE prod.findetail = ua.findetail);
SELECT COUNT(findetail) FROM STANDARDautomation_findetail_prodtemp prod WHERE NOT EXISTS
    (SELECT ua.* FROM STANDARDautomation_findetail_uatemp ua WHERE prod.findetail = ua.findetail);






	SELECT DISTINCT COUNT(rt_ticket) FROM findetail
	WHERE position IN (SELECT 
		DISTINCT posdetail
	FROM valuationdetail
	WHERE valuation = 110342) AND CAST(creationdate AS DATE) = CAST(GETDATE() AS DATE) AND fintransact IS NULL

	SELECT TOP 1 * FROM valuationdetail