REM =========================================================
REM Created by : 8Kit
REM Creation date : 2016-01-02
REM Description : Copies Allegro new build binaries to AllegroQA
REM =========================================================
@ECHO off
TITLE DEPLOY ALLEGRO BUILD

REM ==========================================================
REM SET script variables.
REM ==========================================================
SET source="F:\Allegro-8.0.9122.10-rev.34"
SET destination="F:\AllegroQA"

ECHO Source folder: %source%
ECHO Destination folder: %destination%
ECHO [ENTER] to continue
PAUSE >nul

REM ==========================================================	
REM Copy all files and subfolders excluding webconfig file.
REM ==========================================================
ROBOCOPY %source% %destination% /s /xf *.config

PAUSE





