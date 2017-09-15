LPARAMETERS nParam
#DEFINE linelen 120
IF IIF(EMPTY(m.nParam), .T., NOT BETWEEN(m.nParam, 1, 12))
	RETURN .F.
ENDIF
IF EMPTY(_Screen.BlackList)
	SELECT VAL(RIGHT(MLINE(user.muser, 6),2)) AS nDay, user.cuser, PADR(MLINE(user.muser,2),linelen) AS cFIO,;
		PADR(MLINE(user.muser,1), linelen) AS cEmail,;
		PADR(MLINE(user.muser, 3), linelen) AS ICQ,;
		PADR(MLINE(user.muser, 8), linelen) AS Skype,;
		user.iuser;
		FROM club!user;
		WHERE ABS(user.iuser)>0 AND user.duser>{};
		AND EMPTY(user.muser)=.F. AND VAL(LEFT(MLINE(user.muser, 6),2))=m.nParam;
		AND BETWEEN(VAL(RIGHT(MLINE(user.muser, 6),2)), 1, 31)=.T.;
		INTO CURSOR R1;
		ORDER BY 1,2
ELSE
	SELECT VAL(RIGHT(MLINE(user.muser, 6),2)) AS nDay, user.cuser, PADR(MLINE(user.muser,2),linelen) AS cFIO,;
		PADR(MLINE(user.muser,1), linelen) AS cEmail,;
		PADR(MLINE(user.muser, 3), linelen) AS ICQ,;
		PADR(MLINE(user.muser, 8), linelen) AS Skype,;
		user.iuser;
		FROM club!user;
		WHERE user.iuser>0 AND user.duser>{};
		AND EMPTY(user.muser)=.F. AND VAL(LEFT(MLINE(user.muser, 6),2))=m.nParam;
		AND BETWEEN(VAL(RIGHT(MLINE(user.muser, 6),2)), 1, 31)=.T.;
		INTO CURSOR R1;
		ORDER BY 1,2
ENDIF
IF EMPTY(RECCOUNT())
	RETURN .F.
ENDIF
LOCAL rr, yy, ii
LOCAL ARRAY aa(FCOUNT())
_SCREEN.oXS=CREATEOBJECT("EXCEL.SHEET")
DO appExcel WITH 6
WITH _SCREEN.oXS.Sheets(1)
	.NAME=CMONTH(DATE(2000,m.nParam,1))
	WITH .COLUMNS(1)
		.COLUMNWIDTH=7
		.FONT.Bold=1
		.HorizontalAlignment = 3
	ENDWITH
	.COLUMNS(2).COLUMNWIDTH=22
	.COLUMNS("C:D").COLUMNWIDTH=38
	.Columns("E:F").COLUMNWIDTH=12
	.COLUMNS("B:F").WrapText=1
	.RANGE("A1:F1").merge
	.Cells(1,1).VALUE="Список именинников ("+cmonthr(DATE(2000,m.nParam,1))+")"
	.Cells(2,1).VALUE="День"
	.Cells(2,2).VALUE="Ник"
	.Cells(2,3).VALUE="Ф.И.О."
	.Cells(2,4).VALUE="E-Mail"
	.Cells(2,5).VALUE="ICQ"
	.Cells(2,6).VALUE="Skype"
	DO appExcel WITH 7, "A2:F2"
	STORE 3 TO rr
	_SCREEN.livewallpaper.StopStart("Формирование отчета")
	DO WHILE !EOF()
		SCATTER TO aa
		STORE aa(1) TO yy, .Cells(rr,1).VALUE
		DO WHILE aa(1)=m.yy &&AND !EOF()
			FOR ii=2 TO 6
				IF !EMPTY(aa(ii))
					.Cells(rr,ii).VALUE=ALLTRIM(aa(ii))
				ENDIF
			ENDFOR
			STORE rr+1 TO rr
			SKIP
			SCATTER TO aa
		ENDDO
		=AppProgressBar(RECNO(), RECCOUNT(), "Printing")
		IF _SCREEN.lStop
			EXIT
		ENDIF
	ENDDO
	.Cells(m.rr+1,1).VALUE='Итого'
	.Cells(m.rr+1,2).VALUE=m.rr-2
	.ROWS(TRANSFORM(m.rr+1)+":"+TRANSFORM(m.rr+1)).FONT.Bold=1
	DO appExcel WITH 10, m.rr+2
ENDWITH
_SCREEN.livewallpaper.StopStart()
