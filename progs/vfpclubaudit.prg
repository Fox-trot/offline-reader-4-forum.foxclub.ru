LPARAMETERS lParam
*!*	Aудит данных
DO vfpclubdbf WITH 2

PRIVATE d1, d2, e1, e2, qq
LOCAL cc, nn, yy
LOCAL ARRAY aa(1)
STORE 0 TO d1, d2, e1, e2, ii, aa, qq

STORE IIF(EMPTY(m.lParam), ADDBS(SYS(2023))+SYS(3)+".tmp", ADDBS(SYS(5)+SYS(2003))+_SCREEN.Comment+SYS(3)+".txt") TO cc
IF OpenFile(m.cc)=.F.
	MESSAGEBOX("Ошибка записи",16,"Aудит данных", _Screen.MBTimeout)
	RETURN .F.
ENDIF
AppBlobJob(96)
SET TEXTMERGE TO (m.cc) NOSHOW
SET TEXTMERGE ON
=auditsay(0)

SELECT Link
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL
		DO CASE
		CASE IIF(EMPTY(iLink), .T., EMPTY(mLink))=.T.
			=auditsay(8)
		CASE nlink<0 AND llink AND auditsay(5)
			REPLACE llink WITH .F.
		ENDCASE
	ENDSCAN
*!*		поиск дублей
	SELECT ABS(Link.iLink) AS iLink, CNT(Link.iLink) AS nCount;
		FROM club!Link;
		GROUP BY 1 HAVING nCount>1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL
		IF SEEK(C1.iLink, "Link", "abs")
			SELECT Link
			nn = iLink
			SKIP
			SCAN REST FOR iLink = m.nn
				=auditsay(4)
			ENDSCAN
		ENDIF
	ENDSCAN
ENDIF
UNLOCK IN Link

SELECT Category
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL
		DO CASE
		CASE EMPTY(cCategory) AND !EMPTY(iCategory) AND INDEXSEEK(iCategory, .F., "post", "iCategory") AND auditsay(5)
			REPLACE cCategory WITH TRANSFORM(iCategory)
		CASE EMPTY(iCategory) AND !EMPTY(mCategory2) AND auditsay(5)
			REPLACE iCategory WITH vfpclubid(mCategory2)
		CASE IIF(EMPTY(iCategory), .T., !INDEXSEEK(iCategory, .F., "Link", "iCategory"))
			=auditsay(8)
		CASE link.ilink>0 AND !EMPTY(ncategory) AND auditsay(5)
			REPLACE ncategory WITH 0
		ENDCASE
	ENDSCAN
*!*		поиск дублей
	SELECT Category.iCategory, CNT(Category.iCategory) AS nCount;
		FROM club!Category;
		GROUP BY 1 HAVING nCount>1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL
		IF SEEK(C1.iCategory, "Category", "iCategory")
			SELECT Category
			nn = iCategory
			SKIP
			SCAN REST FOR iCategory = m.nn
				=auditsay(4)
			ENDSCAN
		ENDIF
	ENDSCAN
ENDIF
UNLOCK IN Category

SELECT Link2
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL FOR EMPTY(mLink2)=.T. AND IIF(EMPTY(tLink2), .T., INDEXSEEK(iLink, .F., "Link", "iLink")=.F.)=.T.
		=auditsay(8)
	ENDSCAN
ENDIF
UNLOCK IN Link2

SELECT Quote
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL FOR IIF(iQuote=0, .T., EMPTY(cQuote))
		=auditsay(8)
	ENDSCAN
*!*		поиск дублей
	SELECT Quote.iQuote, CNT(Quote.iQuote) AS nCount;
		FROM club!Quote;
		GROUP BY 1 HAVING nCount>1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL
		IF SEEK(C1.iQuote, "Quote", "iQuote")
			SELECT Quote
			nn = iQuote
			SKIP
			SCAN REST FOR iQuote = m.nn
				=auditsay(4)
			ENDSCAN
		ENDIF
	ENDSCAN
ENDIF
UNLOCK IN Quote

SELECT User
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL
		DO CASE
		CASE EMPTY(cUser) AND nUser<0 AND nUser#iUser AND auditsay(5)
			REPLACE iUser WITH nUser
			\\ cuser is null
		CASE EMPTY(cUser)
		CASE ABS(iUser)#vfpclubid(cUser) AND auditsay(5) AND FLOCK("post")
			nn = ABS(iUser)
			REPLACE iUser WITH IIF(iUser<0, -1, 1)*vfpclubid(cUser)
			SELECT post
			SCAN ALL FOR iuser = nn
				REPLACE iuser WITH ABS(User.iUser)
			ENDSCAN
		CASE EMPTY(iUser) AND auditsay(8)
		ENDCASE
	ENDSCAN
*!*		поиск дублей
	SELECT ABS(user.iuser) AS iuser, CNT(user.iuser) AS nCount;
		FROM club!user;
		GROUP BY 1 HAVING nCount>1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL
		IF SEEK(C1.iuser, "user", "abs")
			SELECT user
			nn = iuser
			SKIP
			SCAN REST FOR iuser = m.nn
				=auditsay(4)
			ENDSCAN
		ENDIF
	ENDSCAN
ENDIF
UNLOCK IN User

SELECT Post
IF !EMPTY(RECCOUNT())
	=auditsay(10)
*!*		тест архива
	SELECT ABS(post.ipost) AS ipost;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		INNER JOIN club!post AS p2 ON post.ipost2 =ABS(p2.ipost) AND post.icategory=p2.icategory;
		WHERE Link.iLink>0 AND post.lzip # p2.lzip;
		GROUP BY 1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL FOR SEEK(ipost, "post", "abs")
		SELECT post
		IF auditsay(5)
			\\	lzip # post.lzip
			REPLACE lzip WITH EMPTY(lzip)
		ENDIF
	ENDSCAN
	USE
	SELECT Post
	SCAN ALL
		DO CASE
		CASE !SEEK(icategory, "category", "icategory")
			=auditsay(8)
			\\	<<icategory>> not found in Category
		CASE !SEEK(icategory, "link", "icategory")
			=auditsay(8)
			\\	<<icategory>> not found in Link
		CASE EMPTY(ipost)
			IF link.iLink<0 AND !EMPTY(mpost2)
				REPLACE ipost WITH vfpclubid(mpost2)
				REPLACE ipost2 WITH -ipost
				=auditsay(5)
			ELSE
				=auditsay(8)
			ENDIF
		CASE ipost2=0 AND ipost<0 AND EMPTY(mpost) AND !INDEXSEEK(ABS(ipost), .F., "post", "ipost2") AND auditsay(7)
		CASE link.iLink<0 AND ipost2>=0 AND iuser#0 AND auditsay(5)
			\\	iuser # 0			<<iuser>>
			REPLACE iuser WITH 0
		CASE ipost2 = ABS(ipost) AND auditsay(5)
			\\	ipost2=ABS(ipost)	<<ipost2>>=<<ABS(ipost)>>
			REPLACE ipost2 WITH 0
		CASE ipost2<0 AND auditsay(5)
			\\	ipost2 < 0			<<ipost2>>
			REPLACE ipost2 WITH ABS(ipost2)
		CASE iPost<0 AND EMPTY(lPost) AND auditsay(5)
			\\	lpost <- ipost
			REPLACE lPost WITH .T.
		CASE iuser<0 AND auditsay(5)
			\\	-iUser
			REPLACE iUser WITH ABS(iUser)
		CASE iUser>0 AND !INDEXSEEK(iuser, .F., "user", "abs") AND auditsay(5)
			\\	User not found
			REPLACE iuser WITH 0
			IF iPost>0
				REPLACE iPost WITH -iPost
			ENDIF
		CASE iPost<0 AND iUser>0 AND auditsay(5)
			REPLACE iPost WITH -iPost
		CASE Link.iLink>0 AND ipost2>0 AND SEEK(ipost2, "post2")
			IF lzip # post2.lzip AND auditsay(5)
				\\	lzip <- post2.lzip
				REPLACE lzip WITH post2.lzip
			ENDIF
		ENDCASE
	ENDSCAN
*!*		поиск дублей
	SELECT ABS(post.ipost) AS ipost,post.icategory, CNT(1) AS ncount, MAX(post.lpost) AS lpost;
		FROM club!post;
		GROUP BY 1,2 HAVING ncount>1;
		INTO CURSOR C1 ORDER BY 1
	SCAN ALL FOR SEEK(ipost, "post", "abs")
		SELECT post
		IF icategory # c1.icategory
			LOCATE REST FOR ABS(ipost)=c1.ipost AND icategory=c1.icategory
		ENDIF
		IF c1.lpost=.T. AND lpost#.T.
			REPLACE lpost WITH .T.
		ENDIF
		SKIP
		SCAN REST FOR ABS(ipost) = c1.ipost AND icategory=c1.icategory
			=auditsay(4)
		ENDSCAN
	ENDSCAN
*!*		изменение перемещений постов
	SELECT ABS(post.ipost) AS ipost, p2.icategory;
		FROM club!post;
		INNER JOIN club!post AS p2 ON ABS(post.ipost) = p2.ipost2;
		WHERE YEAR(post.tpost)>2007 AND post.icategory <> p2.icategory;
		GROUP BY 1,2;
		INTO CURSOR C1 ORDER BY 1 DESC
	SCAN ALL
		SELECT post
		IF SEEK(c1.ipost, "post", "abs") AND auditsay(5)
*!*				IF icategory # c1.icategory
				\\	Move topic <<ipost>>	<<post.icategory>> -> <<c1.icategory>>
				REPLACE post.icategory WITH c1.icategory
*!*				ENDIF
*!*				SCAN FOR SEEK(c1.ipost, "post", "abs")
*!*					MoveTopic(ABS(ipost), c1.icategory)
*!*				ENDSCAN
		ENDIF
*!*			IF SEEK(c1.ip2, "post", "abs") AND auditsay(5)
*!*				IF icategory # c1.icategory
*!*					\\	Move topic <<ipost>>
*!*					REPLACE icategory WITH c1.icategory
*!*				ENDIF
*!*			ENDIF
	ENDSCAN
ENDIF
UNLOCK IN Post

SELECT favorite
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	SCAN ALL
		DO CASE
		CASE EMPTY(ifavorite) AND auditsay(8)
		CASE ifavorite>0 AND NOT INDEXSEEK(ifavorite, .F., "post2") AND auditsay(7)
		ENDCASE
		UNLOCK
	ENDSCAN
ENDIF
*!*	UNLOCK IN favorite

SELECT Blob
IF !EMPTY(RECCOUNT())
	=auditsay(10)
	STORE INIRead(_Screen.ini,"Main","BlobHistory") TO nn
	STORE IIF(!EMPTY(m.nn) AND BETWEEN(VAL(m.nn),-99,0), INT(VAL(m.nn)), -6) TO nn
	SCAN ALL
		DO CASE
		CASE IIF(EMPTY(iblob), .T., EMPTY(iMenu))
			=auditsay(8)
		CASE !EMPTY(m.nn) AND TTOD(tBlob)<GOMONTH(DATE(), m.nn)
			=auditsay(7)
		ENDCASE
	ENDSCAN
	SELECT iblob FROM club!blob WHERE iMenu NOT IN (SELECT iMenu FROM MainMenu);
		INTO CURSOR C1
	SCAN ALL FOR SEEK(iblob, "blob", "iblob")
		SELECT blob
		=auditsay(8)
	ENDSCAN
ENDIF
UNLOCK ALL

*!*	завершение процесса
=auditsay(9)
SET TEXTMERGE TO
SET TEXTMERGE OFF
DO CASE
CASE !FILE(m.cc)
CASE EMPTY(m.lParam)
	DO FORM AppEditTXT WITH (m.cc),"Протокол аудита данных",,.T.
	=AppErase(m.cc)
CASE EMPTY(_Screen.BlobJob)
	=AppErase(m.cc)
ENDCASE

FUNCTION auditsay
	LPARAMETERS nParam
	DO CASE
	CASE EMPTY(m.nParam)
		SET SECONDS ON
	\Старт: <<DTOC(DATE())>>; <<TIME()>>
		RETURN
*!*	CASE m.nParam=1
*!*	CASE m.nParam=2
*!*	CASE m.nParam=3
*!*		STORE m.e2+1 TO e2
*!*		\исправление записи невозможно
	CASE m.nParam=4 AND RLOCK()
		STORE m.d1+1 TO d1
		DELETE
	\удаление записи (дубликат идентификатора)
	CASE m.nParam=5 AND RLOCK()
		STORE m.e1+1 TO e1
	\исправление записи
	CASE m.nParam=5
		STORE m.e2+1 TO e2
	\исправление записи невозможно (нет доступа)
		RETURN .F.
	CASE INLIST(m.nParam,7,8) AND RLOCK()
		STORE m.d1+1 TO d1
		DELETE
		IF m.nParam=7
		\удаление устаревшей записи
		ELSE
		\удаление записи (пустой идентификатор)
		ENDIF
	CASE INLIST(m.nParam,4,7,8)
		STORE m.d2+1 TO d2
	\удаление записи невозможно (нет доступа)
		RETURN .F.
	CASE m.nParam=9
		SELECT 0
	\
	\Стоп: <<TIME()>>
	\
	\Итоги аудита:
	\Проверено таблиц		<<m.qq>>
	IF EMPTY(m.d1+m.d2+m.e1+m.e2)
	\Ошибок не найдено
	ELSE
	\Обнаружено ошибок		<<m.d1+m.d2+m.e1+m.e2>>
	ENDIF
	\Удалено записей		<<m.d1>>
	\Не удалось удалить		<<m.d2>>
	\Исправлено записей		<<m.e1>>
	\Не удалось исправить	<<m.e2>>
		SET SECONDS OFF
		RETURN
	CASE nParam=10
		STORE m.qq+1 TO qq
	\
	\Проверка таблицы <<ALIAS()>>	<<RECCOUNT()>>
		RETURN
	ENDCASE
\\<<STR(RECNO())>>
ENDFUNC

*!*	PROCEDURE MoveTopic(i2post, i2category)
*!*		DO WHILE i2post>0
*!*			SELECT ABS(post.ipost) AS ipost;
*!*				FROM club!post;
*!*				INNER JOIN club!category ON post.icategory=category.icategory;
*!*				WHERE post.ipost2=i2post AND post.icategory # i2category;
*!*				INTO CURSOR C2 ORDER BY 1
*!*			SCAN FOR SEEK(c2.ipost, "post", "abs")
*!*				SELECT post
*!*				\\	Move topic <<ipost>>
*!*				REPLACE icategory WITH i2category
*!*			ENDSCAN
*!*		ENDDO
