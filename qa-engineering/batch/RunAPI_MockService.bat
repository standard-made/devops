@echo off
title MOCK SERVICE
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

:main
REM root directory
cd \
cd "%CD%\Program Files\SmartBear\SoapUI-5.7.0\bin"
mockservicerunner.bat -m "Account creation mock" "C:\Users\<username>\SoapUI-Tutorials\Sample-REST-Project-soapui-project.xml" 