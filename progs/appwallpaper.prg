#DEFINE nScaleMode 3
IF TYPE("_Screen.livewallpaper") # "O"
	_Screen.AddObject("livewallpaper", "tmrwallpaper")
ENDIF

DEFINE CLASS tmrwallpaper AS Timer
	Interval = 60000
	Enabled = _Screen.ScreenSaver > 0 AND _Screen.Visible AND _Screen.TurboMode=0
	Value = 0
	MaxValue = MAX(_Screen.ScreenSaver, 1)
	nRow = PI()
	nCol = PI()
	nWindow = WCHILD(_Screen.Name)
	cStop = ""
	cWinOnTop = WONTOP()
*!*		nSeconds = SECONDS()

PROCEDURE Timer
	This.Value = This.Value + 1
	DO CASE
	CASE This.Enabled=.F.
	CASE EMPTY(_Screen.ScreenSaver) OR !_Screen.Visible OR !EMPTY(_Screen.TurboMode)
		This.Enabled = .F.
	CASE This.Value >= This.MaxValue
		This.Refresh
		This.Value = 0
	ENDCASE
ENDPROC

PROCEDURE Refresh
	This.Enabled=.F.
	This.uMethod(IIF(EMPTY(irand(0,2)),_Screen.www, _Screen.Caption))
	This.uMethod(_Screen.Demo)
	DO CASE
	CASE _Screen.nStep>=0
	CASE EMPTY(_Screen.lStop)
	CASE This.cWinOnTop # WONTOP()
	CASE This.nWindow # WCHILD(_Screen.Name)
	CASE WEXIST('Report Designer -')
	CASE !ISMOUSE()
	CASE This.nRow = MROW(_Screen.Name, nScaleMode) AND This.nCol = MCOL(_Screen.Name, nScaleMode) &&AND This.nRow > 0 AND This.nCol >0
		IF EMPTY(INKEY(7, 'HM'))
			WITH _Screen
				STORE 1 TO .WindowState
				STORE IIF(EMPTY(.NeedAccess), .AccessLevel, 0) TO .AccessLevel
				KEYBOARD "{F10}"
				IF !EMPTY(.FormCount)
					LOCAL ii
					FOR ii = 1 TO .FormCount
						.Forms(ii).Refresh
					ENDFOR
				ENDIF
			ENDWITH
			DECLARE INTEGER SendMessage IN Win32API INTEGER, INTEGER, INTEGER, INTEGER
			=SendMessage(-1, 274, 61760, 0)
		ENDIF
	ENDCASE
	WITH _Screen
		STORE WCHILD(.Name) TO This.nWindow
		STORE MROW(.Name, nScaleMode) TO This.nRow
		STORE MCOL(.Name, nScaleMode) TO This.nCol
	ENDWITH
	This.cWinOnTop = WONTOP()
ENDPROC

PROCEDURE uMethod
	LPARAMETERS cParam
	WITH _Screen
		.FONTSIZE = irand(8, 36)
		.FontBold = EMPTY(MOD(.FONTSIZE, 3))
		.FontItalic=EMPTY(MOD(.FONTSIZE, 4))
		.ForeColor=irand(1, 16777200)
		.PSet(irand(0, .Width - .TextWidth(cParam)), irand(0, .Height - .TextHeight(cParam)))
		.Print(cParam)
	ENDWITH
ENDPROC

PROCEDURE StopStart
	LPARAMETERS cParam
	CLEAR TYPEAHEAD
	This.Value = 0
	IF EMPTY(cParam)
		ON ESCAPE
		SET ESCAPE OFF
		This.Enabled = !EMPTY(_Screen.ScreenSaver)
		This.cStop = ""
		_Screen.lStop = .T.
		SET MESSAGE TO
	ELSE
		This.Enabled = .F.
		This.cStop = cParam
		_Screen.lStop = .F.
		SET ESCAPE ON
		ON ESCAPE _Screen.livewallpaper.mStop()
	ENDIF
	=AppProgressBar()
ENDPROC

PROCEDURE mStop
	_Screen.Click
	CLEAR TYPEAHEAD
	IF MESSAGEBOX("Прервать процесс", 33 + _Screen.NormalMode*256, This.cStop, _Screen.MBTimeout) = 1
		WAIT CLEAR
		This.StopStart()
	ENDIF
ENDPROC

ENDDEFINE
