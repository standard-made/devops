REM =========================================================
REM Created by : 8Kit
REM Create date : 2020-03-25
REM Description : Create BOLS for Avalara Regression Automation
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
set homedir=C:\Allegro\Allegro_Automation\Allegro\UtilityScripts
set logdir=%homedir%\avalararegressionlogs
set appname=ALLEGRO-BACKUP
set srcserver=ALLEGRODBQA01
SET uatuser=AllegroAdmin
SET uatpass=0yCm6MiXQvBSKSfyGl0W
SET sourcedatabase=Allegro
set logfile=%logdir%\%appname%-%date%.log
set bolsql=%homedir%\sp_AvalaraRegressionCreateBOLs.sql
set contractsql=%homedir%\sp_AvalaraRegressionCreateContract.sql
set tradesql=%homedir%\sp_AvalaraRegressionCreateTrades.sql
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
REM Perform BOL creation.
REM ==========================================================
%SQLEXEC% -U%uatuser% -P%uatpass% -S%srcserver% -d%sourcedatabase% -i%bolsql% >> %logfile%
REM ==========================================================
REM Perform CONTRACT creation.
REM ==========================================================
%SQLEXEC% -U%uatuser% -P%uatpass% -S%srcserver% -d%sourcedatabase% -i%contractsql% >> %logfile%
REM ==========================================================
REM Perform TRADE creation.
REM ==========================================================
%SQLEXEC% -U%uatuser% -P%uatpass% -S%srcserver% -d%sourcedatabase% -i%tradesql% >> %logfile%


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
