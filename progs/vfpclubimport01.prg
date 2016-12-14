LPARAMETERS cParam
#DEFINE userlenold 20
#DEFINE userlennew 30
IF IIF(EMPTY(m.cParam), .T., !DIRECTORY(m.cParam))
	RETURN 0
ENDIF
LOCAL ARRAY aa[5]
IF EMPTY(ADIR(aa, m.cParam+[forum*.dbf]))
	MESSAGEBOX("Нет файлов для импорта", 16, _Screen.Caption, _Screen.MBTimeout)
	RETURN 0
ENDIF
DO vfpclubdbf WITH 2
=AppBlobJob(107)
LOCAL xx, yy, avtor, TreeAsIs, urlitemid, ParentID, urlID
yy=0
SELECT 0
CREATE CURSOR x0;
	(urlid I, urlitemid I, parentid I, subject C(50), avtor C(30), subtext M, dat T)
ON ERROR *
FOR xx=1 TO ALEN(aa,1)
	APPEND FROM m.cParam+aa(m.xx, 1)
ENDFOR
DO proc_error
SELECT link.ilink, CNT(*) AS countn;
	FROM club!link;
	INNER JOIN club!category ON link.icategory=category.icategory;
	INNER JOIN club!post ON link.icategory=post.icategory;
	INNER JOIN x0 ON ABS(post.ipost)=x0.urlitemid;
	WHERE link.ilink>0 AND link.icategory>0;
	GROUP BY 1;
	INTO CURSOR x2;
	ORDER BY 2 DESC
LOCATE FOR INLIST(x2.ilink,5,28,29)
*!*	browse
IF SEEK(IIF(INLIST(x2.ilink,28,29), x2.ilink, 5), "link", "ilink");
	AND SEEK(link.icategory, "category", "icategory");
	AND MESSAGEBOX("Сообщения из форума"+CHR(13)+ALLTRIM(category.ccategory), 289, PROMPT(), _Screen.MBtimeout)=1;
	AND FLOCK("user") AND FLOCK("post")
	SELECT * FROM x0;
		WHERE urlid>0 AND urlitemid>0;
		AND EMPTY(subject)=.F. AND dat>{};
		GROUP BY urlitemid, parentid, urlid;
		INTO CURSOR x0;
		ORDER BY urlitemid, parentid, urlid
	LOCATE FOR ParentID>0
	IF FOUND()
		TreeAsIs = !EMPTY(_Screen.TreeAsIs)
	ENDIF
	_Screen.livewallpaper.StopStart("Import Off-Line Forum data")
	SCAN
		DO CASE
		CASE _Screen.lStop
			EXIT
		CASE IIF(x0.SubText="Эта тема перемещена в другой форум", .T., ALLTRIM(x0.SubText)=="-- moved topic --")
			LOOP
		CASE link.ilink=28 AND x0.urlitemid<29936
			urlitemid=x0.urlitemid+110000
			ParentID=IIF(EMPTY(x0.ParentID), 0, x0.ParentID+110000)
			urlID=x0.urlID+110000
		CASE link.ilink=29 AND x0.urlitemid<29936
			urlitemid=x0.urlitemid+113000
			ParentID=IIF(EMPTY(x0.ParentID), 0, x0.ParentID+113000)
			urlID=x0.urlID+113000
		OTHERWISE
			SCATTER FIELDS urlitemid, ParentID, urlID MEMVAR
		ENDCASE
		=AppProgressBar(RECNO(), RECCOUNT(), "Import data")
		SELECT post
		DO CASE
		CASE !SEEK(m.urlitemid, "post", "abs")
			=AppCreateRecord(.T.)
			REPLACE ipost WITH m.urlItemId
			STORE yy+1 TO yy
		CASE post.ipost#m.urlitemid
			REPLACE ipost WITH m.urlitemid
		ENDCASE
		IF post.icategory # category.icategory
			REPLACE icategory WITH category.icategory
		ENDIF
		IF post.ipost2 # IIF(IIF(m.TreeAsIs, m.ParentID, m.urlID)=m.urlItemId, 0, IIF(m.TreeAsIs, m.ParentID, m.urlID))
			REPLACE ipost2 WITH IIF(IIF(m.TreeAsIs, m.ParentID, m.urlID)=m.urlItemId, 0, IIF(m.TreeAsIs, m.ParentID, m.urlID))
		ENDIF
		IF NOT ALLTRIM(post.cpost)==ALLTRIM(x0.subject)
			REPLACE cpost WITH ALLTRIM(x0.subject)
		ENDIF
		IF post.tpost # x0.dat+_Screen.AddHours*3600
			REPLACE tpost WITH x0.dat+_Screen.AddHours*3600
		ENDIF
		IF _Screen.Days4Zip<0 AND TTOD(post.tpost)<DATE()+_Screen.Days4Zip
			REPLACE lzip WITH .T.
		ENDIF
		IF post.ipost2>0 AND IIF(post.ipost2=ABS(post2.ipost), .T., SEEK(post.ipost2, "post2")) AND post2.lzip=.T.
			REPLACE lzip WITH .T.
		ENDIF
		SubText=ALLTRIM(IIF("[%sig%]"$x0.SubText, LEFT(x0.SubText, AT("[%sig%]", x0.SubText)-1), x0.SubText))
*!*			IF AT("[/img]", m.SubText)>AT("[img]", m.SubText)
*!*				SubText=STRTRAN(m.SubText, "[/img]", "]")
*!*				SubText=STRTRAN(m.SubText, "[img]", "[attachment ")
*!*			ENDIF
		IF post.mpost # m.SubText AND !EMPTY(m.SubText)
			REPLACE mpost WITH m.SubText
		ENDIF
		IF !EMPTY(x0.avtor)
			avtor=ALLTRIM(x0.avtor)
			IF LEN(m.avtor)>userlenold
				SELECT user
				LOCATE FOR ALLTRIM(cuser) == LEFT(m.avtor, userlenold)
				IF FOUND() AND LEN(ALLTRIM(cuser)) <= userlenold
					REPLACE iuser WITH vfpclubid(x0.avtor)
					REPLACE cuser WITH m.avtor
				ENDIF
			ENDIF
			SELECT user
			LOCATE FOR ALLTRIM(cuser) == LEFT(m.avtor, userlennew)
			IF !FOUND()
				INSERT INTO user (iuser, cuser);
					VALUES (vfpclubid(LEFT(m.avtor, userlennew)), m.avtor)
			ENDIF
			IF user.tuser < post.tpost
				REPLACE tuser WITH post.tpost
			ENDIF
			IF post.iuser # ABS(user.iuser)
				SELECT post
				REPLACE iuser WITH ABS(user.iuser)
			ENDIF
		ENDIF
	ENDSCAN
	_Screen.livewallpaper.StopStart()
	USE
	USE IN x2
	UNLOCK ALL
	vfpclubAddEmptyPosts(m.yy)
ELSE
	USE IN x2
	UNLOCK ALL
	MESSAGEBOX("Ошибка выполнения", 16, PROMPT(), _Screen.MBtimeout)
ENDIF
RETURN m.yy
