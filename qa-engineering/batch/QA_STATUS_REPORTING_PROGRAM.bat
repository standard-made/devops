@echo off
title QA ENVIRONMENT STATUS REPORTING PROGRAM
color 0F
REM =========================================================
REM Set date to YYYY-MM-DD format. Time is 24hr format.
REM =========================================================
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
SET date=%yyyy%-%mm%-%dd%

REM ==========================================================
REM Setup script variables.
REM ==========================================================
SET homedir=C:\UATLoaders
SET logdir=%homedir%\logs
SET appname=ALLEGRO-ENVT-STATUS-REPORT
SET allegroqaserver=ALLEGRODBQA01
SET allegrouatserver=ALLEGRODBUAT
SET autodatabase=ALLEGROAUTOMATION
SET qadatabase=ALLEGROQA
SET testdatabase=ALLEGRO
SET uatdatabase=ALLEGRO
SET admindatabase=ALLEGROADMIN
SET allegrouser=AllegroAdmin
SET allegropass=<top secret passie>
SET autorestore="SET NOCOUNT ON; SELECT TOP 1 CAST(restore_date AS DATE) AS restoredate FROM msdb.dbo.restorehistory WHERE destination_database_name = '%autodatabase%' ORDER BY restore_date DESC"
SET qarestore="SET NOCOUNT ON; SELECT TOP 1 CAST(restore_date AS DATE) AS restoredate FROM msdb.dbo.restorehistory WHERE destination_database_name = '%qadatabase%' ORDER BY restore_date DESC"
SET testrestore="SET NOCOUNT ON; SELECT TOP 1 CAST(restore_date AS DATE) AS restoredate FROM msdb.dbo.restorehistory WHERE destination_database_name = '%testdatabase%' ORDER BY restore_date DESC"
SET uatrestore="SET NOCOUNT ON; SELECT TOP 1 CAST(restore_date AS DATE) AS restoredate FROM msdb.dbo.restorehistory WHERE destination_database_name = '%uatdatabase%' ORDER BY restore_date DESC"
SET adminrestore="SET NOCOUNT ON; SELECT TOP 1 CAST(restore_date AS DATE) AS restoredate FROM msdb.dbo.restorehistory WHERE destination_database_name = '%admindatabase%' ORDER BY restore_date DESC"
SET autoaudit="SET NOCOUNT ON; DECLARE @AuditDate DATE; SET @AuditDate = (SELECT TOP 1 CAST(restore_date AS DATE) FROM msdb.dbo.restorehistory WHERE destination_database_name = '%autodatabase%' ORDER BY restore_date DESC) SELECT DISTINCT auditname, CAST(auditdate AS DATE) AS 'auditdate', dbtable FROM dbaudit WHERE auditname NOT LIKE 'http://allegro%%' AND CAST(auditdate AS DATE) >= CAST(@AuditDate AS DATE) GROUP BY auditname, CAST(auditdate AS DATE), dbtable ORDER BY CAST(auditdate AS DATE)"
SET qaaudit="SET NOCOUNT ON; DECLARE @AuditDate DATE; SET @AuditDate = (SELECT TOP 1 CAST(restore_date AS DATE) FROM msdb.dbo.restorehistory WHERE destination_database_name = '%qadatabase%' ORDER BY restore_date DESC) SELECT DISTINCT auditname, CAST(auditdate AS DATE) AS 'auditdate', dbtable FROM dbaudit WHERE auditname NOT LIKE 'http://allegro%%' AND CAST(auditdate AS DATE) >= CAST(@AuditDate AS DATE) GROUP BY auditname, CAST(auditdate AS DATE), dbtable ORDER BY CAST(auditdate AS DATE)"
SET testaudit="SET NOCOUNT ON; DECLARE @AuditDate DATE; SET @AuditDate = (SELECT TOP 1 CAST(restore_date AS DATE) FROM msdb.dbo.restorehistory WHERE destination_database_name = '%testdatabase%' ORDER BY restore_date DESC) SELECT DISTINCT auditname, CAST(auditdate AS DATE) AS 'auditdate', dbtable FROM dbaudit WHERE auditname NOT LIKE 'http://allegro%%' AND CAST(auditdate AS DATE) >= CAST(@AuditDate AS DATE) GROUP BY auditname, CAST(auditdate AS DATE), dbtable ORDER BY CAST(auditdate AS DATE)"
SET uataudit="SET NOCOUNT ON; DECLARE @AuditDate DATE; SET @AuditDate = (SELECT TOP 1 CAST(restore_date AS DATE) FROM msdb.dbo.restorehistory WHERE destination_database_name = '%uatdatabase%' ORDER BY restore_date DESC) SELECT DISTINCT auditname, CAST(auditdate AS DATE) AS 'auditdate', dbtable FROM dbaudit WHERE auditname NOT LIKE 'http://allegro%%' AND CAST(auditdate AS DATE) >= CAST(@AuditDate AS DATE) GROUP BY auditname, CAST(auditdate AS DATE), dbtable ORDER BY CAST(auditdate AS DATE)"
SET adminaudit="SET NOCOUNT ON; DECLARE @AuditDate DATE; SET @AuditDate = (SELECT TOP 1 CAST(restore_date AS DATE) FROM msdb.dbo.restorehistory WHERE destination_database_name = '%admindatabase%' ORDER BY restore_date DESC) SELECT DISTINCT auditname, CAST(auditdate AS DATE) AS 'auditdate', dbtable FROM dbaudit WHERE auditname NOT LIKE 'http://allegro%%' AND CAST(auditdate AS DATE) >= CAST(@AuditDate AS DATE) GROUP BY auditname, CAST(auditdate AS DATE), dbtable ORDER BY CAST(auditdate AS DATE)"
REM activeusers="SET NOCOUNT ON; SELECT name, status FROM userid WHERE status = 'ACTIVE' AND readonly = 0"
SET godusers="SET NOCOUNT ON; SELECT userid FROM userid WHERE status = 'ACTIVE' AND readonly = 0 AND userid NOT IN (SELECT userid FROM securityuser)"
SET cmestatus="SET NOCOUNT ON; IF EXISTS (SELECT * FROM gridservice WHERE servicename = 'CMEDeal') (SELECT status AS 'status:' FROM gridservice WHERE servicename = 'CMEDeal') ELSE SELECT 'Service Not Configured' AS 'status'"
SET pricecount="SET NOCOUNT ON; SELECT DISTINCT CAST(pv.pricedate AS DATE) AS 'pricedate', 	LEFT(pv.priceindex,5) AS 'priceindex', COUNT(*) AS 'count' FROM pricevalue pv WHERE CAST(pv.pricedate AS DATE) >= CAST(GETDATE()-4 AS DATE) AND ((DATEPART(dw, pv.pricedate) + @@DATEFIRST) * 7) NOT IN (0, 1) AND pv.priceindex NOT LIKE '*ARGUSForward*' AND pv.priceindex NOT LIKE '*Spot*' AND pv.priceindex NOT LIKE '*Transfer*' GROUP BY CAST(pv.pricedate AS DATE), LEFT(pv.priceindex,5) ORDER BY CAST(pv.pricedate AS DATE)"
SET logfile=%logdir%\%appname%-%date%.log
SET SQLEXEC=c:\PROGRA~1\MICROS~1\110\Tools\Binn\SQLCMD.EXE

REM ==========================================================
REM Program
REM ==========================================================
echo --------------------------------------------------------------------------------
echo WELCOME TO THE QA ENVIRONMENT STATUS REPORTING PROGRAM
echo --------------------------------------------------------------------------------
echo.
echo This program is designed to provide a general status report of each of the
echo Allegro test environments. This program will capture cirtical information
echo regarding the overall health and wellness of each environment and will 
echo log all active users, database restore dates, general auditing, and active
echo connections to outside parties including Avalara and CME.
echo.
echo This program was brought to you by . . . 
ping localhost -n 5 >nul
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
echo   -/++..................QA STATUS REPORTING PROGRAM................-/-.//.-/-`  
echo   `-//```````````````````````beardedhudson inc`````````````````````-:--::-::-`    
echo      `                                                              `.` ..``.`   
echo.
ping localhost -n 3 >nul
cls

REM Complete
color 0F
echo --------------------------------------------------------------------------------
echo QA STATUS REPORT RUNNING
echo --------------------------------------------------------------------------------
echo The QA Status Reporting Program has started running...
ping localhost -n 5 >nul
cls

REM NSLOOKUP Against the Avalara URL 
echo ======================================				>> %logfile%
echo AVALARA NSLOOKUP =====================				>> %logfile%
echo ======================================				>> %logfile%
nslookup exciseua.avalara.net 							>> %logfile%
cls

REM Outbound Firewall Rules
REM echo ======================================				>> %logfile%
REM echo OUTBOUND FIREWALL RULES ==============				>> %logfile%
REM echo ======================================				>> %logfile%
REM netsh advfirewall firewall show rule name="Routing and Remote Access (GRE-OUT)" verbose	>> %logfile%
REM netsh advfirewall firewall show rule name="Routing and Remote Access (L2TP-OUT)" verbose >> %logfile%
REM netsh advfirewall firewall show rule name="Routing and Remote Access (PPTP-OUT)" verbose >> %logfile%
REM cls

REM Open Allegro Applications
echo ======================================				>> %logfile%
echo OPEN ALLEGRO APPLICATIONS ============				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAppQA01 -----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
tasklist /S ALLEGROAPPQA01 /FI "imagename eq Allegro.exe" /V >> %logfile%
echo.													>> %logfile%
echo AllegroAppQA02 -----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
tasklist /S ALLEGROAPPQA02 /FI "imagename eq Allegro.exe" /V >> %logfile%
echo.													>> %logfile%
echo AllegroAppQA03 -----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
tasklist /S ALLEGROAPPQA03 /FI "imagename eq Allegro.exe" /V >> %logfile%
echo.													>> %logfile%
echo AllegroAppQA04 -----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
tasklist /S ALLEGROAPPQA04 /FI "imagename eq Allegro.exe" /V >> %logfile%
echo.													>> %logfile%
echo AllegroAppQA05 -----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
tasklist /S ALLEGROAPPQA05 /FI "imagename eq Allegro.exe" /V >> %logfile%
echo.													>> %logfile%
cls

REM Database Restore Dates
echo ======================================				>> %logfile%
echo DATABASE RESTORE DATES ===============				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAutomation --------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%autodatabase% -Q%autorestore% >> %logfile%
echo.													>> %logfile%
echo AllegroQA ----------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%qadatabase% -Q%qarestore% >> %logfile%
echo.													>> %logfile%
echo AllegroTest --------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%testdatabase% -Q%testrestore% >> %logfile%
echo.													>> %logfile%
echo ALLEGRODBUAT *************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroUAT ---------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%uatdatabase% -Q%uatrestore% >> %logfile%
echo.													>> %logfile%
echo AllegroAdmin ----------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%admindatabase% -Q%adminrestore% >> %logfile%
echo.													>> %logfile%

REM Active GOD Users
echo ======================================				>> %logfile%
echo ACTIVE GOD USERS =====================				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAutomation --------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%autodatabase% -Q%godusers% >> %logfile%
echo.													>> %logfile%
echo AllegroQA ----------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%qadatabase% -Q%godusers% >> %logfile%
echo.													>> %logfile%
echo AllegroTest --------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%testdatabase% -Q%godusers% >> %logfile%
echo.													>> %logfile%
echo ALLEGRODBUAT *************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroUAT ---------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%uatdatabase% -Q%godusers% >> %logfile%
echo.													>> %logfile%
echo AllegroAdmin ------------------------				>> %logfile%
echo -------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%admindatabase% -Q%godusers% >> %logfile%
echo.													>> %logfile%

REM CME Status
echo ======================================				>> %logfile%
echo CME STATUS ===========================				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAutomation --------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%autodatabase% -Q%cmestatus% >> %logfile%
echo.													>> %logfile%
echo AllegroQA ----------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%qadatabase% -Q%cmestatus% >> %logfile%
echo.													>> %logfile%
echo AllegroTest --------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%testdatabase% -Q%cmestatus% >> %logfile%
echo.													>> %logfile%
echo ALLEGRODBUAT *************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroUAT ---------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%uatdatabase% -Q%cmestatus% >> %logfile%
echo.													>> %logfile%
echo AllegroAdmin -------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%admindatabase% -Q%cmestatus% >> %logfile%
echo.													>> %logfile%

REM Price Index Count
REM gets price indexes from the past week excluding weekends
echo ======================================				>> %logfile%
echo PRICE INDEX COUNT ====================				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAutomation --------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%autodatabase% -Q%pricecount% >> %logfile%
echo.													>> %logfile%
echo AllegroQA ----------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%qadatabase% -Q%pricecount% >> %logfile%
echo.													>> %logfile%
echo AllegroTest --------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%testdatabase% -Q%pricecount% >> %logfile%
echo.													>> %logfile%
echo ALLEGRODBUAT *************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroUAT ---------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%uatdatabase% -Q%pricecount% >> %logfile%
echo.													>> %logfile%
echo AllegroAdmin -------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%admindatabase% -Q%pricecount% >> %logfile%
echo.

REM Database Audit Trail Since Last Restore
echo ======================================				>> %logfile%
echo DATABASE AUDIT TRAIL =================				>> %logfile%
echo ======================================				>> %logfile%
echo ALLEGRODBQA01 ************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroAutomation --------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%autodatabase% -Q%autoaudit% >> %logfile%
echo.													>> %logfile%
echo AllegroQA ----------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%qadatabase% -Q%qaaudit% >> %logfile%
echo.													>> %logfile%
echo AllegroTest --------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegroqaserver% -d%testdatabase% -Q%testaudit% >> %logfile%
echo.													>> %logfile%
echo ALLEGRODBUAT *************************				>> %logfile%
echo **************************************				>> %logfile%
echo AllegroUAT ---------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%uatdatabase% -Q%uataudit% >> %logfile%
echo.													>> %logfile%
echo AllegroAdmin -------------------------				>> %logfile%
echo --------------------------------------				>> %logfile%
%SQLEXEC% -U%allegrouser% -P%allegropass% -S%allegrouatserver% -d%admindatabase% -Q%adminaudit% >> %logfile%
echo.													>> %logfile%

REM Complete
echo --------------------------------------------------------------------------------
echo STATUS REPORT COMPLETE
echo --------------------------------------------------------------------------------
echo The QA Status Reporting Program has completed. Please review the log file 
echo written to the C:\UATLoaders\logs\ folder on ALLEGROAPPQA01.
ping localhost -n 5 >nul
cls

REM Get Outta Here
echo --------------------------------------------------------------------------------
echo GET OUTTA HERE
echo --------------------------------------------------------------------------------
echo Thank you for using the QA Status Reporting Program. 
echo NOS VEMOS LA PROXIMA VEX
ping localhost -n 3 >nul
exit