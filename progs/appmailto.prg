LPARAMETERS cMail, cSubject
IF !EMPTY(m.cMail)
	LOCAL lnRes, nWinHandle, cOperation, cFileName, cParameters, cDirectory, nShowWindow
	DECLARE INTEGER ShellExecute IN SHELL32.DLL INTEGER nWinHandle, STRING cOperation, STRING cFileName, STRING cParameters, STRING cDirectory, INTEGER nShowWindow
	WITH _Screen
		lnRes = ShellExecute(0, "Open", "mailto:"+m.cMail+"?subject="+IIF(EMPTY(m.cSubject), .CAPTION, ALLTRIM(m.cSubject)), "", ADDBS(SYS(5)), 1)
		IF m.lnRes < 32
			DO CASE
			CASE m.lnRes = 2
				MESSAGEBOX ("Неверная ассоциация или адрес (URL)", 16, .CAPTION, .MBTimeout)
			CASE m.lnRes = 31
				MESSAGEBOX ("Нет связанной программы", 16, .CAPTION, .MBTimeout)
			CASE m.lnRes = 29
				MESSAGEBOX ("Не удалось запустить программу", 16, .CAPTION, .MBTimeout)
			CASE m.lnRes = 30
				MESSAGEBOX ("Программа в данный момент недоступна", 16, .CAPTION, .MBTimeout)
			ENDCASE
		ENDIF
	ENDWITH
	CLEAR DLLS
ENDIF
