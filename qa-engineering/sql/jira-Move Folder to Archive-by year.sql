--### To be run on QACAPPPRD01 Server!
USE SoftwarePlanner


--Set the User Story ID
DECLARE @UserStoryID nvarchar(max) = '252'


--Check to see if a folder with the User Story ID exists under the Jira-FuelOp folder. It not, return a message and abort.
IF NOT EXISTS(
	SELECT
		f.FolderName
	FROM Tests t
	JOIN Projects p ON t.ProjId = p.ProjId AND p.ProjName = 'Optimization'
	JOIN Folders f ON t.FolderId = f.FolderId
	WHERE f.FolderName LIKE @UserStoryID + '%'
	AND f.ParentId = 3659	--3659 = Jira-FuelOp folder
							--3727 = Jira-FuelOp Archive
)
BEGIN
	PRINT 'Unable to find a folder with User Story ID ' + @UserStoryID + ' in the folder.'
	RETURN
END


--Move the folder and test cases to the Archive-by year folder.
UPDATE Folders
SET ParentName = 'Feature Based Release/Jira-FuelOp Archive/2019', ParentId = 8626
WHERE FolderId IN (
	SELECT
		f.FolderId
	FROM Folders f
	JOIN Projects p ON f.ProjId = p.ProjId AND p.ProjName = 'Optimization'
	WHERE f.FolderName LIKE @UserStoryID + '%'
	AND f.ParentId = 3659
)

--FolderId 8623 = 2016 Folder
--FolderId 8624 = 2017 Folder
--FolderId 8625 = 2018 Folder
--FolderId 8626 = 2019 Folder
--FolderId 8627 = 2020 Folder
--FolderId 8628 = 2021 Folder
--FolderId 8629 = 2022 Folder
--FolderId 8630 = 2023 Folder
--FolderId 8631 = 2024 Folder
--FolderId 8632 = 2025 Folder

--SELECT * FROM Folders WHERE CAST(DateCreated AS DATE) = '10/29/2018'