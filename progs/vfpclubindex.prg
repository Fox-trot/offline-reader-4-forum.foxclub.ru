LPARAMETERS lParam
=AppBlobJob(95)
CLOSE TABLES ALL
CLOSE DATABASES ALL
DO vfpclubDBC WITH .T.
LOCAL xx,yy,zz,nn,mm,aa,tt
LOCAL ARRAY ff[2]
STORE 0 TO xx,nn,mm,zz

WAIT WINDOW "Creating Indexes.." NOWAIT
aa = INT(SECONDS())
=AUSED(ff)
FOR yy=1 TO ALEN(ff)/2
	=AppProgressBar(yy, ALEN(ff)/2, "Reindex")
	SELECT ff(m.yy,1)
	IF ISEXCLUSIVE() AND !ISREADONLY()
		IF DISKSPACE(LEFT(DBF(),1))/1048576<2
			MESSAGEBOX("Недостаточно пространства для продолжения операции",48,"Индексация базы данных CLUB")
			EXIT
		ENDIF
		WAIT WINDOW ALIAS() + ":  " + LOWER(IIF(LEN(DBF()) > 42, '..'+RIGHT(DBF(), 40), DBF())) NOWAIT NOCLEAR
		STORE m.zz+1 TO zz
		STORE RECCOUNT() TO tt
		PACK
		STORE m.nn + m.tt - RECCOUNT() TO nn
		DO CASE
		CASE !EMPTY(TAGCOUNT())
			REINDEX
			STORE m.xx+1 TO xx
		CASE ALIAS()==[POST]
			INDEX ON ABS(ipost) TAG abs
			INDEX ON TTOD(tpost) TAG dpost ADDITIVE
			INDEX ON icategory TAG icategory ADDITIVE
			INDEX ON ipost2 TAG ipost2 ADDITIVE
			INDEX ON iuser TAG iuser ADDITIVE
			STORE m.xx+1 TO xx
		ENDCASE
		STORE m.mm + RECCOUNT() TO mm
	ENDIF
	USE
ENDFOR
aa = SECONDS()-m.aa
=AppProgressBar()
WAIT CLEAR
_Screen.Refresh
DO vfpclubDBC
IF EMPTY(lParam)
	MESSAGEBOX("Индексировано файлов"+STR(m.xx)+"/"+TRANSFORM(m.zz)+;
	CHR(13)+"Всего записей в таблицах"+STR(m.mm)+;
	IIF(EMPTY(m.nn), "", CHR(13)+"Удалено записей"+STR(m.nn))+;
	+CHR(13)+"Затрачено времени	"+Apps2c(m.aa), 64, _Screen.Caption)
ENDIF
