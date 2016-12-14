LPARAMETERS nParam
#DEFINE MAXLASTAREA 13
LOCAL ii, nArea
STORE SELECT() TO nArea
STORE IIF(EMPTY(m.nParam), 0, m.nParam) TO nParam
*!*	ON ERROR *
FOR ii=1 TO MAXLASTAREA
	SELECT 0
	DO CASE
	CASE m.ii=1 AND !USED("post")
		USE club!post
	CASE m.ii=2 AND !USED("user")
		USE club!user
	CASE m.ii=3 AND !USED("link2")
		USE club!link2
	CASE m.ii=4 AND !USED("link")
		USE club!link
	CASE m.ii=5 AND !USED("category")
		USE club!category
	CASE m.ii=6 AND !USED("quote")
		USE club!quote
	CASE m.ii=7 AND !USED("blob")
		USE club!blob
	CASE m.ii=8 AND !USED("favorite")
		USE club!favorite
	CASE EMPTY(m.nParam)

	CASE m.ii=9 AND !USED("user02")
		USE club!user02 NODATA
	CASE m.ii=10 AND !USED("mainmenu")
		USE clubMainMenu ALIAS MainMenu AGAIN NOUPDATE
	CASE m.ii=11 AND !USED("rus")
		USE rus AGAIN NOUPDATE
	CASE m.ii=12 AND m.nParam=2 AND !USED("post2")
		USE club!post ALIAS post2 AGAIN ORDER abs
	CASE m.ii=13 AND m.nParam=2 AND !USED("fdkeywrd") AND FILE("fdkeywrd.cdx") AND FILE("fdkeywrd.dbf") AND JUSTPATH(LOCFILE("fdkeywrd.cdx"))==JUSTPATH(LOCFILE("fdkeywrd.dbf"))
		USE fdkeywrd AGAIN ORDER token
	OTHERWISE
		LOOP
	ENDCASE
*!*		ON ERROR DO proc_error
	IF m.nParam<2 AND !EMPTY(ALIAS()) AND m.ii<=ALEN(_Screen.aDBF)
		IF m.nParam=1 AND !EMPTY(RECCOUNT())
			=AppDBF4d(2)
		ENDIF
		IF EMPTY(CPDBF())
			IF ISEXCLUSIVE()
				DO CPZero WITH CPCURRENT(1)
			ELSE
				WAIT WINDOW "Для таблицы "+RIGHT(DBF(),40)+CHR(13)+"установите кодовую страницу"+STR(CPCURRENT(1)) NOWAIT
			ENDIF
		ENDIF
	ENDIF
	IF m.nParam=1
		=AppProgressBar(m.ii, MAXLASTAREA, "Opening data")
	ENDIF
ENDFOR
=AppProgressBar()
SELECT (m.nArea)

EXTERNAL TABLE clubMainMenu, rus