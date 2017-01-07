*!*	это взято из решений клуба
*!*	спасибо тебе, Владимир Кныр
LPARAMETERS cParam
#DEFINE userlenold 20
#DEFINE userlennew 30
#DEFINE nLocaleID 14
#DEFINE postlennew 100
IF IIF(EMPTY(m.cParam), .T., !DIRECTORY(m.cParam))
	RETURN 0
ENDIF
LOCAL ARRAY aa[5]
IF EMPTY(ADIR(aa, m.cParam+[ffxml_*.xml]))
	MESSAGEBOX("Нет файлов для импорта", 16, _Screen.Caption, _Screen.MBTimeout)
	RETURN 0
ENDIF
DO vfpclubdbf WITH 2
=AppBlobJob(108)
SELECT 0
LOCAL xx, yy, author	&&, lz
yy=0
FOR xx=1 TO ALEN(aa,1)
	ON ERROR *
	IF EMPTY(XMLTOCURSOR(m.cParam + aa[m.xx,1], [x0], _Screen.xml2cursor))
		DO proc_error
		LOOP
	ENDIF
	DO proc_error
	_Screen.livewallpaper.StopStart("Import Off-Line Forum data")
	IF USED() AND FLOCK("user") AND FLOCK("post")
		SELECT id, Parent, thread, PADR(STRCONV(LTRIM(author), nLocaleID), userlennew) AS author, PADR(STRCONV(LTRIM(subject), nLocaleID), postlennew) AS subject, datestamp, body, category.icategory;
			FROM x0;
			INNER JOIN club!link ON x0.forumid = link.ilink;
			INNER JOIN club!category ON link.icategory=category.icategory;
			WHERE id>0 AND thread>0;
			INTO CURSOR x1 READWRITE;
			ORDER BY 1,2
		SCAN ALL
			=AppProgressBar(RECNO(), RECCOUNT(), "Import data "+LTRIM(STR(ALEN(aa,1)))+[:]+LTRIM(STR(m.xx)))
*!*				STORE .F. TO lz
			REPLACE body WITH STRCONV(ALLTRIM(body), nLocaleID)
			SELECT post
			DO CASE
			CASE _Screen.lStop
				EXIT
			CASE ALLTRIM(x1.body) == "-- moved topic --"
				LOOP
			CASE !SEEK(x1.id, "post", "abs")
				=AppCreateRecord(.T.)
				REPLACE ipost WITH x1.id
				STORE m.yy+1 TO yy
			CASE post.ipost#x1.id
				REPLACE ipost WITH x1.id
			ENDCASE
			IF post.icategory # x1.icategory
				REPLACE icategory WITH x1.icategory
			ENDIF
			DO CASE
			CASE post.ipost = x1.thread AND !EMPTY(post.ipost2)
				REPLACE ipost2 WITH 0
			CASE post.ipost = x1.thread
*!*				IF x1.Parent>0 AND post.ipost2 # IIF(EMPTY(_Screen.TreeAsIs), x1.thread, x1.Parent)
			CASE post.ipost2 # IIF(EMPTY(_Screen.TreeAsIs), x1.thread, x1.Parent)
				REPLACE ipost2 WITH IIF(EMPTY(_Screen.TreeAsIs), x1.thread, x1.Parent)
			ENDCASE
			IF NOT ALLTRIM(post.cpost)==ALLTRIM(x1.subject)
				REPLACE cpost WITH LTRIM(x1.subject)
			ENDIF
			IF post.tpost # x1.datestamp+_Screen.AddHours*3600
				REPLACE tpost WITH x1.datestamp+_Screen.AddHours*3600
			ENDIF
			IF _Screen.Days4Zip<0 AND TTOD(post.tpost)<DATE()+_Screen.Days4Zip
*!*					STORE .T. TO lz
				REPLACE lzip WITH .T.
			ENDIF
			IF post.ipost2>0 AND IIF(post.ipost2=ABS(post2.ipost), .T., SEEK(post.ipost2, "post2")) AND post2.lzip=.T.
*!*					STORE .T. TO lz
				REPLACE lzip WITH .T.
			ENDIF
*!*				IF post.mpost#x1.body AND !EMPTY(x1.body)
			IF LEN(post.mpost) < LEN(ALLTRIM(x1.body))
				REPLACE mpost WITH x1.body
			ENDIF
			IF !EMPTY(x1.author)
				author=ALLTRIM(x1.author)
				IF LEN(m.author)>userlenold
					SELECT user
					LOCATE FOR ALLTRIM(cuser) == LEFT(m.author, userlenold)
					IF FOUND() AND LEN(ALLTRIM(cuser)) <= userlenold
						REPLACE iuser WITH vfpclubid(x1.author)
						REPLACE cuser WITH m.author
					ENDIF
				ENDIF
				SELECT user
				LOCATE FOR ALLTRIM(cuser) == LEFT(m.author, userlennew)
				IF !FOUND()
					INSERT INTO user (iuser, cuser);
						VALUES (vfpclubid(LEFT(m.author, userlennew)), m.author)
				ENDIF
				IF user.tuser < post.tpost
					REPLACE tuser WITH post.tpost
				ENDIF
				IF post.iuser # ABS(user.iuser)
					SELECT post
					REPLACE iuser WITH ABS(user.iuser)
				ENDIF
			ENDIF
*!*				IF !EMPTY(_Screen.TreeAsIs) AND x1.Parent>0 AND !INDEXSEEK(x1.Parent, .F., "post", "ipost2")
*!*					INSERT INTO post (ipost, ipost2, icategory, cpost, tpost, lzip);
*!*						VALUES (-x1.Parent, x1.thread, x1.icategory, LTRIM(x1.subject), x1.datestamp+_Screen.AddHours*3600, m.lz)
*!*				ENDIF
		ENDSCAN
		IF !EMPTY(_Screen.CreateTempDBF) AND EMPTY(_Screen.lStop)
			COPY TO (_Screen.ImportPath+"old"+LEFT(m.aa[xx,1], LEN(m.aa[xx,1])-3)+[dbf]) ALL AS _Screen.CreateTempDBF
			USE (_Screen.ImportPath+"old"+LEFT(m.aa[xx,1], LEN(m.aa[xx,1])-4)) ALIAS x1
		ENDIF
		UNLOCK IN user
		UNLOCK IN post
		USE IN x1
		USE IN x0
		IF !EMPTY(_Screen.DeleteTempFiles)
			=AppErase(m.cParam + aa[m.xx,1], _Screen.DeleteTempFiles=2)
		ENDIF
	ENDIF
	IF _Screen.lStop
		EXIT
	ENDIF
	SET MESSAGE TO
ENDFOR
_Screen.livewallpaper.StopStart()
vfpclubAddEmptyPosts(m.yy)
RETURN m.yy
