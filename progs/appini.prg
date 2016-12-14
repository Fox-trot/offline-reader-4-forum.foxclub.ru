LPARAMETERS lParam, cParam
LOCAL cc,uu
uu=IIF(EMPTY(cParam),"Main",ALLTRIM(m.cParam))
WITH _Screen
	IF EMPTY(m.lParam)		&& чтение
		IF FILE(.ini)
			STORE "Main" TO uu
			STORE INIRead(.ini, m.uu, "EnterUserName") TO cc
			STORE IIF(EMPTY(VAL(cc)), 0, 1) TO .EnterUserName

			STORE INIRead(.ini, m.uu, "_Screen.Excel97") TO cc
			STORE IIF(ISDIGIT(cc), INT(VAL(cc)), 0) TO _Screen.Excel97
			STORE INIRead(.ini, m.uu, "ExcelBorderLineStyle") TO cc
			STORE IIF(ISDIGIT(cc) AND BETWEEN(VAL(cc), 0, 13), INT(VAL(cc)), 1) TO _Screen.ExcelBorder
			STORE INIRead(.ini, m.uu, "ExcelFullScreen") TO cc
			STORE AppINIDefault(cc) TO _Screen.ExcelFullScreen
			STORE INIRead(.ini, m.uu, "ExcelInterior") TO cc
			STORE IIF(ISDIGIT(cc) AND BETWEEN(VAL(cc), 1, 18), INT(VAL(cc)), 4) TO _Screen.ExcelInterior
			IF EMPTY(.Demo)
				STORE INIRead(.ini,m.uu ,"ExcelProtect") TO cc
				STORE AppINIDefault(cc) TO _Screen.ExcelProtect
				STORE INIRead(.ini,m.uu ,"Logo") TO cc
				STORE AppINIDefault(cc) TO .Logo
				STORE INIRead(.ini,m.uu ,"ScreenSaver") TO cc
				STORE IIF(ISDIGIT(cc) AND BETWEEN(VAL(cc), 0, 99), INT(VAL(cc)), .ScreenSaver) TO .ScreenSaver
			ENDIF
			STORE INIRead(.ini,m.uu ,"ExcelMemoryUse") TO cc
			STORE IIF(ISDIGIT(cc) AND BETWEEN(VAL(cc),20,90),INT(VAL(cc)),40) TO _Screen.ExcelMemoryUse

			STORE INIRead(.ini, m.uu, "NormalMode") TO cc
			STORE AppINIDefault(cc) TO .NormalMode
			STORE INIRead(.ini,m.uu ,"TurboMode") TO cc
			STORE IIF(VAL(cc)=1, 1, 0) TO .TurboMode
			STORE INIRead(.ini,m.uu ,"RusLettersOnly") TO cc
			STORE AppINIDefault(cc) TO .RusLettersOnly
		ELSE
			=AppINI(.T.)
		ENDIF
		IF !EMPTY(m.cParam) AND !EMPTY(INIRead(.ini,ALLTRIM(m.cParam),"UserName"))
			STORE ALLTRIM(m.cParam) TO uu
			STORE INIRead(.ini,m.uu ,"Themes") TO cc
			STORE NOT (!EMPTY(m.cc) AND VAL(m.cc)=0) TO .Themes

			STORE INIRead(.ini,m.uu ,"CapsLock") TO cc
			STORE IIF(EMPTY(VAL(m.cc)),0,1) TO .CapsLock
			STORE INIRead(.ini,m.uu ,"ConfON") TO cc
			STORE AppINIDefault(cc) TO .ConfON
			STORE INIRead(.ini,m.uu ,"DisplayCount") TO cc
			STORE IIF(BETWEEN(VAL(cc),2,99),INT(VAL(cc)),4) TO .DisplayCount
*!*			4 Grids
			STORE INIRead(.ini,m.uu ,"DynamicGrid") TO cc
			STORE AppINIDefault(m.cc) TO .DynamicGrid
			STORE INIRead(.ini,m.uu ,"DynamicGridColor") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),1,16777215),INT(VAL(m.cc)),.DynamicGridColor) TO .DynamicGridColor
			STORE INIRead(.ini,m.uu ,"HighlightStyle") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),0,2), INT(VAL(m.cc)), .HighlightStyle) TO .HighlightStyle
			STORE INIRead(.ini,m.uu ,"HighlightBackColor") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),1,16777215),INT(VAL(m.cc)),.HighlightBackColor) TO .HighlightBackColor
			STORE INIRead(.ini,m.uu ,"SearchInGrid") TO cc
			STORE AppINIDefault(m.cc) TO .SearchInGrid

			STORE INIRead(.ini,m.uu ,"InsMode") TO cc
			STORE AppINIDefault(m.cc) TO .InsMode
			STORE INIRead(.ini,m.uu ,"KeyDos") TO cc
			STORE AppINIDefault(m.cc) TO .KeyDos
			STORE INIRead(.ini,m.uu ,"LatRus") TO cc
			STORE AppINIDefault(m.cc) TO .LatRus
			STORE INIRead(.ini,m.uu ,"NoConfirmOnExit") TO cc
			STORE AppINIDefault(m.cc) TO .NoConfirmOnExit

			STORE INIRead(.ini,m.uu ,"EditMenu") TO cc
			STORE AppINIDefault(m.cc) TO .EditMenu
			STORE INIRead(.ini,m.uu ,"ImageMenu") TO cc
			STORE AppINIDefault(m.cc) TO .ImageMenu
		ENDIF
		STORE INIRead(.ini, m.uu, "ChartLegend") TO cc
		STORE IIF(ISDIGIT(m.cc) AND BETWEEN(VAL(cc), 0, 8),INT(VAL(m.cc)),.ChartLegend) TO .ChartLegend
		STORE INIRead(.ini, m.uu, "ChartLabelLength") TO cc
		STORE IIF(BETWEEN(VAL(m.cc), 10, 60),INT(VAL(m.cc)),.ChartLabelLength) TO .ChartLabelLength
		STORE INIRead(.ini, m.uu, "ChartMaxCol") TO cc
		STORE IIF(BETWEEN(VAL(m.cc), 7, 14),INT(VAL(m.cc)),.ChartMaxCol) TO .ChartMaxCol
		STORE INIRead(.ini, m.uu, "ChartMaxRow") TO cc
		STORE IIF(BETWEEN(VAL(m.cc), 7, 99),INT(VAL(m.cc)),.ChartMaxRow) TO .ChartMaxRow

		STORE INIRead(.ini,m.uu,"MessageBoxTimeout") TO cc
		STORE IIF(ISDIGIT(m.cc) AND BETWEEN(VAL(m.cc), 0, 10), INT(VAL(m.cc))*60000, .MBTimeout) TO .MBTimeout
		STORE INIRead(.ini,m.uu,"WaitTimeout") TO cc
		STORE IIF(BETWEEN(VAL(m.cc), 1, 10), VAL(m.cc), .WaitTimeout) TO .WaitTimeout

		STORE INIRead(.ini,m.uu ,"RefreshRate") TO cc
		STORE IIF(BETWEEN(VAL(cc),7,360), INT(VAL(cc)), .RefreshRate)*60000 TO .RefreshRate

		STORE INIRead(.ini,m.uu ,"SummaryInGroup") TO cc
		STORE IIF(BETWEEN(VAL(cc), 2, 99), INT(VAL(cc)), .SummaryInGroup) TO .SummaryInGroup
	ELSE
		DO CASE
		CASE EMPTY(m.cParam) AND !EMPTY(.NeedAccess)
			=INIWrite(.ini, m.uu , "EnterUserName",STR(.EnterUserName))
		CASE !EMPTY(m.cParam) AND !EMPTY(.UserName)
			=INIWrite(.ini, m.uu , "CapsLock", STR(.CapsLock))
			=INIWrite(.ini, m.uu , "ConfON", STR(.ConfON))
			=INIWrite(.ini, m.uu , "DisplayCount", STR(.DisplayCount))
			=INIWrite(.ini, m.uu , "DynamicGrid", STR(.DynamicGrid))
			=INIWrite(.ini, m.uu , "DynamicGridColor", STR(.DynamicGridColor))
			=INIWrite(.ini, m.uu , "InsMode", STR(.InsMode))
			=INIWrite(.ini, m.uu , "KeyDos", STR(.KeyDos))
			=INIWrite(.ini, m.uu , "LatRus", STR(.LatRus))
			=INIWrite(.ini, m.uu , "NoConfirmOnExit", STR(.NoConfirmOnExit))
			IF .Visible
				=INIWrite(.ini, m.uu , "EditMenu", STR(.EditMenu))
				=INIWrite(.ini, m.uu , "ImageMenu", STR(.ImageMenu))
			ENDIF
			=INIWrite(.ini, m.uu , "UserName", .UserName)
		ENDCASE
	ENDIF
ENDWITH
