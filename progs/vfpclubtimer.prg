*!*	IF VARTYPE(_Screen.tmrDownload) # "O"
	_Screen.AddObject("tmrDownload", "tmrMy")
*!*	ENDIF

DEFINE CLASS tmrMy AS Timer
	Enabled = .T.
	Interval = 60000
	Value = 0
	MaxValue = _Screen.DownloadTimer

	PROCEDURE Timer
	This.Value = This.Value + 1
	DO CASE
	CASE MAX(EMPTY(_Screen.DownloadTimer), EMPTY(_Screen.InternetInUse))
		This.Enabled = .F.
	CASE HOUR(DATETIME())<_Screen.DownloadFromHour
	CASE This.Enabled AND This.Value >= This.MaxValue
		This.Enabled = .F.
		IF vfpclubDownLoadRSS() > 0 AND _Screen.WindowState = 1
			Declare Integer FlashWindow In WIN32API Integer, Integer
			=FlashWindow(_VFP.hWnd, 1)
		ENDIF
	ENDCASE
	ENDPROC

	PROCEDURE Reset
	WITH _Screen
		This.Value = 0
		This.MaxValue = .DownloadTimer
		This.Enabled = !EMPTY(.DownloadTimer) AND !EMPTY(.InternetInUse)
	ENDWITH
	ENDPROC
ENDDEFINE
