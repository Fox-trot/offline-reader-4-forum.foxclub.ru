LOCAL lError
LOCAL ARRAY aa[1]
DO vfpclubdbc
DO vfpclubini
WITH _Screen
	.UserName=GETWORDNUM(ID(),3)
	.UserID=VAL(SYS(2007, .UserName))
	DO vfpclubini WITH ,TRANSFORM(.UserID)
	DO AppSystem
	lError = (ADIR(aa, .Comment+[*.err]) > 0)
	IF !EMPTY(.DownLoadWhenStart) AND !lError
		=vfpclubDownloadRSS()
	ENDIF
	DO vfpclubMenu

	IF NOT DTOS(DATE()) == INIRead(.ini, "Main", "LastStart")
		=INIWrite(.ini, "Main", "LastStart", DTOS(DATE()))
		DO CASE
		CASE lError
			SELECT 0 AS nCount FROM club!category WHERE .F. INTO CURSOR c1
		CASE .RemindBirthDays=1
			SELECT CNT(DIST NVL(user2.iuser, user.iuser)) AS nCount;
				FROM club!user;
				LEFT JOIN club!user AS user2 ON user.iuser2 = ABS(user2.iuser);
				WHERE user.iuser>0 AND user.duser>{};
				AND LEN(MLINE(user.muser, 6)) = 4;
				AND MLINE(user.muser, 6) = RIGHT(DTOS(DATE()), 4);
				INTO CURSOR c1
		CASE .RemindBirthDays=2
			SELECT CNT(DIST NVL(user2.iuser, user.iuser)) AS nCount;
				FROM club!user;
				LEFT JOIN club!user AS user2 ON user.iuser2 = ABS(user2.iuser);
				WHERE user.iuser>0 AND user.duser>{};
				AND LEN(MLINE(user.muser, 6)) = 4;
				AND MLINE(user.muser, 6) = RIGHT(DTOS(DATE()), 4);
				HAVING MAX(user.luser)=.T.;
				INTO CURSOR c1
		OTHERWISE
			SELECT 0 AS nCount FROM club!category WHERE .F. INTO CURSOR c1
		ENDCASE
		IF nCount>0
			MESSAGEBOX("На сегодня именинников:"+STR(nCount), 64, .Caption, .MBTimeout)
		ENDIF
		USE
	ENDIF
	.tmrDownload.Reset
ENDWITH
