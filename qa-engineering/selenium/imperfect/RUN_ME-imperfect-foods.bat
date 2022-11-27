REM =========================================================
REM Created by : Keith Hudson
REM Create date : 2021-04-10
REM Description : Imperfect Foods Automation
REM =========================================================
@ECHO off
REM =========================================================
REM Set date to YYYY-MM-DD format. Time is 24hr format.
REM =========================================================
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
SET date=%yyyy%-%mm%-%dd%

REM =========================================================
REM Setup script variables.
REM =========================================================
SET homedir=C:\AUTOMATION\WORKSPACES\IMPERFECT\
SET logfile=BaconAutomationResults-%date%
TITLE NINJA KIT (KeithInTech) IMPERFECT FOODS AUTOMATION
REM Clears the screen
CLS
ECHO.                                                                         
ECHO                 .-`                                                                                         
ECHO                +s+`-//`                                                                                     
ECHO               +o:-sss+`                                                                                     
ECHO              .+`+sss:                                                                                       
ECHO              .:/sso:                                                                                        
ECHO              .s/.-:/++/:-.`                                                                                 
ECHO              .o:-..``:+++/:                                                                                 
ECHO             `:+:`     :-     -:`  .:/:::-.   -::::///`  ///:::-    ://:::::  ://////:    .::/:- `::::::::.  
ECHO             oyyy+    -yyo`  +yy-  -yyo/+sy+  +yy/////. `yyo++sys`  sys++++/  yyo////:  -oys+++o.`++oyyo++-  
ECHO             syyys    /yyyo.oyyy+  -yy:  `yy. /yy:::::  `yy+  .yy-  oys::/:-  yyo////. -yy/         -yy/     
ECHO             syyyy.   oysoyyysyyo  -yyo:/oys` /yy////:   yys:/oys`  sys////.  yyo////. +yy`         .yy/     
ECHO             oyyyy+   syo`oys`sys  -yyo/::.   /ys       `yys/sys.   syo       sy/      -yy+.        .yy/     
ECHO             /yyyyy. `yy/  :` +yy. -yy:       /yysssos- `yyo `+ys:  oys       syssssss  .+yyyssy.   .yy+     
ECHO             :yyyyy+ `--.     .--` `--.       `-------`  ---   .--` .--       .-------    `.---.    `--.     
ECHO             -yyyoys                   `````      `         ``      ```        ``                            
ECHO             .yyy.sy`                 .y/:/:  `/+//+o-   `/o//+o-   /s/++-   .s//o:                          
ECHO             .yyo -y.                 .y+//-  s+    .y-  o+    `s-  /o  .y.  .o/:-`                          
ECHO             .yy:  -`                 .y`     o+    .y-  o+    .s-  /o  .s.  ..`.+s                          
ECHO             `ys`                     .y`     `/o+++o-   `/o+++o-   /s/++.   .+++o:                          
ECHO              --                                                                                             
ECHO.                                                                                                
ECHO.                                                           
ECHO                       ........................IMPERFECT FOODS PRESENTS......................... 
ECHO                       `````````````````````````````````````````````````````````````````````````
ping localhost -n 3 >nul
CLS
ECHO.
ECHO.                                                                                                   
ECHO                                        .://:-.`                        :yNm.        
ECHO                  +s+-`    ss/-`     `ommysssyhmNdyo/-`  `+hy         :dmo.          
ECHO                  omyydms `ymyydmo  /Nh-         .:+shmNdNh:        -dN+        `.   
ECHO                  .N:Ns/.  :N:Mo/` .Mh                 hM:        `sMs` .-      dN`  
ECHO                  dddh    `Nhms    :Mo                yM:        :md-  `NMs    oM+   
ECHO                 oNhN.    ymdm`    `mm-              +Mo       .hN+     `.    -Mh    
ECHO                .MyN+    :MyN-      `smmyssshmm.    .Mh      .sMy`    -h: odmmNMmmms 
ECHO                dsdh    `m+ms          .://:-`      dN.    :yNy.     `Nm`  ``yM:```  
ECHO               +m:N.    yh+m`                      +M++osdNh+`       dM-    :Ms      
ECHO              .N:m+    :N-N:         :ohmmd       .Md /+sdNs`       oM+    `Nm       
ECHO              dosh    `m/hs        +mmo-`         dM.     :Nd      -Mh     hM.       
ECHO             +m:N.    yh/m`       hM/            +Mo       oM/     mN.    +Mo     `dd
ECHO            .N:m+    :N-N:       oM/            -Md        -Ms    oM/    :Md     `dN-
ECHO            dssh    `m/hs        dM            .mm`        -Ms    Nd    /MM-    -mm. 
ECHO           +m:N.    sh/m`        sM:          :Nm.         :Mo   .Mh  .yMmM.  -sMs`  
ECHO          .N:m+    :N-N:         `hNo`     `:hMs`          oM:    +mmNms..hNmNdo.    
ECHO          shyh     hsds            :ymmdhdmNh+`            hM`                       
ECHO          dMy      NMo                `...`                mm                        
ECHO          d+      `m/                                      hM.                       
ECHO                                                           .hNys-                    
ECHO                                                             .:/.  
ECHO.                                                           
ECHO                 ...................NINJA "KIT" AUTOMATION......................  
ECHO                 .......................keith in tech...........................
ping localhost -n 3 >nul
CLS
REM =========================================================
REM close all open browsers prior to running jar
REM =========================================================
ECHO.
ECHO.
ECHO Closing all open browsers. Please save your work and press ENTER when ready...
PAUSE >nul
taskkill /f /im "chrome.exe"
taskkill /f /im "firefox.exe"
taskkill /f /im "iexplore.exe"
ECHO.
ECHO.
REM =========================================================
REM run the automation jar
REM =========================================================
ECHO [%date% %time%]
ECHO Changing directory and running Bacon Automation...
ECHO.
cd %homedir%
java -jar imperfect.jar >> %logfile%.log 2>&1
ECHO.
ECHO Automation is complete. Please see test results in the folowing location:
ECHO %homedir%\%logfile%.log
ECHO.
ECHO And don't forget to select me as your Grand Bacon Automation Chmapion!
ECHO.
PAUSE
EXIT