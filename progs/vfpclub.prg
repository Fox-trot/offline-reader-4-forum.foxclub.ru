LPARAMETERS cParam1, cParam2, cParam3, cParam4, cParam5, cParam6, cParam7, cParam8, cParam9
*!*	IF IIF(EMPTY(VERSION(2)), !EMPTY(AppIsStarted("Форум FoxPro Club")), .T.)
*!*		RETURN .F.
*!*	ENDIF
_Screen.Caption = "Форум FoxPro Club"
_Screen.Comment="foxclub"
*!*	IF EMPTY(cParam1) AND FILE("splash.jpg")
*!*		SET PROCEDURE TO splash
*!*		cParam1=CREATEOBJECT("splash")
*!*		SET PROCEDURE TO
*!*	ENDIF
WITH _SCREEN
	.ADDPROPERTY("BlobJob","club!clubblob")
	.ADDPROPERTY("ini",ADDBS(SYS(5)+SYS(2003))+.Comment+".ini")
	.ADDPROPERTY("www","www.foxclub.ru")
	.Icon="foxprow.ico"
ENDWITH
DO AppResource WITH _SCREEN.Comment
DO AppSystem WITH .T.
DO vfpclubPublic
IF !EMPTY(m.cParam1)
	STORE UPPER("/"+m.cParam1+IIF(EMPTY(m.cParam2),"","/"+m.cParam2)) TO cParam1
	IF "/INDEX"$m.cParam1 OR !FILE(_SCREEN.ini)
		DO vfpclubIndex WITH .T.
	ENDIF
	IF "/TEST"$m.cParam1 OR !FILE(_SCREEN.ini)
		DO vfpclubAudit WITH .T.
	ENDIF
ENDIF
DO ShowScreen
DO vfpclubtimer
IF FILE(_Screen.Comment+".hlp")
	SET HELP TO (_Screen.Comment)
	SET HELP ON
ELSE
	ON KEY LABEL F1 MESSAGEBOX("Нет файла-справки VFPCLUB.HLP"+CHR(13)+"Помощь недоступна",16,_SCREEN.CAPTION, _Screen.MBTimeout)
ENDIF
DO vfpclubSystem WITH 1
RELEASE ALL LIKE cParam*
*!*	CLEAR WINDOW
READ EVENTS

**************************************************
EXTERNAL FILE foxprow.ico
