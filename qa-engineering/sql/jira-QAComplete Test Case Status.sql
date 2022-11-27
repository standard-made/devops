USE SoftwarePlanner

DECLARE 
      @projName AS VARCHAR(75),
      @parentName AS VARCHAR (100)

SET @projName = 'Optimization'
SET @parentName = 'Phase 1B/Sprint 4.16'

SELECT x.ProjName
,     x.ParentName
,     x.FolderName
,     x.Title
,     COUNT(x.Seq) AS Num_of_Steps
FROM (
            SELECT
                  CTE1.ProjName,
                  CTE1.ParentName,
                  CTE1.FolderName,
                  t.TestId,
                  t.Title,
                  ts.Seq
            FROM (SELECT
                        p.ProjID,
                        p.ProjName,
                        f.ParentName,
                        f.FolderID,
                        f.FolderName
                        FROM Projects p
                        JOIN Folders f    ON p.ProjID = f.ProjID
                        Where p.ProjName  = @projName and f.ParentName = @parentName
      )CTE1 
LEFT JOIN Tests t ON t.ProjID = CTE1.ProjId     AND t.FolderID = CTE1.FolderID
LEFT JOIN TestSteps ts ON t.TestId = ts.TestId
GROUP BY    CTE1.ProjName,
                  CTE1.ParentName,
                  CTE1.FolderID,
                  FolderName,
                  t.TestId,
                  t.Title,
                  ts.seq
)x
GROUP BY
      x.ProjName
,     x.ParentName
,     x.FolderName
,     x.Title




