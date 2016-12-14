LOCAL ii
WITH _Screen
	FOR ii=1 TO .FormCount
		IF !EMPTY(.Forms(1).WindowType)
			RETURN .F.
		ENDIF
	ENDFOR
	FOR ii=1 TO .FormCount
*!*			IF TYPE("_Screen.Forms(1).ActiveControl")="O" AND LOWER(.Forms(1).ActiveControl.BaseClass) = [grid]
*!*				.Forms(1).ActiveControl.Visible=.F.
*!*				DOEVENTS
*!*			ENDIF
		.Forms(1).Visible=.F.
		.Forms(1).Release
		DOEVENTS FORCE
	ENDFOR
	DOEVENTS FORCE
	RETURN .FormCount>0
ENDWITH
