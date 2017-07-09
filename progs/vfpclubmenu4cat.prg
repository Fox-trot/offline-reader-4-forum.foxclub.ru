LPARAMETERS nParam, uParam
DO CASE
CASE EMPTY(m.uParam)
CASE BETWEEN(m.nParam,1,2)
*!*		IF m.nParam=1 AND _Screen.InternetInUse=1 AND !EMPTY(_Screen.MarkReadLink)
*!*			=vfphttp(STRTRAN(_Screen.MarkReadLink, "##", TRANSFORM(link.ilink), 1, 1), .Null.)
*!*		ENDIF
	SELECT post
	LOCATE FOR icategory=m.uParam AND lzip=(m.nParam=2) AND lpost=.F.
	IF FOUND() AND FLOCK()
		REPLACE lpost WITH .T.;
			REST FOR icategory=m.uParam AND lzip=(m.nParam=2) AND lpost=.F.
		UNLOCK
*!*			=vfpclubpublic(IIF(EMPTY(_Screen.AutoRefresh),1,-1), IIF(m.nParam=1,1,4))
	ELSE
		RETURN .F.
	ENDIF
CASE m.nParam=3
	SELECT post
	LOCATE FOR icategory=m.uParam AND lpost=.F.
	IF FOUND() AND FLOCK()
		REPLACE lpost WITH .T.;
			REST FOR icategory=m.uParam AND lpost=.F.
		UNLOCK
*!*			=vfpclubpublic(IIF(EMPTY(_Screen.AutoRefresh),1,-1), 6)
	ELSE
		RETURN .F.
	ENDIF
CASE m.nParam=4
	=INIWrite(_Screen.ini, "Main", IIF(link.ilink<0, "DefaultRSS","DefaultCategory"), TRANSFORM(m.uParam))
	IF link.ilink<0
		_Screen.DefaultRSS=m.uParam
	ELSE
		_Screen.DefaultCategory=m.uParam
	ENDIF
ENDCASE
