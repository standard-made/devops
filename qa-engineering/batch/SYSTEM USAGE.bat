@ECHO OFF
TITLE SYSTEM USAGE

FOR /f "TOKENS=3 DELIMS=\" %%i IN ("%USERPROFILE%") DO (SET USER=%%i) 2>&1  
ECHO Logged On User: %USER% 

PAUSE

SET totalMem=
SET availableMem=
SET usedMem=
REM Loop
FOR /f "tokens=4" %%a IN ('systeminfo ^| findstr Physical') DO IF DEFINED totalMem (SET availableMem=%%a) ELSE (SET totalMem=%%a)
SET totalMem=%totalMem:,=%
SET availableMem=%availableMem:,=%
SET /a usedMem=totalMem-availableMem
ECHO Total Memory: %totalMem%
ECHO Used Memory: %usedMem%

PAUSE