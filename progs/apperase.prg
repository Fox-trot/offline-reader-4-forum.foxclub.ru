LPARAMETERS cParam, lParam
*!*	cParam - имя удаляемого файла
*!*	lParam =.T. - класть в корзину Windows(R)
ON ERROR cParam=[]
IF EMPTY(m.lParam)
	ERASE (m.cParam)
ELSE
	ERASE (m.cParam) RECYCLE
ENDIF
DO proc_error
RETURN !FILE(m.cParam)
