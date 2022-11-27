@echo off
title HUDSON BACKUP2HHD PROGRAM
color 0F
echo --------------------------------------------------------------------------------
echo WELCOME TO THE COOL-AF HUDSON BACKUP2HHD PROGRAM
echo --------------------------------------------------------------------------------
echo.
echo This program is designed to copy all folders, subfolders, and files
echo from the hard disk drive (C:) to an external hard disk drive (E:).
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
echo   -/++....................BACKUP2HHD PROGRAM.......................-/-.//.-/-`    
echo   `-//`````````````````````````````````````````````````````````````-:--::-::-`    
echo      `                                                              `.` ..``.`   
echo.
ping localhost -n 3 >nul
cls

REM copy contacts
echo Copying files from "C:\Users\<username>\Contacts" to external HHD ...
xcopy "C:\Users\<username>\Contacts\*.*" E:\Users\<username>\MIRROR\Contacts /c /s /r /d /y /i > E:\Users\<username>\MIRROR\xcopy.log

REM copy desktop
echo COMPLETE
echo.
echo Copying files from "C:\Users\<username>\Desktop" to external HHD ...
xcopy "C:\Users\<username>\Desktop\*.*" E:\Users\<username>\MIRROR\Desktop /c /s /r /d /y /i >> E:\Users\<username>\MIRROR\xcopy.log

REM copy documents
echo COMPLETE
echo.
echo Copying files from "C:\Users\<username>\Documents" to external HHD ...
xcopy "C:\Users\<username>\Documents\*.*" E:\Users\<username>\MIRROR\Documents /c /s /r /d /y /i >> E:\Users\<username>\MIRROR\xcopy.log

REM copy program files
echo COMPLETE
echo.
echo Copying files from "C:\Program Files" to external HHD ...
xcopy "C:\Program Files\*.*" E:\Users\<username>\MIRROR\ProgramFiles /c /s /r /d /y /i >> E:\Users\<username>\MIRROR\xcopy.log

REM copy program files x86
echo COMPLETE
echo.
echo Copying files from "C:\Program Files (x86)" to external HHD ...
xcopy "C:\Program Files\*.*" E:\Users\<username>\MIRROR\ProgramFiles86 /c /s /r /d /y /i >> E:\Users\<username>\MIRROR\xcopy.log
cls

REM end
echo --------------------------------------------------------------------------------
echo GET OUTTA HERE
echo --------------------------------------------------------------------------------
echo Thank you for using the Hudson Bulk Copy Program. 
echo ES TACO MARTES?
ping localhost -n 3 >nul
cls 

echo HUDSON BACKUP2HHD PROGRAM brought to you by fSOCIETY
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