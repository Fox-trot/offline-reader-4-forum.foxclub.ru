LOCAL nCount
LOCAL ARRAY aa[1]
DO vfpclubdbc
DO vfpclubini
WITH _Screen
	.UserName=GETWORDNUM(ID(),3)
	.UserID=VAL(SYS(2007, .UserName))
	DO vfpclubini WITH ,TRANSFORM(.UserID)
	DO AppSystem
	IF !EMPTY(.DownLoadWhenStart)
		vfpclubDownloadRSS()
	ENDIF
	DO vfpclubMenu

	IF NOT DTOS(DATE()) == INIRead(.ini, "Main", "LastStart")
		=INIWrite(.ini, "Main", "LastStart", DTOS(DATE()))
		DO CASE
		CASE !EMPTY(ADIR(aa, .Comment+[*.err]))
			SELECT 0 AS nCount FROM club!category WHERE .F. INTO CURSOR c1
		CASE .RemindBirthDays=1
			SELECT CNT(user.iuser) AS nCount;
				FROM club!user;
				WHERE user.iuser>0 AND user.duser>{};
				AND LEN(MLINE(user.muser, 6)) = 4;
				AND MLINE(user.muser, 6) = RIGHT(DTOS(DATE()), 4);
				INTO CURSOR c1
		CASE .RemindBirthDays=2
			SELECT CNT(user.iuser) AS nCount;
				FROM club!user;
				WHERE user.iuser>0 AND user.duser>{};
				AND user.luser=.T.;
				AND LEN(MLINE(user.muser, 6)) = 4;
				AND MLINE(user.muser, 6) = RIGHT(DTOS(DATE()), 4);
				INTO CURSOR c1
		OTHERWISE
			SELECT 0 AS nCount FROM club!category WHERE .F. INTO CURSOR c1
		ENDCASE
		IF nCount>0
			MESSAGEBOX("�� ������� �����������:"+STR(nCount), 64, .Caption, .MBTimeout)
		ENDIF
		USE
	ENDIF
	.tmrDownload.Reset
ENDWITH