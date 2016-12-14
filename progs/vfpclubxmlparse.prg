LPARAMETERS cParam, lParam
*!*	vfpclubXMLParse
#DEFINE shortname 100
#DEFINE longname 200
#DEFINE breake1 CHR(63)
#DEFINE breake2 CHR(35)
#DEFINE breake3 CHR(44)
#DEFINE breake4 CHR(45)
IF IIF(EMPTY(m.cParam), .T., !FILE(m.cParam))
	RETURN 0
ENDIF
IF VARTYPE(_Screen.oXMLDoc)#"O"
	_Screen.oXMLDoc=CREATEOBJECT("Microsoft.XMLDOM")
	IF VARTYPE(_Screen.oXMLDoc)#"O"
		WAIT WINDOW "Не удалось создать объект MSXML2.DOMDocument" TIMEOUT _Screen.WaitTimeout
		RETURN 0
	ENDIF
ENDIF
IF EMPTY(_Screen.oXMLDoc.Load(m.cParam))
	blocklink(VAL(GETWORDNUM(JUSTFNAME(m.cParam), 2, breake4)))
	WAIT WINDOW [Error: ]+_Screen.oXMLDoc.parseError.Reason+CHR(13)+JUSTFNAME(m.cParam) TIMEOUT _Screen.WaitTimeout
	=appErase(m.cParam, _Screen.DeleteTempFiles=2)
	RETURN 0
ENDIF
LOCAL nn, mm, yyy, yy, xx, zz, mytempname, ddd, mycat, oNodeList, myid, nodeName, titlelen, cc, uu, oNode
LOCAL title, title2, link, idlink, description, pubDate, category, author, language, copyright, lastbuilddate, imageurl
*!*	LOCAL generator, ttl, xmlcp
STORE 0 TO mm, xx, mycat, idlink
*!*	STORE 0 TO ttl, xmlcp
titlelen=MAX(FSIZE('CPOST', 'POST')-20, 40)
STORE "" TO title, link, description, category, language, generator, copyright, imageurl
STORE { ::} TO ddd, pubDate, lastbuilddate
STORE _Screen.ImportPath+"old-"+SUBSTR(JUSTFNAME(m.cParam),5, LEN(JUSTFNAME(m.cParam))-8) TO mytempname
IF IIF(EMPTY(_Screen.oXMLDoc.parseError.errorCode), EMPTY(_Screen.oXMLDoc.Text), .T.)
	=appErase(m.cParam, .T.)
	RETURN 0
ENDIF
yy=_Screen.oXMLDoc.childNodes.Length-1
IF m.yy<1
	blocklink(VAL(GETWORDNUM(JUSTFNAME(m.cParam), 2, breake4)))
	=appErase(m.cParam, _Screen.DeleteTempFiles=2)
	RETURN 0
ENDIF
FOR nn=0 TO yy
	TRY
	oNodeList=_Screen.oXMLDoc.childNodes(0)
	nodeName = LOWER(oNodeList.attributes(m.nn).nodeName)
	IF nodeName == [encoding]
		IF LOWER(ALLTRIM(oNodeList.attributes(m.nn).Text))==[utf-8]
*!*			xmlcp = IIF(LOWER(ALLTRIM(oNodeList.attributes(m.nn).Text))==[utf-8], 11, m.xmlcp)
			_Screen.oXMLDoc.LoadXML(STRCONV(FILETOSTR(m.cParam), 11))
		ENDIF
		EXIT
	ENDIF
	CATCH
	ENDTRY
ENDFOR
IF TYPE([_Screen.oXMLDoc.childNodes.Item(m.yy).childNodes.Item(0).childNodes])#[O]
	blocklink(VAL(GETWORDNUM(JUSTFNAME(m.cParam), 2, breake4)))
	WAIT WINDOW [Ошибка обработки XML-файла] TIMEOUT _Screen.WaitTimeout
	=appErase(m.cParam, _Screen.DeleteTempFiles=2)
	RETURN 0
ENDIF
oNodeList=_Screen.oXMLDoc.childNodes.Item(m.yy).childNodes.Item(0).childNodes
yyy=oNodeList.Length-1
FOR nn=0 TO yyy
	nodeName = LOWER(oNodeList.Item(m.nn).nodeName)
	DO CASE
	CASE nodeName == [title]
		STORE ALLTRIM(oNodeList.Item(m.nn).Text) TO title, title2
	CASE nodeName == [link]
		link = oNodeList.Item(m.nn).Text
	CASE nodeName == [description]
		description = oNodeList.Item(m.nn).Text
	CASE nodeName == [language]
		language = UPPER(ALLTRIM(oNodeList.Item(m.nn).Text))
		IF NOT EMPTY(_Screen.RSSLanguage) AND NOT UPPER(m.language)+[ ] $ _Screen.RSSLanguage
			WAIT WINDOW +"Язык форума не совпадает"+CHR(13)+_Screen.RSSLanguage+" # "+m.language NOCLEAR TIMEOUT _Screen.WaitTimeOut
			RETURN 0
		ENDIF
	CASE nodeName == [category]
		category = oNodeList.Item(m.nn).Text
*!*					CASE nodeName == [generator]
*!*						generator = UPPER(oNodeList.item(m.nn).Text)
	CASE nodeName == [copyright]
		copyright = oNodeList.Item(m.nn).Text
*!*					CASE nodeName == [ttl]
*!*						ttl = VAL(oNodeList.item(m.nn).Text)*60
	CASE INLIST(nodeName, [pubdate], [lastbuilddate])
		pubdate = c2t(oNodeList.Item(m.nn).Text)+_Screen.AddHours*3600
	CASE nodeName == [image]
		FOR zz=oNodeList.Item(m.nn).childNodes.LENGTH-1 TO 0 STEP -1
			IF LOWER(oNodeList.Item(m.nn).childNodes.Item(m.zz).nodeName)==[url]
				imageurl = oNodeList.Item(m.nn).childNodes.Item(m.zz).Text
				EXIT
			ENDIF
		ENDFOR
	ENDCASE
ENDFOR
STORE vfpclubid(m.link) TO mycat
IF EMPTY(m.mycat)
	RETURN 0
ENDIF
STORE VAL(IIF(VAL(GETWORDNUM(JUSTFNAME(m.cParam), 3, breake4))>0 AND VAL(GETWORDNUM(JUSTFNAME(m.cParam), 2, breake4))>0, GETWORDNUM(JUSTFNAME(m.cParam), 2, breake4), SUBSTR(m.link,AT(breake1,m.link)+1))) TO xx
IF IIF(EMPTY(m.xx), .T., !SEEK(m.xx, "link", "abs"))
	=appErase(m.cParam, .T.)
	RETURN 0
ENDIF
SELECT link
IF link.icategory # m.mycat
	REPLACE icategory WITH m.mycat
ENDIF
STORE link.ilink TO xx

STORE IIF(EMPTY(m.pubDate), DATETIME(), m.pubDate) TO ddd
SELECT category
LOCATE FOR icategory=m.mycat
DO CASE
CASE FOUND() AND RLOCK()
	IF link.nlink > 0
		REPLACE link.nlink WITH 0
	ENDIF
CASE FLOCK()
	=AppCreateRecord(.T.)
	REPLACE icategory WITH m.mycat,;
		mcategory2 WITH m.link,;
		lcategory WITH IIF(m.xx<0, !EMPTY(_Screen.SaveLink), .F.),;
		ncategory WITH IIF(m.xx<0, _Screen.RSSGroupMethod, 0)
*!*		REPLACE ilink WITH m.xx
OTHERWISE
	RETURN 0
ENDCASE
IF EMPTY(category.ccategory)
	REPLACE ccategory WITH m.title
ENDIF
IF EMPTY(category.mcategory)
	REPLACE mcategory WITH IIF(EMPTY(m.description), IIF(EMPTY(m.category), m.copyright, m.category), m.description)
ENDIF
UNLOCK IN category
IF !EMPTY(m.imageurl) AND !FILE(_Screen.Graphics+TRANSFORM(category.icategory)+[.category]) AND _Screen.InternetInUse=1
	=vfphttp(m.imageurl, _Screen.Graphics+TRANSFORM(category.icategory)+[.category])
ENDIF
SELECT 0
CREATE CURSOR x1;
	(title C(longname),;
	link M,;
	idlink F(15),;
	author C(shortname),;
	description M,;
	category C(shortname),;
	pubDate T)
yy=0
IF _Screen.oXMLDoc.childNodes.Item(_Screen.oXMLDoc.childNodes.Length-1).lastChild.childNodes.Length>1
	oNodes=_Screen.oXMLDoc.childNodes.Item(_Screen.oXMLDoc.childNodes.Length-1).lastChild.childNodes
	yy=oNodes.Length-1
ENDIF
IF m.yy>0
	FOR zz=0 TO yy
		oNodeList = oNodes.Item(m.zz).childNodes
		STORE 0 TO idlink
		STORE "" TO title, link, author, description, category
		STORE { ::} TO pubDate
		yyy=oNodeList.Length-1
		FOR nn=0 TO yyy
			nodeName = LOWER(oNodeList.Item(m.nn).nodeName)
			DO CASE
			CASE nodeName==[title]
				title = vfpclubhtmltag(oNodeList.Item(m.nn).Text)
			CASE nodeName==[link]
				link = oNodeList.Item(m.nn).Text
				idlink = IIF(m.xx>0, VAL(LEFT(GETWORDNUM(m.link, 3, breake3), AT(breake2, GETWORDNUM(m.link, 3, breake3))-1)), vfpclubid(m.link))
			CASE nodeName==[author]
				author = oNodeList.Item(m.nn).Text
				IF GETWORDCOUNT(m.author)>1 AND m.xx<0 AND [@]$m.author AND [.]$m.author
					cc = GETWORDNUM(m.author,1)
					FOR uu=2 TO GETWORDCOUNT(m.author)
						cc = m.cc+IIF([@]$GETWORDNUM(m.author, m.uu) AND [.]$GETWORDNUM(m.author, m.uu), [], [ ]+GETWORDNUM(m.author, m.uu))
					ENDFOR
					author=m.cc
				ENDIF
			CASE nodeName==[description]
*!*					description = oNodeList.Item(m.nn).Text	&&STRTRAN(oNodeList.Item(m.nn).Text, CHR(13), CHR(10))
				description = STRTRAN(oNodeList.Item(m.nn).Text, [<br />], CHR(10))
			CASE nodeName==[category] AND m.xx<0
				category = vfpclubhtmltag(oNodeList.Item(m.nn).Text)
			CASE nodeName==[pubdate]
				pubdate = c2t(oNodeList.Item(m.nn).Text)+IIF(m.xx>0, _Screen.AddHours*3600, 0)
			ENDCASE
		ENDFOR
		IF !EMPTY(m.link) AND !EMPTY(m.idlink)
			INSERT INTO x1 VALUES (m.title, m.link, m.idlink, m.author, m.description, m.category, m.pubDate)
		ENDIF
	ENDFOR
	SELECT * FROM x1 INTO CURSOR x1 ORDER BY pubDate
	IF !EMPTY(_Screen.CreateTempDBF)
		COPY TO (m.mytempname) ALL AS _Screen.CreateTempDBF
	ENDIF
	IF IIF(m.xx<0, .T., FLOCK("user")) AND FLOCK("post")
		SCAN ALL
			DO CASE
*!*				CASE EMPTY(title)
			CASE m.xx<0 AND EMPTY(description) AND category.mcategory2=link
				LOOP
			CASE m.xx<0
				SCATTER MEMO MEMVAR
				SELECT post
				LOCATE FOR ABS(ipost)=m.idlink
				DO CASE
				CASE !FOUND()
					AppCreateRecord(.T.)
					REPLACE ipost WITH m.idlink,;
						icategory WITH m.mycat
					STORE m.mm+1 TO mm
				CASE icategory#m.mycat
					LOOP
				ENDCASE
				STORE IIF(EMPTY(m.author), "", RTRIM(m.author)+": ")+IIF(EMPTY(m.title), IIF(LEN(m.description)>m.titlelen, LEFT(m.description, AT([ ], m.description, MAX(1, MIN(7, GETWORDCOUNT(m.description)/2))))+[..], m.description), m.title) TO cpost
				STORE del910(m.cpost) TO cpost
*!*		ИСПРАВЛЕНИЕ АШИБОК в заголовках сообщений (title) некоторых каналов (например Xakep.Ru)
				STORE STRTRAN(STRTRAN(m.cpost, [&quot;], ["]), [quot;], ["]) TO cpost
				FOR nn=33 TO 255
					IF !([&#]$m.cpost AND [;]$m.cpost)
						EXIT
					ENDIF
					STORE STRTRAN(m.cpost, [&#]+LTRIM(STR(m.nn))+[;], CHR(m.nn)) TO cpost
				ENDFOR
				IF cpost#m.cpost
					REPLACE cpost WITH m.cpost
				ENDIF
				IF tpost<IIF(EMPTY(m.pubdate), m.ddd, m.pubdate)
					REPLACE tpost WITH IIF(EMPTY(m.pubdate), m.ddd, m.pubdate)
				ENDIF
*!*		ИСПРАВЛЕНИЕ АШИБОК в тексте сообщений некоторых каналов (например Газета.Ru)
				IF [;]$(m.description)
					STORE STRTRAN(m.description, [ & amp;], [ &amp;]) TO description
					STORE STRTRAN(m.description, [& quot;], [&quot;]) TO description
					STORE STRTRAN(m.description, [ quot;], [&quot;]) TO description
				ENDIF
				IF mpost # m.description AND !EMPTY(m.description)
					REPLACE mpost WITH m.description
				ENDIF
				IF !EMPTY(category.lcategory) AND mpost2 # m.link
					REPLACE mpost2 WITH m.link
				ENDIF
				IF !EMPTY(category.ncategory)
*!*					CASE EMPTY(m.category) AND !EMPTY(ipost2)
*!*						REPLACE ipost2 WITH 0
*!*					CASE !EMPTY(m.category)
					category=del910(m.category)
					IF !EMPTY(IIF(category.ncategory=1, m.author, IIF(category.ncategory=2, m.category, m.title2)))
*!*	WAIT WINDOW m.category
						nn=vfpclubid(UPPER(IIF(category.ncategory=1, m.author, IIF(category.ncategory=2, m.category, m.title2)))+category.mcategory2)
						REPLACE ipost2 WITH m.nn
*!*						LOCATE FOR ABS(ipost)=m.nn
						=SEEK(m.nn, "post", "abs")
						DO CASE
						CASE !FOUND()
							AppCreateRecord(.T.)
							REPLACE ipost WITH -m.nn,;
								icategory WITH m.mycat,;
								cpost WITH IIF(category.ncategory=1, m.author, IIF(category.ncategory=2, m.category, m.title2)),;
								lpost WITH .T.
							STORE MAX(m.mm, 1) TO mm
						CASE icategory#m.mycat
							LOOP
						ENDCASE
						IF tpost < MAX(IIF(EMPTY(m.pubdate), m.ddd, m.pubdate), tpost)
							REPLACE tpost WITH MAX(IIF(EMPTY(m.pubdate), m.ddd, m.pubdate), tpost)
						ENDIF
					ENDIF
				ENDIF
			CASE EMPTY(pubDate)
			CASE EMPTY(author)
*!*				CASE vfpclubid(description) = 2132806717	&& vfpclubid("-- moved topic --")
			CASE ALLTRIM(description) == "-- moved topic --"
			OTHERWISE
				SCATTER MEMO MEMVAR
				myid = vfpclubid(m.author)
				SELECT user
				IF !SEEK(m.myid, "user", "abs")
					AppCreateRecord()
					REPLACE iuser WITH m.myid,;
						cuser WITH m.author
				ENDIF
				IF user.tuser < m.pubDate
					REPLACE tuser WITH m.pubDate
				ENDIF
				SELECT post
				IF !SEEK(m.idlink, "post", "abs")
					AppCreateRecord(.T.)
					REPLACE ipost WITH m.idlink,;
						ipost2 WITH IIF(m.idlink = VAL(GETWORDNUM(m.link, 2, breake3)), 0, VAL(GETWORDNUM(m.link, 2, breake3)))
					STORE m.mm+IIF(user.iuser>0, 1, 0) TO mm
				ENDIF
				REPLACE cpost WITH m.title,;
					tpost WITH m.pubDate,;
					icategory WITH m.mycat,;
					iuser WITH ABS(user.iuser)
				IF ipost2>0 AND SEEK(ipost2, "post2") AND post2.lzip=.T.
					REPLACE lzip WITH .T.
				ENDIF
				IF !EMPTY(_Screen.Blacklist) AND user.iuser<0 AND EMPTY(lpost)
					REPLACE lpost WITH .T.
				ENDIF
				IF mpost # m.description AND !EMPTY(m.description)
					REPLACE mpost WITH m.description
				ENDIF
				IF !EMPTY(category.lcategory) AND mpost2 # m.link AND !EMPTY(m.link)
					REPLACE mpost2 WITH m.link
				ENDIF
			ENDCASE
			UNLOCK ALL
		ENDSCAN
		IF EMPTY(m.lParam)
			DO vfpclubSaveXML WITH (m.xx), (m.mm), FILETOSTR(m.cParam)	&& , m.ddd
		ENDIF
		DO CASE
		CASE !EMPTY(_Screen.DeleteTempFiles) AND !EMPTY(m.xx) AND link.ilink = m.xx AND _Screen.DeleteTempFiles=2
			=appErase(m.cParam, .T.)
		CASE !EMPTY(_Screen.DeleteTempFiles)
			=appErase(m.cParam, _Screen.DeleteTempFiles=2)
		ENDCASE
	ENDIF
	UNLOCK ALL
ENDIF
USE IN x1
_Screen.oXMLDoc=.F.
RETURN m.mm

FUNCTION del910(cparam, zz)
	FOR zz=9 TO 10
		cparam = STRTRAN(m.cparam, CHR(m.zz))
	ENDFOR
	RETURN m.cparam

PROCEDURE blocklink
	LPARAMETERS nParam
	IF !EMPTY(m.nParam) AND SEEK(m.nParam, "link", "abs") AND FLOCK("link")
		SELECT link
		IF INDEXSEEK(link.icategory, .F., "category", "icategory")
			REPLACE llink WITH .T.,;
				nlink WITH MAX(nlink, 0)
		ELSE
			DELETE
		ENDIF
		UNLOCK
	ENDIF
