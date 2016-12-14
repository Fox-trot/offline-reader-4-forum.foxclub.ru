LPARAMETERS nParam, uParam
DO CASE
CASE EMPTY(m.uParam)
CASE m.nParam=1
	=AppOpenUrl(_Screen.ProfileLink+TRANSFORM(m.uParam))
CASE m.nParam=3 AND SEEK(ABS(m.uParam), "user", "iuser") AND RLOCK("user")	&&BlackList
	SELECT user
	IF iuser>0
		REPLACE iuser WITH -iuser
	ENDIF
	UNLOCK
CASE m.nParam=4 AND SEEK(ABS(m.uParam), "user", "iuser") AND user.luser
CASE m.nParam=4 AND RLOCK("user")
	SELECT user
	REPLACE luser WITH .T.
	UNLOCK
	=vfpclubpublic(4, 2)
CASE INLIST(m.nParam,3,4)
	UNLOCK
	RETURN .F.
CASE m.nParam=5
	LOCAL ok
	DO FORM vfpclubuser01e TO ok WITH m.uParam
	RETURN m.ok
ENDCASE
