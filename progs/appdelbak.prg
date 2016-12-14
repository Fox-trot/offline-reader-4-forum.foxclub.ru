LPARAMETERS cFolder, cMask, lRecycle
LOCAL nn, yy, ff
LOCAL ARRAY aa(5)
STORE 0 TO ff
STORE IIF(!EMPTY(m.cFolder) AND DIRECTORY(ALLTRIM(m.cFolder)), ADDBS(ALLTRIM(m.cFolder)), "") TO cFolder
yy=ADIR(aa, m.cFolder+IIF(EMPTY(m.cMask), "*.bak", IIF(EMPTY(AT(".", m.cMask)), "*."+ALLTRIM(m.cMask), m.cMask)), "A")
FOR m.nn=1 TO m.yy
	IF AppErase(m.cFolder+aa(m.nn, 1), m.lRecycle)
		STORE m.ff+1 TO ff
	ENDIF
ENDFOR
RETURN m.ff
