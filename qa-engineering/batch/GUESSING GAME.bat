@echo off
:A
ping localhost -n 1 >nul
cls
color 0e
title Guessing Game by seJma.
set /a guessnum=0
set /a answer=%RANDOM%
set variable1=surf33
echo -------------------------------------------------
echo Welcome to the Guessing Game!
echo.
echo Try and Guess my Number!
echo -------------------------------------------------
echo.
:top
echo.
set /p guess=
echo.
if %guess% GTR %answer% ECHO Lower!
if %guess% LSS %answer% ECHO Higher!
if %guess%==%answer% GOTO EQUAL
set /a guessnum=%guessnum% +1
if %guess%==%variable1% ECHO Found the backdoor hey?, the answer is: %answer%
goto top
:equal
echo Congratulations, You guessed right!!!
pause
echo.
echo It took you %guessnum% guesses.
echo.
ping localhost -n 1 >nul
cls
echo -------------------------------------------------
set /p input= Want to try again ? -
echo -------------------------------------------------
if %input%==yes goto A
if %input%==Yes goto A
if %input%==YES goto A
if %input%==no goto B

:B
echo BYE
exit