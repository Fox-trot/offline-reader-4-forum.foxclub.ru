LPARAMETERS cParam
*!*	RETURN IIF(EMPTY(m.cParam), 000000000000, VAL(SYS(2007, ALLTRIM(m.cParam), 2, 2)))
RETURN IIF(EMPTY(m.cParam), 00000000000000000000, INT(VAL(SYS(2007, ALLTRIM(m.cParam), 1, 1))))
