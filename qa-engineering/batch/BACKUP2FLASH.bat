@echo off
title HUDSON BACKUP2FLASH PROGRAM
color 0F
echo --------------------------------------------------------------------------------
echo WELCOME TO THE COOL-AF HUDSON BACKUP2FLASH PROGRAM
echo --------------------------------------------------------------------------------
echo.
echo This program is designed to copy all folders, subfolders, and files
echo from the hard disk drive (C:) to an external USB flash drive (F:).
echo.
echo This program was brought to you by . . . 
pause >nul
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
echo   -/++....................BACKUP2FLASH PROGRAM.....................-/-.//.-/-`    
echo   `-//`````````````````````````````````````````````````````````````-:--::-::-`    
echo      `                                                              `.` ..``.`   
echo.
ping localhost -n 3 >nul
cls

REM copy contacts
echo Copying files from "C:\Users\<username>\Contacts" to USB flash drive ...
xcopy "C:\Users\<username>\Contacts\*.*" F:\RACETRAC\Contacts /c /s /r /d /y /i > F:\RACETRAC\xcopy.log

REM copy desktop
echo COMPLETE
echo.
echo Copying files from "C:\Users\<username>\Desktop" to USB flash drive ...
xcopy "C:\Users\<username>\Desktop\*.*" F:\RACETRAC\Desktop /c /s /r /d /y /i >> F:\RACETRAC\xcopy.log

REM copy documents
echo COMPLETE
echo.
echo Copying files from "C:\Users\<username>\Documents" to USB flash drive ...
xcopy "C:\Users\<username>\Documents\*.*" F:\RACETRAC\Documents /c /s /r /d /y /i >> F:\RACETRAC\xcopy.log

REM copy program files
echo COMPLETE
echo.
echo Copying files from "C:\Program Files" to USB flash drive ...
xcopy "C:\Program Files\*.*" F:\RACETRAC\ProgramFiles /c /s /r /d /y /i >> F:\RACETRAC\xcopy.log

REM copy program files x86
echo COMPLETE
echo.
echo Copying files from "C:\Program Files (x86)" to USB flash drive ...
xcopy "C:\Program Files\*.*" F:\RACETRAC\ProgramFiles86 /c /s /r /d /y /i >> F:\RACETRAC\xcopy.log
cls

REM end
echo --------------------------------------------------------------------------------
echo GET OUTTA HERE
echo --------------------------------------------------------------------------------
echo Thank you for using the Hudson Bulk Copy Program. 
echo ES TACO MARTES?
ping localhost -n 3 >nul
cls 

echo HUDSON BACKUP2FLASH PROGRAM brought to you by fSOCIETY
echo Version [1.1.0] (C) Copyright 2017
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
exit