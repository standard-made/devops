DECLARE @TFSID int = 18991

SELECT
	TOP 1 --*
	f.ParentName + '/' + f.FolderName AS 'Folder', t.Title, COUNT(ts.TestStepId) AS 'NumberOfSteps'
FROM Tests t
JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
JOIN Folders f ON t.FolderId = f.FolderId
JOIN TestSteps ts ON t.TestId = ts.TestId
WHERE f.FolderName LIKE '%' + CAST(@TFSID as nvarchar(50)) + '%'
GROUP BY f.ParentName, f.FolderName, t.Title, t.TestId


