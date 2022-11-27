@echo off
title RAINBOW MATRIX

:LOADING

cls

echo Processing.

ping localhost -n 2 >nul

cls

echo Processing..

ping localhost -n 2 >nul

cls

echo Processing...

ping localhost -n 2 >nul

cls

echo Loading....

ping localhost -n 2 >nul

cls

echo Starting.....

ping localhost -n 2 >nul

ping localhost -n 2 >nul

cls

color 0a

echo What do you want to do? Enter your choice

echo 1) Make a matrix falling efect

set/p c=

if %c%==1 goto MATRIX

:MATRIX

cls

echo What colour you want?

echo 1) RAINBOW

echo 2) Red

echo 3) Blue

echo 4) Purple

set/p ch=

if %ch%==1 goto GREEN

if %ch%==2 goto RED

if %ch%==3 goto BLUE

if %ch%==4 goto PURPLE

:GREEN

color 02
color 04
color 01
color 03
color 06
color 07
color 08
color 09
color 05
set a=67841350137489528937018256781344

echo %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%

goto GREEN

:RED

color 04

set a=67841350137489528937018256781344

echo %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%

goto RED

:BLUE

color 01

set a=67841350137489528937018256781344

echo %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%

goto BLUE

:PURPLE

color 05

set a=67841350137489528937018256781344

echo %a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%%a%

goto PURPLE