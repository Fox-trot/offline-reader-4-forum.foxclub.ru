LPARAMETERS nParam, uParam
*!*	_Screen.livewallpaper.Reset
DO CASE
CASE EMPTY(m.nParam)
	WAIT WINDOW 'Подождите, пожалуйста..' NOWAIT NOCLEAR
	IF VARTYPE(_Screen.oX)#"O"
		_Screen.oX=CREATEOBJECT("EXCEL.Application")
	ENDIF
	IF VARTYPE(_Screen.oX)#"O"
		WAIT CLEAR
		MESSAGEBOX("Невозможно запустить MS Excel",16,_Screen.Caption,_Screen.MBTimeout)
		_Screen.Excel97=.2
		RETURN .F.
	ENDIF
	IF EMPTY(_Screen.Excel97)
		_Screen.Excel97=INT(VAL(_Screen.oX.Version))
	ENDIF
	IF BETWEEN(_Screen.Excel97,1,7)
		WAIT CLEAR
		MESSAGEBOX("Требуется UPDATE до версии 8",16,_Screen.oX.Application.Caption,_Screen.MBTimeout)
		IF FILE(_Screen.ini)
			DO INIWrite WITH _Screen.ini,"Main","Excel97",STR(_Screen.Excel97)
		ENDIF
		RETURN .F.
	ENDIF
	WITH _Screen.oX.Application
		.VISIBLE=.F.
		.EnableAnimations = .F.
		.EnableEvents = .F.
		.IgnoreRemoteRequests = .F.
		.Interactive = .F.
		.ScreenUpdating = .F.
	ENDWITH
CASE VARTYPE(_Screen.oXS)#"O"
*!*	CASE m.nParam=-1
*!*	*	_Screen.oXS.Application.Quit
*!*		STORE .F. TO _Screen.oXS
*!*		STORE .F. TO _Screen.oX
CASE m.nParam=1
	LOCAL ARRAY ap(1)
	IF !EMPTY(APRINTERS(ap))
		WITH _Screen.oXS.Sheets(1).PageSetup
			.HeaderMargin =_Screen.oXS.APPLICATION.CentimetersToPoints(0)
			.FooterMargin =_Screen.oXS.APPLICATION.CentimetersToPoints(0)
			IF EMPTY(m.uParam)
				IF !EMPTY(_Screen.Demo)
					.LeftFooter=_Screen.Caption+" ("+_Screen.Demo+")"
				ENDIF
				.TopMargin   =_Screen.oXS.APPLICATION.CentimetersToPoints(.2)
				.BottomMargin=_Screen.oXS.APPLICATION.CentimetersToPoints(.2)
				.Zoom=76
			ENDIF
		ENDWITH
	ENDIF
	WITH _Screen.oXS.APPLICATION
		.WindowState = -4140
		.ScreenUpdating = .T.
		.Interactive = .T.
		.ActiveWindow.WindowState=2
		IF EMPTY(m.uParam)
			.WindowState = -4137
			IF !EMPTY(_Screen.ExcelFullScreen)
				.CommandBars("Formatting").Visible = .F.
				.CommandBars("Standard").Visible = .F.
				.DisplayFullScreen=.T.
				.CommandBars("Full Screen").Visible = .F.
			ENDIF
		ENDIF
*!*			IF !_Screen.Visible
*!*				_Screen.Visible=.T.
*!*				Declare Long SetParent in Win32API Long , Long
*!*				=SetParent(.hWnd, _Screen.HWnd)
*!*			ENDIF
		.VISIBLE=.T.
	ENDWITH
	WAIT CLEAR
	CLEAR TYPEAHEAD
CASE IIF(m.nParam=2,.T.,m.nParam=3 AND IIF(EMPTY(_Screen.Demo),!EMPTY(_Screen.ExcelProtect),.T.))
*!*		2 - обязательное шунтирование 8-)
	_Screen.oXS.Sheets(1).PROTECT(SYS(2015))
CASE BETWEEN(m.nParam,4,5) &&AND !EMPTY(m.uParam)
	LOCAL ARRAY ap(1)
	IF !EMPTY(APRINTERS(ap))
		WITH _Screen.oXS.Sheets(1).PageSetup
			IF m.nParam=4
				.PrintTitleRows = m.uParam
			ELSE
				.PrintTitleColumns = m.uParam
			ENDIF
		ENDWITH
	ENDIF
CASE m.nParam=6
	WITH _Screen.oXS.Sheets(1).Cells
		.NumberFormat="@"
		.VerticalAlignment = 2
	ENDWITH
	STORE IIF(EMPTY(m.uParam),"1:2",m.uParam) TO m.uParam
	WITH _Screen.oXS.Sheets(1).ROWS(m.uParam)
		.WrapText=1
		.HorizontalAlignment = 3
*!*			.VerticalAlignment = 2
		.FONT.Bold=1
	ENDWITH
CASE m.nParam=7 AND !EMPTY(_Screen.ExcelBorder)
	STORE IIF(EMPTY(m.uParam),"A2:D2",m.uParam) TO m.uParam
	WITH _Screen.oXS.Sheets(1)
		STORE _Screen.ExcelBorder TO .RANGE(m.uParam).Borders(1).LineStyle,;
			.RANGE(m.uParam).Borders(2).LineStyle,;
			.RANGE(m.uParam).Borders(3).LineStyle,;
			.RANGE(m.uParam).Borders(4).LineStyle
	ENDWITH
CASE m.nParam=8 AND IIF(EMPTY(m.uParam), EMPTY(_Screen.NormalMode), .T.)
	WITH _Screen.oXS
		IF IIF(EMPTY(m.uParam), .APPLICATION.MemoryTotal/.APPLICATION.MemoryUsed < 2, .T.)
			MESSAGEBOX(IIF(EMPTY(m.uParam), "Распределение памяти", m.uParam);
				+CHR(13)+"Всего"+STR(.APPLICATION.MemoryTotal/1000);
				+CHR(13)+"Использовано"+STR(.APPLICATION.MemoryUsed/1000), 64, "MS Excel",_Screen.MBTimeout)
		ENDIF
	ENDWITH
CASE m.nParam=9 AND !EMPTY(m.uParam) AND BETWEEN(m.uParam,1,_Screen.Excel97)
	_Screen.oXS.Sheets(1).PrintOut(m.uParam)
CASE m.nParam=10 AND _Screen.lStop
	_Screen.oXS.Sheets(1).Cells(m.uParam,2).FONT.Size = 8
	_Screen.oXS.Sheets(1).Cells(m.uParam,2).VALUE='Прервано пользователем'
ENDCASE
