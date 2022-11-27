@echo off
title TEST RUNNER
cls

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for admin permissions
REM net session>nul 2>&1
REM if %errorlevel%==0 goto main
REM echo CreateObject("Shell.Application").ShellExecute "%~f0", "", "", "runas"> "%temp%/elevate.vbs"
REM "%temp%/elevate.vbs"
REM del "%temp%/elevate.vbs"
REM exit
:-------------------------------------

REM =========================================================
REM set date to YYYY-MM-DD format. Time is 24hr format.
REM =========================================================
for /F "TOKENS=1* DELIMS= " %%A in ('DATE/T') do set CDATE=%%B
for /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A in ('DATE/T') do set mm=%%B
for /F "TOKENS=1,2 DELIMS=/ eol=/" %%A in ('echo %CDATE%') do set dd=%%B
for /F "TOKENS=2,3 DELIMS=/ " %%A in ('echo %CDATE%') do set yyyy=%%B
set date=%yyyy%-%mm%-%dd%

REM ==========================================================
REM setup script variables.
REM ==========================================================
set appname=SGB-SoapUI
set logfile=C:\Users\<username>\documents\Automation\SilvergateAPI\SGB-SoapUI\Stores\TestLog\%appname%-%date%.log

:main
REM root directory
cd \
cd "%CD%\Program Files\SmartBear\SoapUI-5.7.0\bin"
echo.													>> %logfile%
echo ======================================				>> %logfile%
echo TIME for TACOS AND TESTinG: [%date% %time%]									>> %logfile%
echo ======================================				>> %logfile%	
echo.													>> %logfile%
testrunner.bat "C:\Users\<username>\SoapUI-Tutorials\Sample-REST-Project-soapui-project.xml" >> %logfile%										