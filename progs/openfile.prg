LPARAMETER cParam
LOCAL ll
IF EMPTY(m.cParam)
	STORE -1 TO ll
ELSE
	IF FILE(m.cParam)
		ll=FOPEN(m.cParam, 2)
		IF m.ll>=0
			=FCLOSE(m.ll)
			=AppErase(m.cParam, .T.)
		ENDIF
	ELSE
		ll=FCREATE(m.cParam)
		IF m.ll>=0
			=FCLOSE(m.ll)
		ENDIF
	ENDIF
ENDIF
RETURN m.ll>-1
