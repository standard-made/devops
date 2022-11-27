--delete valuationdetail data 
BEGIN
  DELETE FROM valuationdetail
  WHERE valuation NOT IN (SELECT
    valuation
    FROM valuation
    WHERE valuationmode IN
    ('Official Position', 'Position Intra Day'))
END

BEGIN
  DELETE FROM valuationdetail
  WHERE valuation IN (SELECT
	valuation
	FROM valuation
	WHERE valuationmode IN 
	('Official Position', 'Position Intra Day')
	AND valuetime < '2017-04-20 00:00:00.000')
END
 
--truncate mega tables
BEGIN
  TRUNCATE TABLE cmeconfig;
  TRUNCATE TABLE dbaudit;
  TRUNCATE TABLE gridlog;
END
 
--shrink database
BEGIN
  DBCC SHRINKDATABASE (StandardAutomation)
END

SELECT TOP 1 * FROM valuationdetail ORDER BY valuetime ASC