#DEFINE hh 444
#DEFINE ww 644
WAIT CLEAR
WITH _Screen
	STORE .T. TO .Visible, .ShowTips
	STORE 2 TO .WindowState
	IF WEXIST("Color Palette")
		HIDE WINDOW "Color Palette"
	ENDIF
	IF WEXIST("Database Designer")
		HIDE WINDOW "Database Designer"
	ENDIF
	IF WEXIST("Debugger")
		HIDE WINDOW "Debugger"
	ENDIF
	IF WEXIST("Form Controls")
		HIDE WINDOW "Form Controls"
	ENDIF
	IF WEXIST("Form Designer")
		HIDE WINDOW "Form Designer"
	ENDIF
	IF WEXIST("Layout")
		HIDE WINDOW "Layout"
	ENDIF
	IF WEXIST("Print Preview")
		HIDE WINDOW "Print Preview"
	ENDIF
	IF WEXIST("Query Designer")
		HIDE WINDOW "Query Designer"
	ENDIF
	IF WEXIST("Report Controls")
		HIDE WINDOW "Report Controls"
	ENDIF
	IF WEXIST("Report Designer")
		HIDE WINDOW "Report Designer"
	ENDIF
	IF WEXIST("Standard")
		HIDE WINDOW "Standard"
	ENDIF
	IF WEXIST("View Designer")
		HIDE WINDOW "View Designer"
	ENDIF
*!*		STORE MIN(hh, .MinHeight) TO .MinHeight
*!*		STORE MIN(ww, .MinWidth) TO .MinWidth
	STORE hh TO .MinHeight
	STORE ww TO .MinWidth
	IF .Height>hh
		SET STATUS BAR ON
	ENDIF
ENDWITH
DO appwallpaper
