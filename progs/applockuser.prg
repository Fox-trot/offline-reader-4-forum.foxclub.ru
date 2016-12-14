LPARAMETERS nParam, lParam
IF EMPTY(_Screen.NeedAccess)
	RETURN .T.
ENDIF
IF EMPTY(nParam)	
	UNLOCK ALL
ENDIF
IF USED("user")
	IF IIF(EMPTY(nParam),!EMPTY(_Screen.UserID) AND SEEK(_Screen.UserID,"user","iUser"),SEEK(nParam,"user","iUser")) AND LOCK("user")
		RETURN .T.
	ENDIF
	IF EMPTY(lParam)
		STORE 0 TO _Screen.UserID, _Screen.AccessLevel
	ENDIF
	UNLOCK IN User
ENDIF
RETURN .F.
