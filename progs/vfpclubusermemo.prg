LPARAMETERS iParam, nParam, lParam, cParam
#DEFINE CHRF CHR(13)
IF EMPTY(iParam)
	RETURN ''
ENDIF
LOCAL cc, mm, xx
cc=ALIAS()
STORE [] TO mm
IF !USED("user")
	USE club!user IN 0
ENDIF
IF IIF(ABS(m.iParam)=ABS(user.iuser), .T., SEEK(ABS(m.iParam), "user", "abs"))
*!*		SELECT user
	DO CASE
	CASE EMPTY(lParam) AND EMPTY(nParam)
		FOR xx=1 TO 6
			mm = mm+ALLTRIM(MLINE(user.muser, xx))+IIF(xx=6, [], CHRF)
		ENDFOR
	CASE EMPTY(lParam)
		mm = MLINE(user.muser, nParam)+IIF(nParam=6, [], CHRF)
	CASE !EMPTY(nParam)
		FOR xx=1 TO 6
			mm = mm+IIF(nParam=xx, IIF(EMPTY(cParam), [], ALLTRIM(cParam)), MLINE(user.muser, xx))+IIF(xx=6, [], CHRF)
		ENDFOR
*!*		OTHERWISE
	ENDCASE
ENDIF
IF !EMPTY(cc)
	SELECT (cc)
ENDIF
RETURN mm
