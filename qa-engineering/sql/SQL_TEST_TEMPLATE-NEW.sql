/****************************************************************************************************************/
/* SQL TEST MASTER **********************************************************************************************/
/****************************************************************************************************************/

--RUNNERS TABLE
SELECT 	r1.RunnerID,
		r1.FirstName,
		r1.LastName 
FROM Runners r1

--RACES TABLE
SELECT 	r2.RaceID,
		r2.RaceName,
		r2.RunnerID,
		r2.TimeInSeconds 
FROM Races r2

/* DEV QUESTIONS *********************************************************/
/*************************************************************************/
--Q1 - List FirstName, LastName for all Runners.  If the runner's Last name is 'Doe', show their FirstName as their LastName





--Q2 - List FirstName, LastName and RaceName for all Runners and races they have run. Include runners who have not run in any races.





--Q3 - List FirstName, LastName and the number of races they have run.  Only include runners who have run in 2 or more races.





--Q4 - List FirstName and LastName for all runners who have not run in any races.





--Q5 - For each RaceName, list the fastest, slowest and average times.





--Q6 - For each RaceName, list FirtName, LastName and TimeInSeconds for the runner who won the race (Runners in races with the quickest/smallest TimeInSeconds per race).




