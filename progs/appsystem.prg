LPARAMETER lParam
DO proc_error
WITH _SCREEN
	IF EMPTY(lParam)
		DO LatRus WITH .LatRus
		IF !EMPTY(.CapsLock)
			CapsLock(.T.)
		ENDIF
		IF !EMPTY(.NumLock)
			NumLock(.T.)
		ENDIF
		IF !EMPTY(.InsMode)
			InsMode(.T.)
		ENDIF
		IF EMPTY(.KeyDos)
			SET KEYCOMP TO WINDOWS
		ELSE
			SET KEYCOMP TO DOS
		ENDIF
		IF !EMPTY(.ConfON)
			SET CONFIRM OFF
		ENDIF
	ELSE
		ON KEY LABEL ALT+q DO AppQuit
		SET DECIMALS TO 4
		SET OLEOBJECT ON
		LOCAL cc
		LOCAL ARRAY aa[1]

		.AddProperty("WinDir",ADDBS(GETENV("WINDIR")))
		.AddProperty("Demo","")

		.ADDPROPERTY("NormalMode",1)
		.ADDPROPERTY("TurboMode",0)
		.ADDPROPERTY("RefreshRate",7)
		.ADDPROPERTY("SummaryInGroup",5)
		.ADDPROPERTY("ScreenSaver",7)
		.ADDPROPERTY("EditMenu",1)
		.ADDPROPERTY("ImageMenu",1)

		.ADDPROPERTY("NeedAccess",0)
		.ADDPROPERTY("AccessLevel",0)
		.ADDPROPERTY("EnterUserName",0)
		.ADDPROPERTY("LatRus",1)
		.ADDPROPERTY("RusLettersOnly",1)

		.ADDPROPERTY("CapsLock",0)
		.ADDPROPERTY("NumLock",1)
		.ADDPROPERTY("InsMode",1)
		.ADDPROPERTY("KeyDos",1)
		.ADDPROPERTY("ConfON",1)

		.ADDPROPERTY("DynamicGrid", 1)
		.ADDPROPERTY("DynamicGridColor", 12639424)
		.ADDPROPERTY("HighlightStyle", 0)
		.ADDPROPERTY("HighlightBackColor", 12639424)
		.ADDPROPERTY("SearchInGrid", 1)

		.ADDPROPERTY("NoConfirmOnExit",1)
		.ADDPROPERTY("DisplayCount",4)
		.ADDPROPERTY("UserID",0)
		.ADDPROPERTY("UserName","")
		.ADDPROPERTY("Logo",1)
		.ADDPROPERTY("GRAPHICS", ADDBS(IIF(SET("RESOURCE") = "ON", ADDBS(SYS(5)+SYS(2003))+"GRAPHICS", SYS(2023))))
		IF !DIRECTORY(.GRAPHICS)
			MKDIR (.GRAPHICS)
		ENDIF
		STORE INIRead(.ini,"Main","FontName") TO cc
		.FontName=IIF(!EMPTY(cc) AND AFONT(aa,cc), cc, IIF(AFONT(aa,"Arial Cyr"), "Arial Cyr", IIF(AFONT(aa,"Arial"), "Arial", .FontName)))

		.ADDPROPERTY("oReport")
		.ADDPROPERTY("oX",0)
		.ADDPROPERTY("oXS",0)
		.ADDPROPERTY("Excel97",0)
		.ADDPROPERTY("ExcelBorder",1)
		.ADDPROPERTY("ExcelFullScreen",1)
		.ADDPROPERTY("ExcelProtect",1)
		.ADDPROPERTY("ExcelMemoryUse",80)
		.ADDPROPERTY("ExcelInterior",4)

		.ADDPROPERTY("ChartLegend",7)
		.ADDPROPERTY("ChartLabelLength",40)
		.ADDPROPERTY("ChartMaxCol",12)
		.ADDPROPERTY("ChartMaxRow",40)
		STORE INIRead(.ini,"Main","ChartFontName") TO cc
		.ADDPROPERTY("ChartFontName",IIF(!EMPTY(cc) AND AFONT(aa,cc), cc, IIF(AFONT(aa,"Arial Cyr"), "Arial Cyr", IIF(AFONT(aa,"MS Sans Serif"), "MS Sans Serif", .FontName))))
		.ADDPROPERTY("nStep", -1)
		
		.ADDPROPERTY("Windows98", "Windows 4." $ OS())
		STORE INIRead(.ini, "Main", "SearchPath") TO cc
		IF !EMPTY(cc)
			SET PATH TO (cc)
		ENDIF
		=RAND(-1)
		.ADDPROPERTY("lStop", .T.)
		.ADDPROPERTY("MBTimeout", 60000)
		.ADDPROPERTY("WaitTimeout", 7)
	ENDIF
	.Cls
	DO ShortCutForEdit
ENDWITH
