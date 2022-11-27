Title BACKUP DATABASE
REM =========================================================
REM Created by : 8Kit
REM Create date : 2014-07-08
REM Description : Mandatory load script for data
REM =========================================================

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
set homedir=C:\UATLoaders
set logdir=%homedir%\logs
set appname=ALLEGRO-BACKUP
set srcserver=ALLEGRODBQA01
SET sourcedatabase=AllegroValidate
set logfile=%logdir%\%appname%-%date%.log
set bakscr=%homedir%\AllegroQAValidateBackup.sql
SET SQLEXEC=c:\PROGRA~1\MICROS~1\110\Tools\Binn\SQLCMD.EXE

echo ================================== >> %logfile%
echo [%date% %time%] 					>> %logfile%
echo ================================== >> %logfile%
echo ** -------------------------------->> %logfile%
echo ** 								>> %logfile%
echo ** 								>> %logfile%
echo ** STARTING BACKUP RUN ** 			>> %logfile%
echo ** 								>> %logfile%
echo ** 								>> %logfile%
echo ** -------------------------------->> %logfile%

REM ==========================================================
REM Perform scripted drop here.
REM ==========================================================
%SQLEXEC% -S%srcserver% -d%sourcedatabase% -i%bakscr% >> %logfile%

:EOF
echo ** --------------------------------	>> %logfile%
echo ** 									>> %logfile%
echo ** 									>> %logfile%
echo ** ENDING SYNC RUN ** 					>> %logfile%
echo ** 									>> %logfile%
echo ** 									>> %logfile%
echo ** --------------------------------	>> %logfile%
echo ================================== 	>> %logfile%
echo [%date% %time%]						>> %logfile%
echo ================================== 	>> %logfile%
PAUSE