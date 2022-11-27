@echo off
title Website Selector by beardedhudson inc
:top
REM ==========================================================
REM Program
REM ==========================================================
echo --------------------------------------------------------------------------------
echo WELCOME TO THE WEBSITE SELECTOR PROGRAM
echo --------------------------------------------------------------------------------
echo.
echo This is an application that lets you select from a list of sites
echo.
echo This program was brought to you by . . . 
ping localhost -n 5 >nul
cls
echo.
echo.
echo.
echo.
echo     .:::`  :::.  .         .  -::::--`     `-:/:.      .::::.   `:::`  -::.    
echo     +NNN/ .NNNh .o::::./::/o` dNNNNNNNh: `sNNNNNNmo  /dNNNNNNd: -NNNd.`NNNo    
echo     +NNNy+oNNNh -ooo:---/ooo. dNNN::mNNN.:NNNmoys+/`.NNNm--NNNN`-NNNNm/NNNo    
echo     +NNNNNNNNNh +ooooooooooo/ dNNN` hNNN- +dNNNNNNh--NNNh  mNNN`-NNNNNNNNNo    
echo     +NNNo-/NNNh.ooooooooooooo`dNNN/+mNNN.:sssoohNNNo.NNNm//NNNm`-NNNohNNNNo    
echo     +NNN/ .NNNh.ooooooooooooo`dNNNNNNmy- `smNNNNNms` :hNNNNNNy- -NNN+ oNNNo    
echo     `...   ...` `-/ooooooo/-  `.....`       .--.`      `.--.     ...`  `..`    
echo                 `./+ooo++:.`                                                      
echo                    ``..`
echo     .:                                                             `-:..:-`-:`  
echo   -/++......................WEBSITE SELECTOR PROGRAM................-/-.//.-/-`  
echo   `-//``````````````````````````beardedhudson inc``````````````````-:--::-::-`    
echo      `                                                              `.` ..``.`   
echo.
ping localhost -n 5 >nul
cls

echo --------------------------------------------------------------------------------
echo WEBSITE SELECTOR
echo --------------------------------------------------------------------------------
echo.
echo Key: [1] GOOGLE
echo [2] YOUTUBE
echo [3] WIKI
echo [4] PORTAL
echo [5] JIRA
echo [6] QA COMPLETE
echo [7] TEST COMPLETE
echo [8] STACK OVERFLOW
echo [9] CODE ACADEMY
echo [10] SQL AUTHORITY
echo.
echo [e] Exit
echo.
echo --------------------------------------------------------------------------------
echo Enter the number of the website which you would like to go to:
echo.
set /p udefine= 
echo.
echo --------------------------------------------------------------------------------
if %udefine%==1 start www.google.com
if %udefine%==2 start www.youtube.com
if %udefine%==3 start www.wikipedia.com
if %udefine%==4 start https://portal.racetrac.com/Home
if %udefine%==5 start https://isdeptjira.rt.corp/login.jsp
if %udefine%==6 start http://130.100.251.201/common/Logon.asp?app=agSPEnt
if %udefine%==7 start https://support.smartbear.com/
if %udefine%==8 start https://stackoverflow.com/
if %udefine%==9 start https://www.codecademy.com/
if %udefine%==10 start https://blog.sqlauthority.com/
if %udefine%==e goto exit

cls
echo --------------------------------------------------------------------------------
echo Thank You for using Site Selector by beardedhudson inc
echo --------------------------------------------------------------------------------
echo.
echo --------------------------------------------------------------------------------
echo Type [e] to exit or [b] to go back and select another site.
echo.
set /p udefine=
echo.
echo --------------------------------------------------------------------------------
if %udefine%==b goto top
if %udefine%==e goto exit
:exit
cls
REM Get Outta Here
echo --------------------------------------------------------------------------------
echo GET OUTTA HERE
echo --------------------------------------------------------------------------------
echo Thank you for using Website Selector Program by beardedhudson inc. 
echo NOS VEMOS LA PROXIMA VEX
ping localhost -n 3 >nul
exit