LPARAMETERS nParam1, nParam2, cParam	&& , tParam
*!*	сохранение факта импорта XML и самого текста
SELECT link
DO CASE
CASE EMPTY(m.nParam1)
CASE !SEEK(m.nParam1, "link", "ilink")
	nParam1=0
CASE !RLOCK()
CASE link.nlink<0
	vfpclubblocklink(m.nParam1)
CASE !EMPTY(m.nParam2) AND !EMPTY(link.nlink)
	REPLACE link.nlink WITH 0
OTHERWISE
	vfpclubblocklink(link.ilink)
ENDCASE
IF !EMPTY(m.nParam1) AND FLOCK("link2")	&& AND !EMPTY(_Screen.SaveXML)
	SELECT link2
	=AppCreateRecord(.T.)
	REPLACE ilink2 WITH (DAY(DATE())+MONTH(DATE())*32)*1000000+VAL(RIGHT(SYS(3),6)),;
		ilink WITH m.nParam1,;
		tlink2 WITH DATETIME(),;
		nlink2 WITH IIF(EMPTY(m.nParam2), 0, m.nParam2)
*!*		REPLACE tlink2 WITH IIF(!EMPTY(m.nParam2) AND !EMPTY(m.tParam), m.tParam, MAX(m.tParam, DATETIME()))
	IF _Screen.SaveXML<0 AND !EMPTY(m.cParam)
		REPLACE mlink2 WITH m.cParam
	ENDIF
ENDIF
UNLOCK ALL
