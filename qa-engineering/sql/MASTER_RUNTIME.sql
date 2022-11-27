/*******************************************************************************************************************/
/* RUNTIME MASTER **************************************************************************************************/
/*******************************************************************************************************************/

/* Get list of all non-SYSTEM classevents ***************************/
/********************************************************************/
SELECT status, name, class FROM classevent 
WHERE creationname != 'SYSTEM'
ORDER BY class


/* Disable all non-SYSTEM classevents *******************************/
/********************************************************************/
--UPDATE classevent SET status = 'Disabled'
--WHERE creationname != 'SYSTEM'


/* Get count of valuation records processing through the gridqueue **/ 
/********************************************************************/
SELECT COUNT(*) AS 'RecordCount' FROM gridqueue 
WHERE workertype = 'Valuation' AND eventcause LIKE '%Settlement%'


/* Calculate valuation runtime **************************************/
/********************************************************************/
-- Get first/last record written to dbo.valuationdetail 
-- to calculate runtime for a specific valuation run
SELECT 'dbo.valuationdetail' AS 'Table',
	v2.valuation AS 'Valuation', 
	MIN(v1.creationdate) AS 'FirstRecord', 
	MAX(v1.creationdate) AS 'LastRecord', 
	DATEDIFF(MINUTE, MIN(v1.creationdate), MAX(v1.creationdate)) AS 'Runtime(MIN)' 
FROM valuationdetail v1 
INNER JOIN valuation v2 ON v1.valuation = v2.valuation
WHERE v1.valuation IN (SELECT valuation FROM valuation WHERE valuation = '103537') --change valuation as needed
GROUP BY v2.valuation
UNION 
-- Get creation/revision datetimes in dbo.valuation 
-- to calculate runtime for a specific valuation run
-- *will not calculate until valuation run has completed*
SELECT 'dbo.valuation' AS 'Table',
	v1.valuation AS 'Valuation',  
	v1.creationdate AS 'FirstRecord',
	ISNULL(v1.revisiondate, GETDATE()) AS 'LastRecord', 
	DATEDIFF(MINUTE, v1.creationdate, ISNULL(v1.revisiondate, GETDATE())) AS 'Runtime(MIN)' 
FROM valuation v1
WHERE v1.valuation = '103537' --change valuation as needed
GROUP BY v1.valuation, v1.creationdate, v1.revisiondate

--Runtime should be the same [(±)1min] between both queries
