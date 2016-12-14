LPARAMETERS nParam
#DEFINE excelmaxrows 65500-4
#DEFINE sobaka "@"
IF EMPTY(_Screen.BlackList)
	SELECT DISTINCT iuser, SOUNDEX(cuser) AS cAlfa;
		FROM club!user;
		WHERE ABS(user.iuser)>0 AND user.duser>{};
		AND EMPTY(user.cuser)=.F. AND AT(sobaka, MLINE(user.muser,1))+VAL(MLINE(user.muser,3))>1000000;
		INTO CURSOR R1;
		ORDER BY 2
ELSE
	SELECT DISTINCT iuser, SOUNDEX(cuser) AS cAlfa;
		FROM club!user;
		WHERE user.iuser>0 AND user.duser>{};
		AND EMPTY(user.cuser)=.F. AND AT(sobaka, MLINE(user.muser,1))+VAL(MLINE(user.muser,3))>1000000;
		INTO CURSOR R1;
		ORDER BY 2
ENDIF
IF EMPTY(RECCOUNT())
	RETURN .F.
ENDIF
_SCREEN.oXS=CREATEOBJECT("EXCEL.SHEET")
DO appExcel WITH 6
LOCAL rr
WITH _SCREEN.oXS.Sheets(1)
	.NAME="Контакты"
	.COLUMNS(1).COLUMNWIDTH=22
	.COLUMNS("B:C").COLUMNWIDTH=36
	.COLUMNS("D:E").COLUMNWIDTH=10
	.COLUMNS("B:C").WrapText=1
	.RANGE("A1:E1").merge
	.Cells(1,1).VALUE="Список контактов"
	.Cells(2,1).VALUE="Ник"
	.Cells(2,2).VALUE="Ф.И.О."
	.Cells(2,3).VALUE="E-Mail"
	.Cells(2,4).VALUE="ICQ"
	.Cells(2,5).VALUE="FoxClub.ru ID"
	DO appExcel WITH 7, "A2:E2"
	STORE 3 TO rr
	_SCREEN.livewallpaper.StopStart("Формирование отчета")
	SCAN FOR SEEK(iuser, "user", "abs")
		=AppProgressBar(RECNO(), RECCOUNT(), "Printing")
		IF IIF(_SCREEN.lStop, .T., RECNO()=>excelmaxrows)
			EXIT
		ENDIF
		.Cells(m.rr,1).VALUE=RTRIM(user.cuser)
		IF !EMPTY(MLINE(user.muser,2))
			.Cells(m.rr,2).VALUE=MLINE(user.muser,2)
		ENDIF
		IF AT(sobaka, MLINE(user.muser,1))>0
			.Cells(m.rr,3).VALUE=MLINE(user.muser,1)
		ENDIF
		IF !EMPTY(MLINE(user.muser,3))
			.Cells(m.rr,4).VALUE=MLINE(user.muser,3)
		ENDIF
		IF !EMPTY(user.nuser)
			.Cells(m.rr,5).VALUE=ABS(user.nuser)
		ENDIF
		STORE m.rr+1 TO rr
	ENDSCAN
	.Cells(m.rr+1,1).VALUE='Итого'
	.Cells(m.rr+1,2).VALUE=m.rr-2
	.ROWS(TRANSFORM(m.rr+1)+":"+TRANSFORM(m.rr+1)).FONT.Bold=1
	DO appExcel WITH 10, m.rr+2
ENDWITH
_SCREEN.livewallpaper.StopStart()
