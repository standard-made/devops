/*******************************************************************************************************************/
/* APPROVAL MASTER *************************************************************************************************/
/*******************************************************************************************************************/


/* CREATE MASTER VARIABLES ****************************/
/******************************************************/
DECLARE @NAME varchar(25),
        @USERNAME varchar(15)
SELECT
  @NAME = '8kit',
  @USERNAME = 'kit'


/* CLEAR APPROVAL/SECURITY TABLES *********************/
/******************************************************/
DELETE FROM approvalname
WHERE approvalname = @NAME
DELETE FROM securityuser
WHERE userid = @USERNAME


/* CONFIGURE APPROVAL ACCESS **************************/
/******************************************************/
BEGIN
  INSERT INTO [dbo].[approvalname] ([approvaltype]
  , [approvalname]
  , [creationname]
  , [creationdate]
  , [revisionname]
  , [revisiondate])
    VALUES ('AR Approved', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('AR Pending', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('AR New', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('AP Approved', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('AP Pending', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('AP New', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('JE Approved', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('JE Pending', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('JE New', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('Pending Approval', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('Approved', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('New', @NAME, @NAME, GETDATE(), NULL, NULL),
    ('Void', @NAME, @NAME, GETDATE(), NULL, NULL)
END


/* UPDATE SYSTEM ADMIN CONFIG *************************/
/******************************************************/
BEGIN
  UPDATE userconfig
  SET configvalue = @USERNAME
  WHERE configkey = 'SubledgerLocking'
END

