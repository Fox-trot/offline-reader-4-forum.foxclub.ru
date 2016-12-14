LPARAMETERS tcFileName, tcSection, tcEntry, tcValue
*tcFileName		файл INI
*tcSection		секция
*tcEntry		переменная	*
*tcValue		значение
IF !EMPTY(tcEntry)
	IF EMPTY(tcFileName) AND EMPTY(tcSection)
		STORE "win.ini" TO tcFileName
		STORE "Foxtrot" TO tcSection
	ELSE
		STORE IIF(EMPTY(tcFileName), "win.ini", ALLTRIM(tcFileName) + IIF(JUSTEXT(TRIM(tcFileName))="ini", "", ".ini")) TO tcFileName
		STORE ALLTRIM(IIF(EMPTY(tcSection), STR(_SCREEN.UserID), tcSection)) TO tcSection
	ENDIF
	STORE ALLTRIM(tcEntry) TO tcEntry
	STORE IIF(EMPTY(tcValue), "", ALLTRIM(tcValue)) TO tcValue
	DECLARE INTEGER WritePrivateProfileString IN WIN32API ;
	STRING cSection, STRING cEntry, STRING cEntry, STRING cFileName
	RETURN WritePrivateProfileString(tcSection,tcEntry,tcValue,tcFileName)=1
ENDIF
RETURN .F.
