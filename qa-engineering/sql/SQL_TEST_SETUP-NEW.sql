/****************************************************************************************************************/
/* SQL TEST SETUP MASTER ****************************************************************************************/
/****************************************************************************************************************/

/* CREATE QA TEST DATABASE ***********************************************/
/*************************************************************************/
CREATE DATABASE [QA_TEST]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QA_TEST', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QA_TEST.mdf' , SIZE = 4096KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QA_TEST_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QA_TEST_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QA_TEST] SET COMPATIBILITY_LEVEL = 120
GO
ALTER DATABASE [QA_TEST] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QA_TEST] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QA_TEST] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QA_TEST] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QA_TEST] SET ARITHABORT OFF 
GO
ALTER DATABASE [QA_TEST] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QA_TEST] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QA_TEST] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [QA_TEST] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QA_TEST] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QA_TEST] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QA_TEST] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QA_TEST] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QA_TEST] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QA_TEST] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QA_TEST] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QA_TEST] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QA_TEST] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QA_TEST] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QA_TEST] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QA_TEST] SET  READ_WRITE 
GO
ALTER DATABASE [QA_TEST] SET RECOVERY FULL 
GO
ALTER DATABASE [QA_TEST] SET  MULTI_USER 
GO
ALTER DATABASE [QA_TEST] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QA_TEST] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QA_TEST] SET DELAYED_DURABILITY = DISABLED 
GO
USE [QA_TEST]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [QA_TEST] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO


/* CREATE DATABASE TABLES ************************************************/
/*************************************************************************/
IF OBJECT_ID('QA_TEST..Runners') IS NOT NULL DROP TABLE QA_TEST..Runners
IF OBJECT_ID('QA_TEST..Races') IS NOT NULL DROP TABLE QA_TEST..Races
GO

CREATE TABLE QA_TEST.dbo.Runners (
       RunnerID int PRIMARY KEY IDENTITY
       , FirstName varchar(30)
       , LastName varchar(30)
)

CREATE TABLE QA_TEST.dbo.Races (
       RaceID int
       , RaceName varchar(30) 
       , RunnerID int 
       , TimeInSeconds decimal(8,2)
)

INSERT INTO QA_TEST.dbo.Runners (FirstName, LastName) VALUES ('John', 'Doe')
INSERT INTO QA_TEST.dbo.Runners (FirstName, LastName) VALUES ('Jane', 'Doe')
INSERT INTO QA_TEST.dbo.Runners (FirstName, LastName) VALUES ('Alice', 'Ford')
INSERT INTO QA_TEST.dbo.Runners (FirstName, LastName) VALUES ('Tim', 'Jones')
INSERT INTO QA_TEST.dbo.Runners (FirstName, LastName) VALUES ('Bob', 'Smith')

INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (1, '100m', 1, 12.5);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (1, '100m', 2, 10.1);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (1, '100m', 4, 10.5);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (2, '300m', 2, 40.3);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (2, '300m', 4, 35.6);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (2, '300m', 5, 37.0);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (3, '500m', 1, 80.2);
INSERT INTO QA_TEST.dbo.Races (RaceID, RaceName, RunnerID, TimeInSeconds) VALUES (3, '500m', 2, 76.9);
GO