@echo off
:alphastart
cls
title TIC-TAC-TOE
set sc1=0
set sc2=0
set af=0
:start
cls
color 0e
set z1=1
set z2=2
set z3=3
set z4=4
set z5=5
set z6=6
set z7=7
set z8=8
set z9=9
if %sc1% GEQ 1 GOTO extra
if %sc2% GEQ 1 GOTO extra
echo.
echo TIC TAC TOE
echo.
echo.
echo Choose a name for Player 1.
echo.
set/p name1=
cls
echo.
echo TIC TAC TOE
echo.
echo.
echo Choose a name for Player 2.
echo.
set/p name2=
cls
:extra

:spieler1a
if %af%==2 GOTO spieler2a
set z1=1
set z2=2
set z3=3
set z4=4
set z5=5
set z6=6
set z7=7
set z8=8
set z9=9
:spieler1
color 0e
cls
echo.
echo TIC TAC TOE
echo %sc1%:%sc2%
echo.
echo %z1% I %z2% I %z3%
echo -----------
echo %z4% I %z5% I %z6% 
echo -----------
echo %z7% I %z8% I %z9% 
echo.
echo.
echo %name1% sets x.
echo.
echo.
echo Type in "restart" to reset the round or
echo "alpharestart" to restart the file.
set/p x=
if %x%==1 GOTO a1
if %x%==2 GOTO a2
if %x%==3 GOTO a3
if %x%==4 GOTO a4
if %x%==5 GOTO a5
if %x%==6 GOTO a6
if %x%==7 GOTO a7
if %x%==8 GOTO a8
if %x%==9 GOTO a9
if %x%==restart GOTO spieler1a
if %x%==alpharestart GOTO alphastart
if %x%==win GOTO sc1win

:a1
if %z1%==o GOTO spieler1
if %z1%==x GOTO spieler1
set z1=x
goto check

:a2
if %z2%==o GOTO spieler1
if %z2%==x GOTO spieler1
set z2=x
goto check

:a3
if %z3%==o GOTO spieler1
if %z3%==x GOTO spieler1
set z3=x
goto check

:a4
if %z4%==o GOTO spieler1
if %z4%==x GOTO spieler1
set z4=x
goto check

:a5
if %z5%==o GOTO spieler1
if %z5%==x GOTO spieler1
set z5=x
goto check

:a6
if %z6%==o GOTO spieler1
if %z6%==x GOTO spieler1
set z6=x
goto check

:a7
if %z7%==o GOTO spieler1
if %z7%==x GOTO spieler1
set z7=x
goto check

:a8
if %z8%==o GOTO spieler1
if %z8%==x GOTO spieler1
set z8=x
goto check

:a9
if %z9%==o GOTO spieler1
if %z9%==x GOTO spieler1
set z9=x
goto check

:spieler2a
if %af%==1 GOTO spieler1a
set z1=1
set z2=2
set z3=3
set z4=4
set z5=5
set z6=6
set z7=7
set z8=8
set z9=9
:spieler2
color 0e
cls
echo.
echo TIC TAC TOE
echo %sc1%:%sc2%
echo.
echo %z1% I %z2% I %z3%
echo -----------
echo %z4% I %z5% I %z6% 
echo -----------
echo %z7% I %z8% I %z9% 
echo.
echo.
echo %name2% sets o.
echo.
echo.
echo Type in "restart" to reset the round or
echo "alpharestart" to restart the file.
set/p o=
if %o%==1 GOTO b1
if %o%==2 GOTO b2
if %o%==3 GOTO b3
if %o%==4 GOTO b4
if %o%==5 GOTO b5
if %o%==6 GOTO b6
if %o%==7 GOTO b7
if %o%==8 GOTO b8
if %o%==9 GOTO b9
if %o%==restart GOTO spieler2a
if %o%==alpharestart GOTO alphastart
if %o%==win GOTO sc2win

:b1
if %z1%==o GOTO spieler2
if %z1%==x GOTO spieler2
set z1=o
goto check2

:b2
if %z2%==o GOTO spieler2
if %z2%==x GOTO spieler2
set z2=o
goto check2

:b3
if %z3%==o GOTO spieler2
if %z3%==x GOTO spieler2
set z3=o
goto check2

:b4
if %z4%==o GOTO spieler2
if %z4%==x GOTO spieler2
set z4=o
goto check2

:b5
if %z5%==o GOTO spieler2
if %z5%==x GOTO spieler2
set z5=o
goto check2

:b6
if %z6%==o GOTO spieler2
if %z6%==x GOTO spieler2
set z6=o
goto check2

:b7
if %z7%==o GOTO spieler2
if %z7%==x GOTO spieler2
set z7=o
goto check2

:b8
if %z8%==o GOTO spieler2
if %z8%==x GOTO spieler2
set z8=o
goto check2

:b9
if %z9%==o GOTO spieler2
if %z9%==x GOTO spieler2
set z9=o
goto check2

:check
cls
if %z1%==x if %z2%==x if %z3%==x GOTO 1w
if %z4%==x if %z5%==x if %z6%==x GOTO 1w
if %z7%==x if %z8%==x if %z9%==x GOTO 1w
if %z1%==x if %z4%==x if %z7%==x GOTO 1w
if %z2%==x if %z5%==x if %z8%==x GOTO 1w
if %z3%==x if %z6%==x if %z9%==x GOTO 1w
if %z1%==x if %z5%==x if %z9%==x GOTO 1w
if %z3%==x if %z5%==x if %z7%==x GOTO 1w
goto spieler2

:check2
cls
if %z1%==o if %z2%==o if %z3%==o GOTO 2w
if %z4%==o if %z5%==o if %z6%==o GOTO 2w
if %z7%==o if %z8%==o if %z9%==o GOTO 2w
if %z1%==o if %z4%==o if %z7%==o GOTO 2w
if %z2%==o if %z5%==o if %z8%==o GOTO 2w
if %z3%==o if %z6%==o if %z9%==o GOTO 2w
if %z1%==o if %z5%==o if %z9%==o GOTO 2w
if %z3%==o if %z5%==o if %z7%==o GOTO 2w
goto spieler1

:1w
color 0c
set/a sc1=%sc1%+1
if %sc1%==5 GOTO sc1win
echo.
echo TIC TAC TOE
echo.
echo.
echo %name1% won the round ! 
echo.
echo %name1% %sc1% : %sc2% %name2%
echo.
echo.
echo.
pause
set af=2
goto start
:sc1win
cls
color 0e
echo.
echo TIC TAC TOE
echo %sc1% : %sc2%
echo. 
echo %name1% won the Match !!!
echo.
echo %date%/%time%
echo. 
echo Type in "restart" to restart, "finish" to close the file or 
echo "save", to save the results in Tic_tac_toe_log.txt on your desktop.
set/p alphaend=
if %alphaend%==restart GOTO alphastart
if %alphaend%==save GOTO save1
exit
:2w
color 06
set/a sc2=%sc2%+1
if %sc2%==5 GOTO sc2win
echo.
echo TIC TAC TOE
echo.
echo.
echo %name2% won the round ! 
echo.
echo %name1% %sc1% : %sc2% %name2%
echo.
echo.
echo.
pause
set af=1
goto start
:sc2win
cls
color 0e
echo.
echo TIC TAC TOE
echo %sc1% : %sc2%
echo. 
echo %name2% won the Match !!!
echo.
echo %date%/%time%
echo.
echo Type in "restart" to restart, "finish" to close the file or 
echo "save", to save the results in Tic_tac_toe_log.txt on your desktop.
set/p alphaend=
if %alphaend%==restart GOTO alphastart
if %alphaend%==save GOTO save2
:alphaend
exit
:save1
echo %name1% has won at the %date% at %time% %sc1% : %sc2% to %name2% in Tic Tac Toe.>> Tic_tac_toe_log.txt
goto sc1win

:save2 
echo %name2% has won at the %date% at %time% %sc2% : %sc1% to %name1% in Tic Tac Toe.>> Tic_tac_toe_log.txt
goto sc2win