LPARAMETERS lParam
#DEFINE nDBCVer 14
#DEFINE cOpen "Открытие базы данных"
#DEFINE dbcname "CLUB"
LOCAL nn, yy, xx, comment, database, caption, field, table
yy = appDBC(dbcname,(m.lParam))
Comment="Comment"
database="DATABASE"
table="TABLE"
caption="Caption"
field="FIELD"
IF EMPTY(m.yy)
	MESSAGEBOX("Не найдена база данных "+dbcname, 16, _Screen.Caption)
	QUIT
ENDIF
nn=INT(VAL(DBGETPROP(DBC(),DATABASE,Comment)))
_Screen.AddProperty("aDBF[7]", "")
DO CASE
CASE nn<nDBCVer
	IF MESSAGEBOX("Требуется Update контейнера базы до версии "+TRANSFORM(nDBCVer);
			+CHR(13)+"Текущая версия"+STR(nn);
			+CHR(13)+"Внести изменения немедленно",33,cOpen)=1
		FOR yy=1 TO nDBCVer
			ON ERROR *
			DO appDBC WITH dbcname, .T.
			DO CASE
			CASE yy<=nn
			CASE yy=1
				If !USED("category")
					Use club!category IN 0
				Endif
				If !USED("link2")
					Use club!link2 IN 0
				Endif
				If !USED("post")
					Use club!post IN 0
				Endif
				IF !EMPTY(RECCOUNT("post")) AND MESSAGEBOX("Удалить предыдущие записи", 33, _Screen.Caption)=1
					SELECT link2
					ZAP
					SELECT post.ipost;
						FROM club!post;
						WHERE post.ipost2>0 AND post.ipost2 NOT IN (SELECT ABS(ipost) FROM club!post);
						GROUP BY 1;
						INTO CURSOR x1;
						ORDER BY 1 DESC
					SCAN
						SELECT post
						LOCATE FOR ipost = x1.ipost
						IF FOUND()
							=AppDelRec("post", "ipost")
						ENDIF
					ENDSCAN
					USE IN x1
				ENDIF
				ALTER TABLE category DROP COLUMN tcategory
				ALTER TABLE category ALTER COLUMN ncategory N (2) DEFAULT 0
				=DBSETPROP("category", TABLE, Comment, "Форумы")
				=DBSETPROP("category.ccategory", FIELD, Caption, "Наименование")
				=DBSETPROP("category.mcategory", FIELD, Caption, "Описание")
				=DBSETPROP("category.mcategory2", FIELD, Caption, "Ссылка")
				=DBSETPROP("category.ncategory", FIELD, Caption, "Форум")

				=DBSETPROP("link", TABLE, Comment, "Ссылки")
				=DBSETPROP("link.mlink", FIELD, Caption, "Ссылка")
				=DBSETPROP("link.llink", FIELD, Caption, "Блокирована")
				=DBSETPROP("link.nlink", FIELD, Caption, "Попытки")
				Select post
				ALTER TABLE post ALTER COLUMN cpost C (100)
				=DBSETPROP("post", TABLE, Comment, "Сообщения")
				=DBSETPROP("post.cpost", FIELD, Caption, "Тема")
				=DBSETPROP("post.mpost", FIELD, Caption, "Текст")
				=DBSETPROP("post.mpost2", FIELD, Caption, "Ссылка")
				=DBSETPROP("post.tpost", FIELD, Caption, "Отправлнео")
				=DBSETPROP("post.icategory", FIELD, Caption, "Форум")
				=DBSETPROP("post.iuser", FIELD, Caption, "От")
				INDEX ON ABS(ipost) TAG abs
				INDEX ON ipost2 TAG ipost2 ADDITIVE
				INDEX ON icategory TAG icategory ADDITIVE
				INDEX ON iuser TAG iuser ADDITIVE

				ALTER TABLE link2 ADD COLUMN mlink2 M NOCPTRANS
				=DBSETPROP("link2", TABLE, Comment, "Хронология загрузки XML")
				=DBSETPROP("link2.ilink2", FIELD, Caption, "Идентификатор")
				=DBSETPROP("link2.ilink", FIELD, Caption, "Идентификатор (ссылки)")
				=DBSETPROP("link2.tlink2", FIELD, Caption, "Дата")
				=DBSETPROP("link2.nlink2", FIELD, Caption, "Количество добавленных постов")
				=DBSETPROP("link2.mlink2", FIELD, Caption, "XML")

				=DBSETPROP("user", TABLE, Comment, "Пользователи")
				=DBSETPROP("user.cuser", FIELD, Caption, "Ник")
*!*					=DBSETPROP("user.tuser", FIELD, Caption, "Активность")
				=DBSETPROP("user.muser", FIELD, Caption, "Профиль")
			CASE yy=2
				If !USED("category")
					Use club!category IN 0
				ENDIF
				SELECT category
				ALTER TABLE post ALTER COLUMN cpost C (100) NOCPTRANS
				INDEX ON ncategory TAG ncategory ADDITIVE
				CREATE TABLE ADDBS(JUSTPATH(DBC()))+"clubquote" NAME quote (iquote I, cquote C (40), cquote2 C (40), lquote L DEFAULT .F.)
				INDEX ON iquote TAG iquote
				=DBSETPROP("quote", TABLE, Comment, "Автозамена")
				=DBSETPROP("quote.iquote", FIELD, Caption, "Идентификатор")
				=DBSETPROP("quote.cquote", FIELD, Caption, "Поиск")
				=DBSETPROP("quote.cquote2", FIELD, Caption, "Замена")
				=DBSETPROP("quote.lquote", FIELD, Caption, "Триггер")

				=DBSETPROP("post.tpost", FIELD, Caption, "Отправлено")

				If !USED("USER")
					Use club!user IN 0
				ENDIF
				SELECT user
				ALTER TABLE user ADD COLUMN nuser I
				ALTER TABLE user ADD COLUMN luser L DEFAULT .F.
				=DBSETPROP("user.nuser", FIELD, Caption, "ID foxclub")
				=DBSETPROP("user.luser", FIELD, Caption, "Друг")
				INDEX ON ALLTRIM(cuser) TAG cuser ADDITIVE
			CASE yy=3
				ALTER TABLE category DROP COLUMN tcategory
				ALTER TABLE post ADD COLUMN lzip L DEFAULT .F.
				=DBSETPROP("post.lzip", FIELD, Caption, "Архив")
*!*					CREATE TABLE (ADDBS(JUSTPATH(DBC())) + "clubblob") NAME "blob";
*!*						(iblob I, imenu I, tblob T DEFAULT DATETIME(), cuser C (15) DEFAULT RIGHT(ID(),AT(CHR(35),ID())+3), cblob C (15) DEFAULT LEFT(ID(), AT(CHR(35), ID())-2))
				CREATE TABLE (ADDBS(JUSTPATH(DBC())) + "clubblob") NAME "blob";
					(iblob I, imenu I, tblob T DEFAULT DATETIME(), cuser C (15), cblob C (15) DEFAULT LEFT(ID(), AT(CHR(35), ID())-2))
				INDEX ON iblob TAG iblob
				=DBSETPROP("blob", TABLE, Comment, "Протокол работы программы")
				=DBSETPROP("blob.iblob", FIELD, Caption, "Идентификатор")
				=DBSETPROP("blob.imenu", FIELD, Caption, "Команда меню")
				=DBSETPROP("blob.tblob", FIELD, Caption, "Время выполнения")
				=DBSETPROP("blob.cuser", FIELD, Caption, "Пользователь")
				=DBSETPROP("blob.cblob", FIELD, Caption, "Компьютер")
				CREATE SQL VIEW user02 AS;
					SELECT blob.cuser;
					FROM club!blob;
					GROUP BY 1;
					ORDER BY 1

				=AppErase(_Screen.ini)
				_Screen.BlobJob=[]
				DO vfpclubini
				DO vfpclubini WITH ,TRANSFORM(_Screen.UserID)
			CASE yy=4
				CREATE SQL VIEW category01 AS;
					SELECT Category.ccategory, Category.icategory, Category.ncategory;
					FROM club!category;
					WHERE EMPTY(Category.ccategory) = .F.;
					AND Category.icategory > 0 AND Category.ncategory > 0;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
			CASE yy=5
				SELECT ABS(post.ipost) AS ipost, user.iuser;
					FROM club!post;
					INNER JOIN club!user ON post.iuser = ABS(user.iuser);
					INTO CURSOR C1 ORDER BY 2
				SCAN ALL FOR SEEK(iuser, "user", "iuser")=.T.
					STORE vfpclubid(user.cuser) TO xx
					SELECT post
					REPLACE iuser WITH m.xx ALL FOR iuser = ABS(user.iuser)
					SELECT user
					REPLACE iuser WITH IIF(iuser>0, m.xx, -m.xx)
				ENDSCAN
				SELECT ABS(post.ipost) AS ipost, post.icategory;
					FROM club!post;
					INNER JOIN club!category ON post.icategory = category.icategory;
					INTO CURSOR C1 ORDER BY 2
				SCAN ALL FOR SEEK(icategory, "category", "icategory")=.T.
					STORE vfpclubid(category.ccategory) TO xx
					SELECT post
					REPLACE icategory WITH m.xx ALL FOR icategory = category.icategory
					SELECT category
					REPLACE icategory WITH m.xx
				ENDSCAN
				WITH _Screen
					STORE INIRead(.ini,"Main","DefaultCategory") TO xx
					STORE IIF(EMPTY(m.xx) OR INT(VAL(m.xx))=23094, 11097, .DefaultCategory) TO .DefaultCategory
					=INIWrite(.ini,"Main","DefaultCategory",TRANSFORM(.DefaultCategory))
				ENDWITH
			CASE yy=6
				DO vfpclubdefault WITH 1
				DO vfpclubdefault WITH 2
				SELECT user.iuser, user.cuser;
					FROM club!user;
					WHERE user.iuser>0 AND user.nuser>0 AND EMPTY(user.cuser)=.F.;
					GROUP BY 1;
					INTO CURSOR C1
				SCAN FOR FILE(_Screen.Graphics + ALLTRIM(cuser))
					IF FILE(vfpclubavatar(TRANSFORM(iuser)))
						=AppErase(_Screen.Graphics + ALLTRIM(cuser))
						ON ERROR *
					ELSE
						RENAME (_Screen.Graphics + ALLTRIM(cuser)+".") TO vfpclubavatar(TRANSFORM(iuser))
					ENDIF
				ENDSCAN
				ALTER TABLE user ALTER COLUMN cuser C (30) NOCPTRANS
				IF _Screen.InternetInUse>0
					SELECT user.iuser;
						FROM club!user;
						WHERE user.iuser>0 AND user.nuser>0 AND EMPTY(user.cuser)=.F. AND EMPTY(user.muser)=.T.;
						GROUP BY 1;
						INTO CURSOR C1
					SCAN ALL FOR SEEK(iuser, "user", "iuser")
						xx = vfpclubprofile(iuser)
						IF !EMPTY(m.xx)
							SELECT user
							REPLACE muser WITH m.xx
						ENDIF
					ENDSCAN
				ENDIF
				IF !USED("blob")
					USE club!clob IN 0
				ENDIF
				SELECT blob
				REPLACE FOR BETWEEN(imenu, 111, 112) imenu WITH imenu+3
			CASE yy=7
				If !USED("post")
					Use club!post IN 0
				ENDIF
				ALTER TABLE club!post ALTER COLUMN iuser F(20)
				ALTER TABLE club!post ALTER COLUMN icategory F(20)
				If !USED("category")
					Use club!category IN 0
				ENDIF
				SELECT category
				ALTER TABLE club!category ALTER COLUMN icategory F(20)
				SCAN ALL
					xx = icategory
					REPLACE icategory WITH vfpclubid(ccategory)
					SELECT post
					REPLACE iCategory WITH Category.iCategory FOR iCategory = m.xx
				ENDSCAN
				If !USED("user")
					Use club!user IN 0
				ENDIF
				SELECT user
				ALTER TABLE club!user ALTER COLUMN iuser F(20)
				RECALL ALL
				DELETE TAG cuser
				SCAN ALL
					xx = ABS(iuser)
					REPLACE iuser WITH IIF(iuser<0, -1, 1)*vfpclubid(cuser)
					IF FILE(vfpclubavatar(TRANSFORM(m.xx)))
						RENAME (_Screen.Graphics + TRANSFORM(m.xx)+"."+_Screen.Comment) TO vfpclubavatar(TRANSFORM(ABS(iuser)))
					ENDIF
					SELECT post
					REPLACE iUser WITH User.iUser FOR iuser = m.xx
				ENDSCAN
			CASE yy=8
				ALTER TABLE post DROP COLUMN mpost2
			CASE yy=9
				CREATE TABLE ADDBS(JUSTPATH(DBC()))+"clubfavorite" NAME favorite (ifavorite I)
				INDEX ON ifavorite TAG ifavorite
				=DBSETPROP("favorite", TABLE, Comment, "Избранное")
				=DBSETPROP("favorite.ifavorite", FIELD, Caption, "Идентификатор")
				If !USED("user")
					Use club!user IN 0
				ENDIF
				SELECT user
				ALTER TABLE club!user ALTER COLUMN iuser F(15)
				ALTER TABLE user ADD COLUMN duser D
				=DBSETPROP("user.duser", FIELD, Caption, "Дата регистрации")
				=DBSETPROP("user.tuser", FIELD, Caption, "Последняя активность")
				INDEX ON ABS(iuser) TAG abs ADDITIVE
*!*					INDEX ON ABS(nuser) TAG nuser ADDITIVE
				If !USED("category")
					Use club!category IN 0
				ENDIF
				SELECT category
				DELETE TAG ccategory
				ALTER TABLE club!category ALTER COLUMN icategory F(15)
				ALTER TABLE club!category ALTER COLUMN ncategory F(15)
				ALTER TABLE club!category ADD COLUMN lcategory L DEFAULT .F.
				=DBSETPROP("category.lcategory", FIELD, Caption, "Хранить ссылки")
				ALTER TABLE club!post ALTER COLUMN cpost C (120) NOCPTRANS
				ALTER TABLE club!post ALTER COLUMN ipost F(15)
				ALTER TABLE club!post ALTER COLUMN ipost2 F(15)
				ALTER TABLE club!post ALTER COLUMN iuser F(15)
				ALTER TABLE club!post ALTER COLUMN icategory F(15)
				ALTER TABLE club!post ADD COLUMN mpost2 M NOCPTRANS
				=DBSETPROP("post.mpost2", FIELD, Caption, "Ссылка")
				If !USED("link")
					Use club!link IN 0
				ENDIF
				SELECT link
				ALTER TABLE club!link ALTER COLUMN ilink F(15)
				INDEX ON ABS(ilink) TAG abs ADDITIVE
				ALTER TABLE club!link2 ALTER COLUMN ilink F(15)
				If !USED("blob")
					Use club!blob
				ENDIF
				SELECT blob
				DELETE FOR BETWEEN(imenu,94,115)
				ALTER TABLE blob ALTER COLUMN cuser C (15) DEFAULT SUBSTR(ID(),AT(CHR(35),ID())+2)
				CREATE SQL VIEW category01 AS;
					SELECT Category.ccategory, Category.icategory, Category.ncategory;
					FROM club!category;
					INNER JOIN club!link ON Category.ncategory = link.ilink;
					WHERE Category.ncategory > 0 AND Category.icategory > 0;
					AND EMPTY(Category.ccategory) = .F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
				CREATE SQL VIEW category02 AS;
					SELECT Category.ccategory, Category.icategory, Category.ncategory;
					FROM club!category;
					INNER JOIN club!link ON Category.ncategory = link.ilink;
					WHERE Category.ncategory < 0 AND Category.icategory > 0;
					AND EMPTY(Category.ccategory) = .F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
			CASE yy=10
				If !USED("post")
					Use club!post IN 0
				ENDIF
				If !USED("category")
					Use club!category IN 0
				ENDIF
				SELECT category
				DELETE TAG ncategory
				ALTER TABLE category DROP COLUMN ilink
				ALTER TABLE club!category ALTER COLUMN ccategory C(60) NOCPTRANS
				ALTER TABLE club!category ADD COLUMN ilink F(15) DEFAULT 0
				=DBSETPROP("category.ilink", FIELD, Caption, "Идентификатор (ссылки)")
				SCAN ALL
					xx = icategory
					REPLACE icategory WITH vfpclubid(mcategory2)
					REPLACE ilink WITH ncategory
					SELECT post
					REPLACE iCategory WITH Category.iCategory FOR iCategory = m.xx
				ENDSCAN
				ALTER TABLE category DROP COLUMN ncategory
				INDEX ON ilink TAG ilink ADDITIVE
				CREATE SQL VIEW category01 AS;
					SELECT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, category.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.ilink = link.ilink;
					WHERE Category.ilink>0 AND Category.icategory>0;
					AND EMPTY(Category.ccategory)=.F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
				CREATE SQL VIEW category02 AS;
					SELECT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, category.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.ilink = link.ilink;
					WHERE Category.ilink<0 AND Category.icategory>0;
					AND EMPTY(Category.ccategory)=.F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
			CASE yy=11
				If !USED("category")
					Use club!category IN 0
				ENDIF
				SELECT category
				DELETE TAG ilink
				IF !USED("link")
					USE club!link IN 0
				ENDIF
				SELECT link
				ALTER TABLE link ADD COLUMN icategory F (15) DEFAULT 0
				=DBSETPROP("link.icategory", FIELD, Caption, "Форум")
				INDEX ON icategory TAG icategory ADDITIVE
				IF !USED("post")
					Use club!post IN 0
				ENDIF
				SELECT post
*!*					INDEX ON tpost TAG tpost ADDITIVE
				INDEX ON TTOD(tpost) TAG dpost ADDITIVE
*!*					INDEX ON YEAR(tpost)*100+MONTH(tpost) TAG yyyymm ADDITIVE
*!*					INDEX ON lzip TAG lzip ADDITIVE
				IF !USED("quote")
					Use club!quote IN 0
				ENDIF
				SELECT quote
				INDEX ON cquote TAG cquote ADDITIVE
				IF !USED("user")
					Use club!user IN 0
				ENDIF
				SELECT user
				INDEX ON duser TAG duser ADDITIVE
				CREATE SQL VIEW category01 AS;
					SELECT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, link.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.icategory=link.icategory;
					WHERE Category.icategory>0 AND Link.ilink>0;
					AND EMPTY(Category.ccategory)=.F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
				CREATE SQL VIEW category02 AS;
					SELECT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, link.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.icategory=link.icategory;
					WHERE Category.icategory>0 AND Link.ilink<0;
					AND EMPTY(Category.ccategory)=.F.;
					GROUP BY Category.icategory;
					ORDER BY Category.ccategory
			CASE yy=12
				If !USED("category")
					Use club!category IN 0
				ENDIF
*!*					SELECT category
				ALTER TABLE category ADD COLUMN lzip L DEFAULT .T.
				=DBSETPROP("category.lzip", FIELD, Caption, "Автоудаление сообщений")
				ALTER TABLE category ADD COLUMN ncategory N (1) DEFAULT 0
				=DBSETPROP("category.ncategory", FIELD, Caption, "Метод группировки")
*!*					REPLACE ALL ncategory WITH 2
			CASE yy=13
				ALTER TABLE category DROP COLUMN ilink2
				
				CREATE SQL VIEW category01 AS;
					SELECT DISTINCT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, link.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.icategory=link.icategory;
					WHERE Category.icategory>0 AND Link.ilink>0;
					AND EMPTY(Category.ccategory)=.F.;
					ORDER BY 1
				CREATE SQL VIEW category02 AS;
					SELECT DISTINCT LEFT(Category.ccategory,40) AS ccategory, Category.icategory, link.ilink;
					FROM club!category;
					INNER JOIN club!link ON Category.icategory=link.icategory;
					WHERE Category.icategory>0 AND Link.ilink<0;
					AND EMPTY(Category.ccategory)=.F.;
					ORDER BY 1
			CASE yy=14
				SELECT user
				ALTER TABLE user DROP FOREIGN KEY TAG duser
				ALTER TABLE user ADD COLUMN iUser2 F(15)
				=DBSETPROP("user.iUser2", FIELD, Caption, "Идентификатор (2)")
				INDEX ON iUser2 TAG iUser2 ADDITIVE
			ENDCASE
			=SYS(1104)
			=DBSETPROP(DBC(), DATABASE, Comment, TRANSFORM(m.yy))
			=appdelbak(ADDBS(JUSTPATH(DBC())))
			=appdelbak(ADDBS(JUSTPATH(DBC())), "tbk")
		ENDFOR
		DO proc_error
		DO vfpclubindex WITH .T.
		DO vfpclubaudit WITH .T.
		nn=VAL(DBGETPROP(DBC(),DATABASE,Comment))
	ENDIF
	IF nn<nDBCVer
		MESSAGEBOX("Требуется Update контейнера базы до версии "+TRANSFORM(nDBCVer)+CHR(13)+"Дальнейшая работа невозможна",16,cOpen)
		QUIT
	ENDIF
CASE nn>nDBCVer
	MESSAGEBOX("Требуется Upgrade программы"+CHR(13)+"Дальнейшая работа невозможна",16,cOpen)
	QUIT
ENDCASE
DO vfpclubDBF WITH IIF(EMPTY(lParam),1,0)
