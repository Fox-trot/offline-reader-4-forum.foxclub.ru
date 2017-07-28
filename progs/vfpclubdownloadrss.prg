LPARAMETERS uParam, nParam
IF EMPTY(m.uParam)
	_Screen.tmrDownload.Reset
ENDIF
DO vfpclubini
DO vfpclubini WITH ,TRANSFORM(_Screen.UserID)
IF MAX(!EMPTY(m.uParam), !EMPTY(m.nParam)) AND _Screen.InternetInUse#1
	DECLARE SHORT InternetGoOnline IN wininet.dll STRING  lpszURL, INTEGER hwndParent, INTEGER dwReserved
	IF EMPTY(InternetGoOnline(_Screen.CSSLink, _VFP.HWnd, 0))
		RETURN 0
	ENDIF
ENDIF
DO vfpclubdbf WITH 2
=AppBlobJob(102)
LOCAL yyy, zzz
LOCAL ARRAY ff[5]
STORE DTOT(DATE()-_Screen.InternetInUse) TO yyy
IF !EMPTY(_Screen.InternetInUse)
*!*	формирование списка ссылок
	DO CASE
	CASE !EMPTY(m.nParam)
*!*		AND INDEXSEEK(m.nParam, .F., "category", "icategory")
		SELECT ABS(link.ilink) AS ilink, NVL(MAX(link2.tlink2), yyy) AS tlink;
			FROM club!link;
			LEFT JOIN club!link2 ON link.ilink = link2.ilink;
			WHERE (link.ilink=m.nParam OR link.icategory=m.nParam) AND EMPTY(link.mlink)=.F. AND (link.llink=.F. OR link.nlink < 0);
			GROUP BY 1;
			INTO CURSOR x1;
			ORDER BY 1 DESC,2
	CASE NOT LEFT(INIRead(_Screen.ini, "Main", "LastUpdate"), 7) == LEFT(DTOS(DATE()), 7)
		yyy = GOMONTH(m.yyy, -6)
		SELECT link.ilink, MAX(post.tpost) AS tlink;
			FROM club!link;
			INNER JOIN club!category ON link.icategory = category.icategory;
			INNER JOIN club!post ON category.icategory = post.icategory;
			WHERE link.ilink>0 AND EMPTY(link.mlink)=.F.;
			GROUP BY 1 HAVING MAX(post.tpost) > yyy;
			INTO CURSOR x1;
			ORDER BY 2
	CASE EMPTY(_Screen.FoxClubRSSonly)
		SELECT ABS(link.ilink) AS ilink, NVL(MAX(link2.tlink2), yyy) AS tlink;
			FROM club!link;
			LEFT JOIN club!link2 ON link.ilink = link2.ilink;
			WHERE EMPTY(link.mlink)=.F. AND (link.llink=.F. OR link.nlink < 0) AND link2.nlink2>0;
			GROUP BY 1;
			INTO CURSOR x1;
			ORDER BY 2,1
	OTHERWISE
		SELECT link.ilink, NVL(MAX(link2.tlink2), yyy) AS tlink;
			FROM club!link;
			LEFT JOIN club!link2 ON link.ilink = link2.ilink;
			WHERE link.ilink>0 AND EMPTY(link.mlink)=.F. AND (link.llink=.F. OR link.nlink < 0) AND link2.nlink2>0;
			GROUP BY 1;
			INTO CURSOR x1;
			ORDER BY 2,1
	ENDCASE
	DO CASE
	CASE EMPTY(RECCOUNT())
		RETURN -1
	CASE EMPTY(m.uParam)
		SET MESSAGE TO "Get data from Internet"
	OTHERWISE
		_Screen.livewallpaper.StopStart("Get data from Internet")
	ENDCASE
*!*	скачиваем информацию из интернета
	SCAN ALL FOR ABS(tlink-DATETIME())>_Screen.MinUpdatePeriod AND SEEK(ilink, "link", "abs")
		AppProgressBar(RECNO(), RECCOUNT(), "Get data from Internet")
		DO CASE
		CASE IIF(EMPTY(m.uParam), .F., _Screen.lStop)
			EXIT
		CASE EMPTY(vfphttp(link.mlink, _Screen.ImportPath+[vfp-]+TRANSFORM(ilink)+[-]+SYS(3)+[.xml]))
			EXIT
		ENDCASE
	ENDSCAN
	USE
	_Screen.livewallpaper.StopStart()
ENDIF
STORE 0 TO yyy
WITH _Screen
	IF ADIR(ff, .ImportPath+[vfp-*.xml])>0
		.livewallpaper.StopStart("Import data from XML")
		FOR zzz=1 TO ALEN(ff,1)
			AppProgressBar(m.zzz, ALEN(ff,1), "Import data from XML")
			IF .lStop
				EXIT
			ELSE
				STORE m.yyy+vfpclubXMLParse(.ImportPath+ff(m.zzz,1)) TO yyy
			ENDIF
		ENDFOR
		.livewallpaper.StopStart()
		.oXMLDoc=.F.
	ENDIF
	IF MONTH(DATE())#VAL(SUBSTR(INIRead(.ini, "Main", "LastUpdate"), 5, 2)) AND .InternetInUse=1
		SELECT DISTINCT user.iuser;
			FROM club!user;
			WHERE EMPTY(user.duser)=.T. AND EMPTY(user.muser)=.T. AND user.iuser>0 AND user.nuser>0;
			INTO CURSOR x1 ORDER BY 1
		SCAN ALL
			zzz = vfpclubprofile(iuser)
			IF !EMPTY(m.zzz) AND RLOCK("user")
				SELECT user
				REPLACE muser WITH m.zzz
				UNLOCK
			ENDIF
		ENDSCAN
		USE
	ENDIF
	IF NOT DTOS(DATE()) == INIRead(.ini, "Main", "LastUpdate")
		IF !EMPTY(.Days4Zip)
			DO vfpclubzip WITH .Days4Zip
		ENDIF
		IF EMPTY(m.uParam) AND EMPTY(m.nParam)
			=vfpclubdownloadgif()
			=CloseFormAll()
			SELECT MAX(user.duser) AS duser;
				FROM club!user;
				WHERE EMPTY(user.duser)=.F. AND EMPTY(user.cuser)=.F.;
				INTO CURSOR x1
			IF x1.duser<DATE()
				=vfpclubprofall(.DownLoadProfiles)
			ENDIF
		ENDIF
		=appdelbak(.ImportPath, "xml", m.uParam)
	ENDIF
	=INIWrite(.ini, "Main", "LastUpdate", DTOS(DATE()))
ENDWITH
CLEAR DLLS
=vfpclubAddEmptyPosts(m.yyy)
DO CASE
CASE !EMPTY(m.yyy)
	IF EMPTY(m.uParam)
		WAIT WINDOW "«агружено сообщений"+STR(m.yyy) TIMEOUT _Screen.WaitTimeout
	ENDIF
	DO CASE
*!*		CASE EMPTY(_Screen.AutoRefresh) AND _Screen.FormCount>0
*!*			_Screen.Forms(1).uMethod()
	CASE !EMPTY(_Screen.AutoRefresh)
		=vfpclubPublic(-1)
	ENDCASE
CASE EMPTY(_Screen.AutoRefresh)
	=vfpclubPublic(3,4)
ENDCASE
RETURN m.yyy
