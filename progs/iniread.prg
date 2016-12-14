LPARAMETERS tcFileName, tcSection, tcEntry
*tcFileName	файл INI
*tcSection	секция
*tcEntry	переменная
IF EMPTY(tcFileName) AND EMPTY(tcSection)
	STORE "win.ini" TO tcFileName
	STORE "Foxtrot" TO tcSection
ELSE
	STORE IIF(EMPTY(tcFileName), "win.ini", ALLTRIM(tcFileName) + IIF(JUSTEXT(TRIM(tcFileName))="ini", "", ".ini")) TO tcFileName
	STORE IIF(EMPTY(tcSection), "Foxtrot", tcSection) TO tcSection
ENDIF
STORE IIF(EMPTY(tcEntry), "", ALLTRIM(tcEntry)) TO tcEntry

LOCAL lcIniValue, lnResult, lnBufferSize
DECLARE INTEGER GetPrivateProfileString IN WIN32API ;
	STRING cSection, STRING cEntry, STRING cDefault, STRING @cRetVal, INTEGER nSize, STRING cFileName

lnBufferSize = 254
lcIniValue = SPACE(lnBufferSize)

lnResult=GetPrivateProfileString(tcSection, tcEntry, "*NULL*", @lcIniValue, lnBufferSize, tcFileName)
lcIniValue=SUBSTR(lcIniValue, 1, lnResult)

IF lcIniValue="*NULL*"
	lcIniValue=""	&&.NULL.
ENDIF

RETURN ALLTRIM(lcIniValue)
