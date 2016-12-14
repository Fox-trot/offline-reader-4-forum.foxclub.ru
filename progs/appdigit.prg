LPARAMETERS cParam, nParam
IF EMPTY(m.cParam)
	RETURN []
ELSE	
	LOCAL cc, yy
	STORE [] TO cc
	FOR yy=1 TO LEN(RTRIM(m.cParam))
		STORE m.cc+IIF(ISDIGIT(SUBSTR(m.cParam, m.yy, 1)), SUBSTR(m.cParam, m.yy, 1), []) TO cc
		IF IIF(EMPTY(m.nParam), .F., LEN(m.cParam)=m.nParam)
			EXIT
		ENDIF
	ENDFOR
ENDIF
RETURN m.cc