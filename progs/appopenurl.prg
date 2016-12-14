LPARAMETERS cParam
IF !EMPTY(m.cParam)
	WAIT WINDOW "Loading Internet Browser.." NOWAIT
	DECLARE INTEGER ShellExecute IN SHELL32.dll INTEGER nWinHandle, STRING cOperation, STRING cFileName, STRING cParameters, STRING cDirectory, INTEGER nShowWindow
	=ShellExecute(0, "Open", m.cParam, "", "", 0)
ENDIF
