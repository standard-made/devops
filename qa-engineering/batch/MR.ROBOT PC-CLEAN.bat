@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
title MR. ROBOT PC-CLEAN UTILITY
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  -HN+  :MN+ -HMMHNh\         -HMMHNh\   -MHNM:   -HMMHNh\   -MHNM:   dHMHNHNNh 
echo  +MNM  dNMm +MM  dMN         +MM  dMN  hMm  dMd` +MM  dMN  hMm  dMd` dHMHNHNNh
echo  +MydNyM+Mm +MMhdMm/         +MMhdMm/  MM+  :MM: +MMhdMm/  MM+  :MM:    mMh    
echo  +My yMy Mm +MM. NMy`  +MH   +MM. NMy` yMm  dMd` +MM. .My` yMm  dMd`    mMh    
echo  -My `M` Mm +MM. \Mhy  +HN   +MM. \Mhy  -MHNM:   +MMhdMm/   -MHNM:      mMh
echo `+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`
echo                               PC - CLEANING TOOL
echo.
echo Brought to you by . . . 
pause >nul
cls
echo.
echo.
echo 		  	MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo 		  	M ooooooooo/:----:/+oooooooo`M
echo 		  	M MMMNy+-`           -/smMMM M
echo 		  	M Mm/                    -yM M
echo 		  	M +                        . M
echo 		  	M /.    `.          `.    `/ M
echo 		  	M sN-osoodMh+.  `:yNmsoss.mh M
echo 		  	M sd:`    -sNN. NNy-    `.hy M
echo 		  	M -  + :ymds`    `odmh/ +` . M
echo 		  	M    `-ooosh.`- :.hyooo.`    M
echo 		  	M   -+      :-  .-`     /:   M
echo 		  	M  yMs    -/s:  -oo:`   /Mh  M
echo 		  	M  MMMmhdMMMMMmmMMMMMmhdMMM. M
echo 		  	M yyMMMMMMMMMMMMMMMMMMMMMMsy M
echo 		  	M MN:.-://mNdddhdhmNo/::-.mM M
echo 		  	M MMd     `:shdmdy+`     sMM M
echo 		  	M MMM-                  `NMM M
echo 		  	M MMMN/                -mMMM M
echo 		  	M MMMMMm/`           :hMMMMM M
echo 		  	M NNNNNNNm-..-//....dNNNNNNN M
echo 			MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo 			***********fSOCIETY***********
PING 127.0.0.1 >nul 
:menu
cls
echo --------------------------------------------------------------------------------
echo MR. ROBOT PC-CLEAN UTILITY
echo --------------------------------------------------------------------------------
echo.
echo Select a tool
echo =============
echo.
echo [1] Delete Internet Cookies
echo [2] Delete Temporary Internet Files
echo [3] Delete Internet History
echo [4] Disk Cleanup
echo [5] Disk Defragment
echo [6] System Usage
echo [7] HELP
echo [8] Exit
echo.
set /p op=Run:
if %op%==1 goto 1
if %op%==2 goto 2
if %op%==3 goto 3
if %op%==4 goto 4
if %op%==5 goto 5
if %op%==6 goto 6
if %op%==7 goto 7
if %op%==8 goto exit
goto error
:1
cls
echo --------------------------------------------------------------------------------
echo DELETE INTERNET COOKIES
echo --------------------------------------------------------------------------------
echo.
echo Deleting Cookies...
ping localhost -n 3 >nul
if "%version%" == "10.0" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.3" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.2" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.1" del /f /q "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
if "%version%" == "6.0" del /f /q "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
if "%version%" == "0.0" echo Cannot find folder location on this OS
cls
echo --------------------------------------------------------------------------------
echo DELETE INTERNET COOKIES
echo --------------------------------------------------------------------------------
echo. 
if "%version%" == "10.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.3" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.2" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.1" echo "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
if "%version%" == "6.0" echo "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
echo. 
echo Cookies Deleted.
echo.
pause
goto menu
:2
cls
echo --------------------------------------------------------------------------------
echo DELETE TEMPORARY INTERNET FILES
echo --------------------------------------------------------------------------------
echo.
echo Deleting Temporary Files...
ping localhost -n 3 >nul
if "%version%" == "10.0" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.3" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.2" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.1" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
if "%version%" == "6.0" del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
if "%version%" == "0.0" echo Cannot find folder location on this OS
cls
echo --------------------------------------------------------------------------------
echo DELETE TEMPORARY INTERNET FILES
echo --------------------------------------------------------------------------------
echo.
if "%version%" == "10.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.3" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.2" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.1" echo "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
if "%version%" == "6.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
echo.
echo Temporary Internet Files Deleted.
echo.
pause
goto menu
:3
cls
echo --------------------------------------------------------------------------------
echo DELETE INTERNET HISTORY
echo --------------------------------------------------------------------------------
echo.
echo Deleting Temporary Files...
ping localhost -n 3 >nul
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\History\*"
cls
echo --------------------------------------------------------------------------------
echo DELETE TEMPORARY INTERNET FILES
echo --------------------------------------------------------------------------------
echo.
echo "%userprofile%\AppData\Local\Microsoft\Windows\History\"
echo.
echo Temporary Internet Files and History Deleted.
echo.
pause
goto menu
:4
cls
echo --------------------------------------------------------------------------------
echo DISK CLEANUP
echo --------------------------------------------------------------------------------
echo.
echo Running Disk Cleanup...
ping localhost -n 3 >nul
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\Temp\*.*
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q “%userprofile%\Local Settings\Temporary Internet Files\*.*”
del /f /s /q “%userprofile%\Local Settings\Temp\*.*”
del /f /s /q “%userprofile%\recent\*.*”
cls
echo --------------------------------------------------------------------------------
echo DISK CLEANUP
echo --------------------------------------------------------------------------------
echo.
echo Disk Cleanup successful!
echo.
pause
goto menu
:5
cls
echo --------------------------------------------------------------------------------
echo DISK DEFRAGMENT
echo --------------------------------------------------------------------------------
echo.
echo Defragmenting hard disks...
ping localhost -n 3 >nul
defrag -c -v
cls
echo --------------------------------------------------------------------------------
echo DISK DEFRAGMENT
echo --------------------------------------------------------------------------------
echo.
echo Disk Defrag successful!
echo.
pause
goto menu
:6
cls
echo --------------------------------------------------------------------------------
echo SYSTEM USAGE
echo --------------------------------------------------------------------------------
echo.
echo Running System Usage...
echo.
for /f "TOKENS=3 DELIMS=\" %%i in ("%USERPROFILE%") do (set USER=%%i) 2>&1  
echo User: %USER% 
if "%version%" == "10.0" echo Windows 10
if "%version%" == "6.3" echo Windows 8.1
if "%version%" == "6.2" echo Windows 8
if "%version%" == "6.1" echo Windows 7
if "%version%" == "6.0" echo Windows Vista
set totalMem=
set availableMem=
set usedMem=
rem Loop
for /f "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem
VER
echo.
echo Total Memory: %totalMem%
echo Used Memory: %usedMem%
echo.
@echo off & setlocal ENABLEDELAYEDEXPANSION
SET "volume=C:"
FOR /f "tokens=1*delims=:" %%i IN ('fsutil volume diskfree %volume%') DO (
    SET "diskfree=!disktotal!"
    SET "disktotal=!diskavail!"
    SET "diskavail=%%j"
)
SET /a diskused=%disktotal:~0,-9% - %diskavail:~0,-9%
ECHO(Information for volume %volume%
echo.
ECHO(TOTAL SIZE: %disktotal:~0,-9% GB
ECHO(AVAILABLE SIZE: %diskavail:~0,-9% GB
ECHO(USED SIZE: %diskused% GB
echo.
pause
goto menu
:7
cls
echo --------------------------------------------------------------------------------
echo WTF DOES ALL THIS MEAN?
echo --------------------------------------------------------------------------------
echo.
echo Select a topic
echo ==============
echo.
echo [1] Internet Cookie Files
echo [2] Temporary Internet Files
echo [3] Internet History Files
echo [4] Disk Cleanup
echo [5] Disk Defragment
echo [6] System Usage
echo [7] Main Menu
echo.
set /p op=Run:
if %op%==1 goto A
if %op%==2 goto B
if %op%==3 goto C
if %op%==4 goto D
if %op%==5 goto E
if %op%==6 goto F
if %op%==7 goto menu
goto error
echo.
echo Press any button to return to the main menu...
pause >nul
goto menu
:A
cls
echo --------------------------------------------------------------------------------
echo INTERNET COOKIE FILES
echo --------------------------------------------------------------------------------
echo.
echo An HTTP Cookie is a small piece of data sent from a website and stored on the user's computer by the user's web browser while the user is browsing. Cookies were designed to be a reliable mechanism for websites to remember stateful information (such as items added in the shopping cart in an online store) or to record the user's browsing activity (including clicking particular buttons, logging in, or recording which pages were visited in the past). They can also be used to remember arbitrary pieces of information that the user previously entered into form fields such as names, addresses, passwords, and credit card numbers.
echo.
echo Internet Cookie Files can be found here:
if "%version%" == "10.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.3" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.2" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCookies\*.*"
if "%version%" == "6.1" echo "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
if "%version%" == "6.0" echo "%userprofile%\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
if "%version%" == "0.0" echo Cannot find folder location on this OS
echo.
echo Return to HELP...
pause >nul
goto 7
:B
cls
echo --------------------------------------------------------------------------------
echo TEMPORARY INTERNET FILES
echo --------------------------------------------------------------------------------
echo.
echo Temporary Internet Files is a folder on Microsoft Windows which serves as the browser cache for Internet Explorer to cache pages and other multimedia content, such as video and audio files, from websites visited by the user. This allows such websites to load more quickly the next time they are visited.
echo.
echo Temporary Internet Files can be found here:
if "%version%" == "10.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.3" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.2" echo "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"
if "%version%" == "6.1" echo "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
if "%version%" == "6.0" echo "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
if "%version%" == "0.0" echo Cannot find folder location on this OS
echo.
echo Return to HELP...
pause >nul
goto 7
:C
cls
echo --------------------------------------------------------------------------------
echo INTERNET HISTORY FILES
echo --------------------------------------------------------------------------------
echo.
echo Internet History is a repository of all of your browser activity. Any sites you have visited will be stored in this repository.
echo.
echo Internet History Files can be found here:
echo "%userprofile%\AppData\Local\Microsoft\Windows\History\"
echo.
echo Return to HELP...
pause >nul
goto 7
:D
cls
echo --------------------------------------------------------------------------------
echo DISK CLEANUP
echo --------------------------------------------------------------------------------
echo.
echo When running the Disk Cleanup, the program is looking for any unnecessary temporary files created by the OS. Temporary Files in Windows are those junk files whose use is only temporary and become redundant once the task in hand is completed. Such temporary file are created to hold data temporarily while a file is being created, processed, or used. A log file is a file that records either events that occur in an operating system or other software runs, or messages between different users of a communication software. Occasionally these files are not cleand up which can waste storage space and can consist of a variety of different file types, the most common being .tmp and .log.
echo.
echo TEMP files created by Windows can be found here:
echo "%system%\Windows\Temp\"
echo TEMP files created by the user can be found here:
echo "%userprofiles%\AppData\Local\"
echo.
echo Return to HELP...
pause >nul
goto 7
:E
cls
echo --------------------------------------------------------------------------------
echo DISK DEFRAGMENT
echo --------------------------------------------------------------------------------
echo.
echo Disk Defragmenter is a utility in Microsoft Windows designed to increase access speed by rearranging files stored on a disk to occupy contiguous storage locations, a technique called defragmentation. Defragmenting a disk minimizes head travel, which reduces the time it takes to read files from and write files to the disk.
echo.
echo Open Disk Defragmenter by typing the following into your cmd terminal: dfrgui
echo.
echo Return to HELP...
pause >nul
goto 7
:F
cls
echo --------------------------------------------------------------------------------
echo SYSTEM USAGE
echo --------------------------------------------------------------------------------
echo.
echo System Usage will show you the general information about your computer, including what user is logged in, what OS you are using, what version of Windows you are using, the size of your hard drive, the available space on your hard drive, etc.
echo.
echo You can find most of this information by pressing the WINDOWS key + the PAUSE|BREAK key.
echo.
echo Return to HELP...
pause >nul
goto 7
:error
cls
echo Command not recognized.
ping localhost -n 4 >nul
goto menu
:exit
echo MR. ROBOT PC-CLEAN brought to you by fSOCIETY
echo Version [1.1.0] (C) Copyright 2016
ping localhost -n 4 >nul
cls
echo.
echo.
echo.
echo 			EVILCORPEVILCORPEVILCORPEVILCORPEVI
echo 			LCORPEVILCORPEVILhCORPEVILCORPEVILC
echo 			EVILCORPEVILCNd+` .yORPEVILCORPEVIL
echo 			CORPEVILCORms-      /PEVILCORPEVILC
echo 			ORPEVILCOh/`     `:yRPEVILCORPEVILC
echo 			ORPEVIms-      .odMms--yLCORPEVILCO
echo 			RPEVh/`      /hILh/`    /mCORPEVILC
echo 			ORPE:       `odo-      -omVILCORPEV
echo 			ILCORy.       `     ./hPEd+..yVILCO
echo 			RPEVILm+`         -smCms-`    :mORP
echo 			EVILCORPd:        +mh/.     `/yEVIL
echo 			CORPEVILCOy.       .      -omRPEVIL
echo 			CORPEVILCORm+`         `/hPEVILCORP
echo 			EVILCORPEVILCd:      :smORPEVILCORP
echo 			EVILCORPEVILCORy. .+dPEVILCORPEVILC
echo 			ORPEVILCORPEVILCOhRPEVILCORPEVILCOR
echo 			PEVILCORPEVILCORPEVILCORPEVILCORPEV
ping localhost -n 3 >nul
endlocal
exit