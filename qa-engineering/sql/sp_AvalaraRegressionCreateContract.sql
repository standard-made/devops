USE [Allegro]
GO

/****** Object:  StoredProcedure [dbo].[sp_AvalaraRegressionCreateContract]]    Script Date: 3/26/2020 11:22:25 AM ******/
IF (OBJECT_ID('sp_AvalaraRegressionCreateContract') IS NOT NULL) DROP PROCEDURE [dbo].[sp_AvalaraRegressionCreateContract]
GO

BEGIN
	IF EXISTS (SELECT 1
					FROM   INFORMATION_SCHEMA.COLUMNS
					WHERE  TABLE_NAME = 'contractparty'
							AND COLUMN_NAME = 'id'
							AND TABLE_SCHEMA='DBO')
		BEGIN
			ALTER TABLE contractparty
			DROP COLUMN id
		END
	ALTER TABLE contractparty ADD id INT
END

/****** Object:  StoredProcedure [dbo].[sp_AvalaraRegressionCreateContract]    Script Date: 3/26/2020 11:22:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_AvalaraRegressionCreateContract]
AS
BEGIN

	DELETE FROM contract WHERE  CAST(creationdate AS DATE) >= CAST(GETDATE()-7 AS DATE) AND creationname = 'Avalara Regression Automation'
	DELETE FROM contractacctg WHERE  CAST(creationdate AS DATE) >= CAST(GETDATE()-7 AS DATE) AND creationname = 'Avalara Regression Automation'
	DELETE FROM contractparty WHERE  CAST(creationdate AS DATE) >= CAST(GETDATE()-7 AS DATE) AND creationname = 'Avalara Regression Automation'

	DECLARE @count VARCHAR(32) = 1 
	DECLARE @surrogatemax int
	DECLARE @acctgmax int
	DECLARE @partycount int
	DECLARE @contractpartymin int = 1
	DECLARE @firstdaycm DATETIME = CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1, 0)), 101) /* first day of current month */
	SELECT @acctgmax = MAX(CAST(ca.surrogate AS NUMERIC)) + 1 FROM contractacctg ca;
	SELECT @surrogatemax = MAX(CAST(c.surrogate AS NUMERIC)) + 1 FROM contractparty c;
	SELECT @partycount = COUNT(DISTINCT customer) FROM mxe_loadingnumbers_mapping ln WHERE ln.dealtype LIKE ('Third Party%')
	DECLARE @contractmax INT
	SELECT @contractmax = MAX(CAST(c.contract AS NUMERIC)) FROM contract c;

	INSERT INTO [dbo].[contract] ([contract], [contracttype], [description], [prefix], [contractdate], [effdate], [termdate], [basecontract], [ferctariffref], [fercproducttype], [ferccontract], [exhibitform], [contractclass], [master], [proforma], [review], [status], [contractstatus], [contractlocation], [termination], [evergreen], [tradebook], [product], [evergreennotice], [evergreenextenddate], [evergreentermdate], [extendevergreentermdate], [evergreenrenewal], [externalconfirmsource], [document], [calendar], [correspondence], [remark], [collaboration], [creationname], [creationdate], [revisionname], [revisiondate]) VALUES (@contractmax + 1, 'Bilateral Trade', 'Avalara Third Party Trade Deals', NULL, @firstdaycm, @firstdaycm, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, 0, 0, 137137, 'Avalara Regression Automation', GETDATE(), NULL, NULL)

	DECLARE @contract int
	SELECT @contract = MAX(CAST(c.contract AS NUMERIC)) FROM contract c 
		WHERE c.creationname = 'Avalara Regression Automation' 
			AND CAST(c.creationdate AS DATE) = CAST(GETDATE() AS DATE)

	INSERT INTO [dbo].[contractacctg] ([contract], [surrogate], [currency], [acctcode], [bookoutacctcode], [product], [settlement], [invstatus], [invdisplay], [priceprecision], [cycle], [roydistrib], [estprice], [payableprep], [invoiceformat], [statementformat], [roundmethod], [taxlevel], [taxresponsibility], [counterpartycreate], [accrualstatus], [volumestatus], [jvrevmethod], [jvexpmethod], [inventoryaccount], [accrualaccount], [inventoryacctg], [firstpurchaser], [taxstatus], [bookoutpaymentterms], [paymentterms], [latepaymentterms], [paymethod], [settletimezone], [settlequantitystatus], [settle], [exchangesettlement], [remarks], [ppatolerancepct], [ppatolerancevalue], [creationname], [creationdate], [revisionname], [revisiondate]) VALUES (@contractmax + 1, @acctgmax + 1, 'USD', 'Outside Rack Reg', 'Outside Rack Reg', 'Conv-87-E10', 'GROSS', 'ACTUAL', 'NET', 5, NULL, 1, 1, 1, NULL, NULL, 'UP', 'SUMMARY', 'BUYER/SELLER', 0, 'FORECAST', 'NET', NULL, NULL, NULL, NULL, 'INVENTORY', 0, NULL, NULL, '10 Days After Delivery', NULL, NULL, NULL, 'POSITION QUANTITY', 1, NULL, NULL, NULL, NULL, 'Avalara Regression Automation', GETDATE(), NULL, NULL)

	INSERT INTO [dbo].[contractparty] ([contract], [surrogate], [begtime], [endtime], [counterparty], [partytype], [contractpartyclass], [termnotice], [conaddress], [contractprep], [exhibitprep], [invaddress], [notification], [payaddress], [trader], [admin], [operations], [accountant], [other], [creationname], [creationdate], [revisionname], [revisiondate], [id])  VALUES (@contract, @surrogatemax, @firstdaycm, NULL, NULL, 'BUYER/SELLER',NULL, NULL, NULL, 1, 1, NULL, 'EMAIL', NULL, NULL, NULL, NULL, NULL, @count, 'Avalara Regression Automation', GETDATE(), NULL, NULL, 1)

	IF (OBJECT_ID('tempdb..#lnparty') IS NOT NULL)
	DROP TABLE #lnparty

	SELECT IDENTITY(int) AS rowid, ln.customer INTO #lnparty 
	FROM dbo.mxe_loadingnumbers_mapping ln
	WHERE ln.dealtype LIKE ('Third Party%')
	GROUP BY ln.customer

	SELECT
	  *,
	  ROW_NUMBER() OVER (ORDER BY id) AS 'rowcount'
	FROM contractparty 

	WHILE @contractpartymin < @partycount
	BEGIN
		SELECT @surrogatemax = MAX(CAST(c.surrogate AS NUMERIC)) + 1 FROM contractparty c; --get new surrogate
		INSERT INTO [dbo].[contractparty] ([contract], [surrogate], [begtime], [endtime], [counterparty], [partytype], [contractpartyclass], [termnotice], [conaddress], [contractprep], [exhibitprep], [invaddress], [notification], [payaddress], [trader], [admin], [operations], [accountant], [other], [creationname], [creationdate], [revisionname], [revisiondate], [id]) VALUES (@contract, @surrogatemax, @firstdaycm, NULL, NULL, 'BUYER/SELLER',NULL, NULL, NULL, 1, 1, NULL, 'EMAIL', NULL, NULL, NULL, NULL, NULL, @count, 'Avalara Regression Automation', GETDATE(), NULL, NULL, 1) 
		  -- increment inner loop
		  SELECT @contractpartymin = @contractpartymin + 1
		-- increment surrogate loop  
		SELECT @surrogatemax = @surrogatemax + 1 
	END

	;WITH a AS(
		SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) as rn, cp.id
	FROM contractparty cp WHERE contract = @contract
	) 
	UPDATE a SET id=rn
	OPTION (MAXDOP 1)

	SELECT * FROM #lnparty
	SELECT * FROM contractparty c WHERE CAST(c.creationdate AS DATE) = CAST(GETDATE() AS DATE)

	ALTER TABLE contractparty NOCHECK CONSTRAINT ALL
		UPDATE contractparty
		SET contractparty.counterparty = lnp.customer
		FROM contractparty cp
		INNER JOIN #lnparty lnp ON cp.id = lnp.rowid

	SELECT @surrogatemax = MAX(CAST(c.surrogate AS NUMERIC)) + 1 FROM contractparty c; 
	INSERT INTO [dbo].[contractparty] ([contract], [surrogate], [begtime], [endtime], [counterparty], [partytype], [contractpartyclass], [termnotice], [conaddress], [contractprep], [exhibitprep], [invaddress], [notification], [payaddress], [trader], [admin], [operations], [accountant], [other], [creationname], [creationdate], [revisionname], [revisiondate]) VALUES (@contract, @surrogatemax+ 1, @firstdaycm, NULL, 'Metroplex Energy Inc.', 'BUYER/SELLER',NULL, NULL, NULL, 1, 1, NULL, 'EMAIL', NULL, NULL, NULL, NULL, NULL, @count, 'Avalara Regression Automation', GETDATE(), NULL, NULL)
		,(@contract, @surrogatemax + 2, @firstdaycm, NULL, 'RaceTrac', 'BUYER/SELLER',NULL, NULL, NULL, 1, 1, NULL, 'EMAIL', NULL, NULL, NULL, NULL, NULL, @count, 'Avalara Regression Automation', GETDATE(), NULL, NULL)

END