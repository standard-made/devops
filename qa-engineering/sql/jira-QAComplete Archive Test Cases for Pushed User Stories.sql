--### To be run on QACAPPPRD01 Server!
USE SoftwarePlanner


--Set the User Story ID
DECLARE @UserStoryID int = 999
DECLARE @DestinationFolderName nvarchar(max) = '2019'
 

--Convert the @UserStoryID into a nvarchar(10)
DECLARE @UserStoryIDConverted nvarchar(10) = CAST(@UserStoryID AS nvarchar(10))


--Check to see if a folder with the User Story ID exists under the Jira-FuelOp folder. It not, return a message and abort.
IF NOT EXISTS(
	SELECT
		f.FolderName
	FROM Tests t
	JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
	JOIN Folders f ON t.FolderId = f.FolderId
	WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
	AND f.ParentId = 3659	--Jira-FuelOp folder
)
BEGIN
	PRINT 'Unable to find a folder with User Story ID ' + @UserStoryIDConverted + ' in the Jira-FuelOp folder.'
	RETURN
END


--Check to see if the folder has any test cases missing steps. If it does, return a message and abort.
IF EXISTS(
	SELECT
		t.TestId, t.Title, COUNT(ts.TestStepId)
	FROM Tests t
	LEFT JOIN TestSteps ts ON t.TestId = ts.TestId
	JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
	JOIN Folders f ON t.FolderId = f.FolderId
	WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
	AND f.ParentId = 3659	--Jira-FuelOp folder
	GROUP BY t.TestId, t.Title
	HAVING COUNT(ts.TestStepId) = 0
)
BEGIN
	PRINT 'There are test cases that are missing steps for User Story ID ' + @UserStoryIDConverted
	RETURN
END


--Check to see if the test cases in the folder have requirements linked. If not, return a message and abort.
DECLARE @TestCount int = (SELECT
							COUNT(*)
						FROM Tests t
						JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
						JOIN Folders f ON t.FolderId = f.FolderId
						WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
						AND f.ParentId = 3659	--Jira-FuelOp folder
						)

DECLARE @LinkedItemCount int = (SELECT COUNT(*) FROM TraceabilityLinks tl
								WHERE tl.FKId1 IN (
									SELECT
										t.TestId
									FROM Tests t
									JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
									JOIN Folders f ON t.FolderId = f.FolderId
									WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
									AND f.ParentId = 3659	--Jira-FuelOp folder
								))

DECLARE @LinkedItemCountAlt int = (SELECT COUNT(*) FROM TraceabilityLinks tl
								WHERE tl.FKId2 IN (
									SELECT
										t.TestId
									FROM Tests t
									JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
									JOIN Folders f ON t.FolderId = f.FolderId
									WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
									AND f.ParentId = 3659	--Jira-FuelOp folder
								))


--Move the folder and test cases to the Jira-FuelOpArchive folder.
DECLARE @NewParentPath nvarchar(max) = (SELECT f.ParentName FROM Folders f WHERE f.FolderName = @DestinationFolderName AND EntityCode = 'Tests' AND IsActive = 'Y') + '/' + @DestinationFolderName
DECLARE @NewParentID nvarchar(max) = (SELECT f.FolderId FROM Folders f WHERE f.FolderName = @DestinationFolderName AND EntityCode = 'Tests' AND IsActive = 'Y')

UPDATE Folders
SET ParentName = @NewParentPath, ParentId = @NewParentID
WHERE FolderId = (
	SELECT
		f.FolderId
	FROM Folders f
	JOIN Projects p ON f.ProjId = p.ProjId AND p.ProjName = 'Optimization'
	WHERE f.FolderName LIKE @UserStoryIDConverted + '%'
	AND f.ParentId = 3659
)
AND EntityCode = 'Tests'
AND IsActive = 'Y'