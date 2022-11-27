@echo off
title HUDSON BULK COPY PROGRAM
color 0F
echo --------------------------------------------------------------------------------
echo WELCOME TO THE COOL-AF HUDSON BULK COPY PROGRAM
echo --------------------------------------------------------------------------------
echo.
echo This program is designed to transfer valuationdetail data from a specified time
echo period into a CSV file. Once the data is transfered, the valuationdetail table
echo will be truncated, the remaining data will be inserted back into the table,
echo a DBSHRINK will be performed, and a backup of the database will be created.
echo.
echo This program was brought to you by . . . 
pause >nul
cls
color 89
echo.
echo.
echo.
echo.
echo     .:::`  :::.  .         .  -::::--`     `-:/:.      .::::.   `:::`  -::.    
echo     +NNN/ .NNNh .o::::./::/o` dNNNNNNNh: `sNNNNNNmo  /dNNNNNNd: -NNNd.`NNNo    
echo     +NNNy+oNNNh -ooo:---/ooo. dNNN::mNNN.:NNNmoys+/`.NNNm--NNNN`-NNNNm/NNNo    
echo     +NNNNNNNNNh +ooooooooooo/ dNNN` hNNN- +dNNNNNNh--NNNh  mNNN`-NNNNNNNNNo    
echo     +NNNo-/NNNh.ooooooooooooo`dNNN/+mNNN.:sssoohNNNo.NNNm//NNNm`-NNNohNNNNo    
echo     +NNN/ .NNNh.ooooooooooooo`dNNNNNNmy- `smNNNNNms` :hNNNNNNy- -NNN+ oNNNo    
echo     `...   ...` `-/ooooooo/-  `.....`       .--.`      `.--.     ...`  `..`    
echo                 `./+ooo++:.`                                                      
echo                    ``..`
echo     .:                                                             `-:..:-`-:`  
echo   -/++......................BULK COPY PROGRAM......................-/-.//.-/-`    
echo   `-//`````````````````````````````````````````````````````````````-:--::-::-`    
echo      `                                                              `.` ..``.`   
echo.
ping localhost -n 3 >nul
cls

REM Keep ValuationDetail Data After This Date
color 0F
echo --------------------------------------------------------------------------------
echo ENTER DATE
echo --------------------------------------------------------------------------------
echo.		 
echo Enter the date would you like to start deleting valuationdetail from.
echo This program will delete all valuationdetail data prior to this date.
echo.
echo Please use the YYYY-MM-DD format and press ENTER.
set /p timeperiod=""
cls

REM Verify
color 0C
echo --------------------------------------------------------------------------------
echo CHECK YOUR SHIT
echo --------------------------------------------------------------------------------
echo You have entered the following date: 
echo %timeperiod%
echo.
echo If this is correct, press ENTER.
echo.
echo If this is incorrect, quit fucking up, close the program 
echo and do it right next time!
ping localhost -n 3 >nul
cls

REM BCP OUT OF ValuationDetail Table
color 0F
echo --------------------------------------------------------------------------------
echo BCP OUT
echo --------------------------------------------------------------------------------
bcp "SELECT * FROM AllegroAutomation.dbo.valuationdetail vd WHERE CAST(vd.valuetime AS DATE) >= CAST('%timeperiod%' AS DATE) ORDER BY vd.valuationdetail" queryout "\\rt-ops\public\kehudson\Allegro_Backup\ValuationDetail.csv" -SALLEGRODBQA01 -T -c -k -t~ -r \r\n
echo.
echo Valuationdetail data bulk copied into the following file:
echo \\rt-ops\public\kehudson\Allegro_Backup\ValuationDetail.csv
ping localhost -n 3 >nul
cls

REM Truncate Tables, Load ValuationDetail Data Back Into Table, Shrink Database
echo --------------------------------------------------------------------------------
echo BCP IN
echo --------------------------------------------------------------------------------
echo Truncating tables and reinserting valuationdetail data...
echo.
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"Truncate table valuationdetail" 
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"Truncate table dbaudit" 
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"Truncate table gridlog" 
REM Drop Clustered Index
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"ALTER TABLE [dbo].[valuationdetail] DROP CONSTRAINT [pk_valuationdetail]"
REM BCP INTO ValuatinoDetail Table
bcp "AllegroAutomation.dbo.valuationdetail" in "\\rt-ops\public\kehudson\Allegro_Backup\ValuationDetail.csv" -SALLEGRODBQA01 -E -T -c -k -t~ -r\n
REM Recreate Clustered Index
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"ALTER TABLE [dbo].[valuationdetail] ADD  CONSTRAINT [pk_valuationdetail] PRIMARY KEY CLUSTERED ([valuationdetail] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]"
cls

echo --------------------------------------------------------------------------------
echo DBSHRINK
echo --------------------------------------------------------------------------------
echo shrinking the database...
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"DBCC SHRINKDATABASE (AllegroAutomation)"
cls
echo Process is complete.
ping localhost -n 3 >nul
cls

REM Create Backup File
echo --------------------------------------------------------------------------------
echo BACKUP
echo --------------------------------------------------------------------------------
echo Creating backup of AllegroAutomation...
sqlcmd -SALLEGRODBQA01 -dAllegroAutomation -E -Q"USE AllegroAutomation; DECLARE @allegroPathName NVARCHAR(512) SET @allegroPathName = '\\rt-ops\public\kehudson\Allegro_Backup\AllegroAutomation_BackUp_' + Convert(varchar(8), GETDATE(), 112) + RIGHT('00' + cast(DATEPART(hour, GETDATE()) as varchar), 2) + RIGHT( '00' + cast(DATEPART(minute, GETDATE()) as varchar), 2) + '.bak' BACKUP DATABASE [Allegro] TO  DISK = @allegroPathName WITH NOFORMAT, NOINIT,  NAME = N'db_backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10"
echo.
echo Process is complete.
echo You can find the backup here: \\rt-ops\public\kehudson\Allegro_Backup\
del "\\rt-ops\public\kehudson\Allegro_Backup\ValuationDetail.csv"
echo.
pause
cls

REM Get Outta Here
echo --------------------------------------------------------------------------------
echo GET OUTTA HERE
echo --------------------------------------------------------------------------------
echo Thank you for using the Hudson Bulk Copy Program. 
echo ES TACO MARTES?
ping localhost -n 3 >nul
exit