@ECHO OFF
TITLE SYSTEM USAGE

ECHO Press 1 for CPU performance test
ECHO Press 2 for password generator
ECHO Press 3 for changing file directory 
ECHO Press 4 for calculator
ECHO Press 5 for guessing game
ECHO Press 6 for copying database
ECHO Press 7 for PC cleanup
ECHO Press 8 to exit.

CHOICE /c:12345
IF errorlevel 1 GOTO performance
IF errorlevel 2 GOTO password
IF errorlevel 3 GOTO copy
IF errorlevel 4 GOTO calculator
IF errorlevel 5 GOTO guess
IF errorlevel 6 GOTO database
IF errorlevel 7 GOTO clean
IF errorlevel 8 GOTO end

:performance
FOR /f "TOKENS=3 DELIMS=\" %%i IN ("%USERPROFILE%") DO (SET USER=%%i) 2>&1  
ECHO Logged On User: %USER% 
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

:password
CALL "PASSWORD GENERATOR.bat"

:copy
CALL "COPY FILE TO NEW LOCATION.bat"

:calculator
CALL CALCULATOR.bat

:guess
CALL "GUESSING GAME.bat"

:database
CALL "COPY DATABASE TO LOCAL.bat"

:clean
CALL "PC CLEANUP.bat"

:end
EXIT 
