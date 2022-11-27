/****************************************************************************************************************/
/* SQL TEST MASTER **********************************************************************************************/
/****************************************************************************************************************/

/* DEV QUESTIONS *********************************************************/
/*************************************************************************/
--Q1 - List FirstName, LastName for all Runners.  If the runner's Last name is 'Doe', show their FirstName as their LastName
SELECT
  FirstName,
  LastName,
  CASE LastName
    WHEN 'Doe' THEN firstname
  END AS LastName
FROM Runners


--Q2 - List FirstName, LastName and RaceName for all Runners and races they have run. Include runners who have not run in any races.
SELECT
  r.FirstName,
  r.LastName,
  r1.RaceName
FROM Runners r
LEFT JOIN Races r1
  ON r.RunnerID = r1.RunnerID


--Q3 - List FirstName, LastName and the number of races they have run.  Only include runners who have run in 2 or more races.
SELECT
  r.FirstName,
  r.LastName,
  COUNT(r1.RaceName) AS 'RaceName'
FROM Runners r
INNER JOIN Races r1
  ON r.RunnerID = r1.RunnerID
GROUP BY FirstName,
         r.LastName
HAVING COUNT(r1.RaceName) >= 2


--Q4 - List FirstName and LastName for all runners who have not run in any races.
SELECT
  FirstName,
  LastName,
  r1.RaceName
FROM Runners r
LEFT JOIN Races r1
  ON r.RunnerID = r1.RunnerID
WHERE r1.RaceName IS NULL


--Q5 - For each RaceName, list the fastest, slowest and average times.
SELECT DISTINCT
  r.RaceName,
  MAX(r.TimeInSeconds) AS 'MAX',
  MIN(r.TimeInSeconds) AS 'MIN',
  CAST(AVG(r.TimeInSeconds) AS DECIMAL(8, 2)) AS 'AVG'
FROM Races r
GROUP BY r.RaceName

--Q6 - For each RaceName, list FirtName, LastName and TimeInSeconds for the runner who won the race (Runners in races with the quickest/smallest TimeInSeconds per race).
SELECT
  r.RaceName,
  r1.FirstName,
  r1.LastName,
  r.TimeInSeconds
FROM Races r
INNER JOIN Runners r1
  ON r.RunnerID = r1.RunnerID
WHERE r.TimeInSeconds IN (SELECT
  MIN(TimeInSeconds) TimeInSeconds
FROM Races
GROUP BY RaceID)
GROUP BY r.RaceName,
         r1.FirstName,
         r1.LastName,
         r.TimeInSeconds