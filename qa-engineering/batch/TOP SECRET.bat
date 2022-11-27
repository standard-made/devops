@ECHO OFF
Color 07
Title TOP SECRET
SET tries=4
:top
CLS
SET /a tries=%tries% -1
if %tries%==0 (
	GOTO penalty
)
ECHO You have %tries% attempts left.
ECHO Please enter your password to proceed
SET /p password=
if %password%==<your password> (
	CLS
	ECHO Welcome 8Kit Almighty. 
	ECHO Now revealing your TOP SECRET folder.
	ECHO [ENTER] to continue
	PAUSE >nul
	CLS
	ECHO REMINDER: look here --- E:\Users\<username>\TOP SECRET
	ECHO [ENTER] to continue
	PAUSE >nul
		attrib -s -h "E:\Users\<username>\TOP SECRET"
	CLS
	ECHO The TOP SECRET folder is now visible. Continuing will hide folder.
	ECHO [ENTER] to continue
	PAUSE >nul
	
		attrib +s +h "E:\Users\<username>\TOP SECRET"
	CLS
	ECHO The TOP SECRET folder is now hidden.
	ECHO [ENTER] to exit
	PAUSE >nul
	EXIT
) else (
	GOTO top
)
GOTO top
:penalty
	ECHO Nice Try. Next time ask for the magic word.
	ECHO PS You Suck!
	PAUSE >nul
	EXIT
)