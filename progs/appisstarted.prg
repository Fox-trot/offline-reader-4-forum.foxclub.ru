LPARAMETERS cParam
LOCAL hWnd
DECLARE INTEGER FindWindow IN Win32API Integer nClassName, String cWindowName
hWnd = FindWindow(0, IIF(EMPTY(m.cParam),_Screen.Caption,m.cParam))
IF m.hWnd > 0
	DECLARE INTEGER ShowWindow IN Win32API AS ShowVfpWindow Integer hWnd, Integer nCmdShow
	DECLARE INTEGER SetFocus IN Win32API AS SetVfpFocus Integer hWnd
	=ShowVfpWindow(m.hWnd, 9)
	=SetVfpFocus(m.hWnd)
ENDIF
CLEAR DLLS
RETURN m.hWnd
