*vfpclubsaymecountry
LPARAMETERS cTown
LOCAL cCountry
cCountry = ""
IF !EMPTY(m.cTown)
	SELECT DIST PADR(MLINE(user.muser, 5), 60) AS cName;
		FROM club!user;
		WHERE MLINE(user.muser, 4)==m.cTown AND MLINE(user.muser, 5)>"9";
		INTO CURSOR u450
	IF RECCOUNT("u450")=1
		cCountry = u450.cName
		USE IN u450
	ENDIF
ENDIF
RETURN m.cCountry
