LPARAMETERS nParam
LOCAL ff, cc, nn, xx, cAlias, mmm, zz, zero, nLimit, maxzero
STORE 0 TO nn, xx, zz, nLimit
IF m.nParam>0 AND FLOCK("user")
	DO vfpclubdbf WITH 2
	#DEFINE CHRF CHR(13)
	#DEFINE myspace SPACE(4)
	#DEFINE nleft 78
	maxzero=MAX(CEILING(m.nParam/3), DOW(DATE()))
	STORE RECCOUNT("user")/maxzero TO zero
	SELECT ABS(user.nuser)+1 AS nuser2;
		FROM club!user;
		WHERE ABS(user.nuser)>m.zero AND ABS(user.nuser)+1 NOT IN (SELECT ABS(user.nuser) AS nuser FROM club!user);
		GROUP BY 1;
		INTO CURSOR newuser ORDER BY 1
	nParam = IIF(EMPTY(_Screen.NormalMode), MAX(m.nParam, RECCOUNT()), m.nParam)
	zero = 0
	_Screen.livewallpaper.StopStart("Import user profiles")
	DO WHILE m.zero<maxzero AND m.nLimit<=m.nParam AND EMPTY(_SCREEN.lStop)
		AppProgressBar(m.nLimit, m.nParam, "Import profiles")
		STORE MAX(newuser.nuser2, m.nn+1) TO nn
		nLimit = m.nLimit+1
		ff = _Screen.ImportPath+TRANSFORM(m.nn)+".htm"
		STORE [] TO cc, mmm, c6
		SELECT user
		LOCATE FOR ABS(nuser)=m.nn
*		IF IIF(FOUND(), nuser>0 AND EMPTY(duser) AND EMPTY(muser), .T.)
		IF IIF(FOUND(), EMPTY(duser), .T.)
			IF IIF(FILE(m.ff), .T., vfphttp(_Screen.ProfileLink+TRANSFORM(m.nn), m.ff))
				cAlias = [u]+RIGHT(SYS(3),5)
				SELECT 0
				CREATE CURSOR (m.cAlias) (mm C (254))
				APPEND FROM (m.ff) FOR [<]$mm AND LEN(ALLTRIM(mm))>9 TYPE DELIMITED WITH TAB
				LOCATE ALL FOR "Профиль Пользователя" $ mm
				IF FOUND()
					cc = SUBSTR(mm, nleft)
					cc = LEFT(m.cc, AT("<", m.cc)-1)
					cc = STRTRAN(m.cc, " (Приятель)", "")
					IF EMPTY(m.cc)
						zero = m.zero+1
					ELSE
						zz = vfpclubID(m.cc)
						SELECT user
						LOCATE ALL FOR ABS(iuser)=m.zz
						DO CASE
						CASE NOT FOUND()
							AppCreateRecord()
							REPLACE iuser WITH m.zz,;
								cuser WITH m.cc,;
								nuser WITH m.nn,;
								luser WITH .F.
							xx=m.xx+1
						CASE EMPTY(nuser)
							REPLACE nuser WITH m.nn
							xx=m.xx+1
						ENDCASE
						mmm = vfpclubprofile(user.iuser, , m.ff)
						SELECT user
						IF !EMPTY(m.mmm)
							d7 = DATE(VAL(GETWORDNUM(GETWORDNUM(m.mmm, 7, CHRF), 3, ".")), VAL(GETWORDNUM(GETWORDNUM(m.mmm, 7, CHRF), 2, ".")), VAL(GETWORDNUM(GETWORDNUM(m.mmm, 7, CHRF), 1, ".")))
							IF !EMPTY(GETWORDNUM(m.mmm, 7, CHRF)) AND duser # d7
								REPLACE duser WITH d7
							ENDIF
							IF EMPTY(muser)
								FOR x6=1 TO 6
									c6 = m.c6+ALLTRIM(GETWORDNUM(m.mmm, m.x6, CHRF))
								ENDFOR
								IF !EMPTY(m.c6)
									c6=[]
									FOR x6=1 TO 6
										c6 = m.c6+ALLTRIM(GETWORDNUM(m.mmm, m.x6, CHRF))+IIF(m.x6=6, "", CHRF)
									ENDFOR
									REPLACE muser WITH m.c6
								ENDIF
							ENDIF
						ENDIF
						IF EMPTY(m.c6) AND !INDEXSEEK(ABS(iuser), .F., "post", "iuser")
							REPLACE nuser WITH -m.nn
						ENDIF
					ENDIF
				ELSE
					SELECT user
					LOCATE FOR ABS(nuser)=m.nn
					IF !FOUND()
						AppCreateRecord()
						REPLACE iuser WITH -m.nn,;
							nuser WITH -m.nn
						zero = m.zero+1
						AppErase(m.ff)
					ENDIF
				ENDIF
				ON ERROR *
				USE IN (m.cAlias)
				DO proc_error
			ELSE
				zero = m.zero+1
			ENDIF
		ENDIF
		DO CASE
		CASE MOD(m.nLimit, IIF(m.zero=0, DOW(DATE()), m.zero)) = 0
			SELECT newuser
			SELECT ABS(user.nuser)+1 AS nuser2;
				FROM club!user;
				WHERE ABS(user.nuser)+1 NOT IN (SELECT ABS(user.nuser) AS nuser FROM club!user);
				GROUP BY 1;
				INTO CURSOR newuser ORDER BY 1
			nn = 1
		CASE !EOF("newuser")
			SKIP IN newuser
		ENDCASE
	ENDDO
	_Screen.livewallpaper.StopStart()
*!*		IF EMPTY(m.xx) AND m.zero>=maxzero
*!*			_Screen.DownLoadProfiles=0
*!*		ENDIF
	IF m.zero>0
		SELECT MAX(ABS(user.nuser)) AS nuser;
			FROM club!user;
			WHERE EMPTY(user.duser)=.F.;
			UNION;
			SELECT MAX(ABS(user.nuser));
			FROM club!post;
			INNER JOIN club!user ON post.iuser=ABS(user.iuser);
			INNER JOIN club!link ON post.icategory=link.icategory;
			WHERE post.iuser>0 AND link.ilink>0;
			INTO CURSOR newuser ORDER BY 1 DESC
		SELECT user
		CALCULATE FOR iuser=nuser AND EMPTY(cuser) AND iuser<0;
			MIN(iuser) TO nn
		DO WHILE m.zero>0 AND ABS(m.nn)>newuser.nuser
			LOCATE FOR iuser=m.nn AND iuser=nuser AND EMPTY(cuser)
			IF FOUND()
				AppErase(_Screen.ImportPath+TRANSFORM(ABS(m.nn))+".htm")
				appdelrec("user")
			ELSE
				zero=m.zero-1
			ENDIF
			nn=m.nn+1
		ENDDO
		USE IN newuser
	ENDIF
ENDIF
UNLOCK IN user
RETURN m.xx
