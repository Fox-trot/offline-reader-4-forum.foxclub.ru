LPARAMETERS nParam, uParam, iParam
#DEFINE att "[attachment"
DO CASE
CASE m.nParam=3 AND EMPTY(post.lZip)
	SELECT post
	IF RLOCK()
		REPLACE lZip WITH .T.
	ENDIF
	UNLOCK
CASE EMPTY(m.uParam)
CASE m.nParam=2 AND IIF(EMPTY(_Screen.AttachmentLink), .T., EMPTY(m.iParam))
	RETURN .F.
CASE m.nParam=2
	LOCAL xx, yy
	nParam=.F.
	FOR xx=1 TO OCCURS(att, m.uParam)
		yy=ALLTRIM(GETWORDNUM(SUBSTR(SUBSTR(m.uParam, AT(att, m.uParam, m.xx)), 13), 1, "]"))
		IF !EMPTY(m.yy)
			nParam=MAX(m.nParam, IIF(FILE(ADDBS(SYS(2023))+m.yy), .T., vfphttp(STRTRAN(_Screen.AttachmentLink, "##", TRANSFORM(m.iParam), 1, 1)+GETWORDNUM(m.yy, 1), ADDBS(SYS(2023))+m.yy)))
		ENDIF
	ENDFOR
	RETURN m.nParam
CASE m.nParam=4 AND !INDEXSEEK(ABS(m.uParam), .F., "favorite", "ifavorite")
	SELECT favorite
	IF FLOCK()
		=AppCreateRecord(.T.)
		REPLACE ifavorite WITH ABS(m.uParam)
		UNLOCK
		=vfpclubpublic(1, 5)
	ENDIF
CASE m.nParam=5 AND !INDEXSEEK(ABS(m.uParam), .F., "favorite", "ifavorite")
	DO WHILE SEEK(ABS(m.uParam), "post", "abs")
		IF EMPTY(post.ipost2)
			uParam=post.ipost
			EXIT
		ELSE
			uParam=post.ipost2
		ENDIF
	ENDDO
	=vfpclubmenu4post(4, m.uParam)
ENDCASE
