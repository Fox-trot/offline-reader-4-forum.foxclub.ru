LPARAMETERS nParam
#DEFINE sobaka "@"
IF EMPTY(_Screen.BlackList)
	SELECT TOP 65496 DISTINCT IIF(user.iuser2=0,user.iuser,user.iuser2) AS iUser, SOUNDEX(NVL(user2.cuser,user.cuser)) AS cAlfa;
		FROM club!user;
		LEFT JOIN club!user AS user2 ON user.iuser2 = ABS(user2.iuser);
		WHERE ABS(user.iuser)>0 AND NVL(user2.duser,user.duser)>{};
		AND EMPTY(NVL(user2.cuser,user.cuser))=.F. AND (AT(sobaka, MLINE(user.muser,1))>1 OR VAL(MLINE(user.muser,3))>1000000 OR AT(sobaka, MLINE(user2.muser,1))>1 OR VAL(MLINE(user2.muser,3))>1000000);
		INTO CURSOR R1;
		ORDER BY 2
ELSE
	SELECT TOP 65496 DISTINCT IIF(user.iuser2=0,user.iuser,user.iuser2) AS iUser, SOUNDEX(NVL(user2.cuser,user.cuser)) AS cAlfa;
		FROM club!user;
		LEFT JOIN club!user AS user2 ON user.iuser2 = user2.iuser;
		WHERE user.iuser>0 AND NVL(user2.duser,user.duser)>{};
		AND EMPTY(NVL(user2.cuser,user.cuser))=.F. AND (AT(sobaka, MLINE(user.muser,1))>1 OR VAL(MLINE(user.muser,3))>1000000 OR AT(sobaka, MLINE(user2.muser,1))>1 OR VAL(MLINE(user2.muser,3))>1000000);
		INTO CURSOR R1;
		ORDER BY 2
ENDIF
IF EMPTY(RECCOUNT())
	RETURN .F.
ENDIF
_SCREEN.oXS=CREATEOBJECT("EXCEL.SHEET")
DO appExcel WITH 6
LOCAL rr
LOCAL ARRAY aa(5)
WITH _SCREEN.oXS.Sheets(1)
	.NAME="Контакты"
	.COLUMNS(1).COLUMNWIDTH=22
	.COLUMNS("B:C").COLUMNWIDTH=36
	.COLUMNS("D:E").COLUMNWIDTH=11
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
	SCAN FOR SEEK(iuser, "user", "abs") OR SEEK(iuser, "user", "iuser2")
		=AppProgressBar(RECNO(), RECCOUNT(), "Printing")
		STORE "" TO aa
		aa(1)=RTRIM(user.cuser)
		IF !EMPTY(MLINE(user.muser,2))
			aa(2)=MLINE(user.muser,2)
		ENDIF
		IF AT(sobaka, MLINE(user.muser,1))>0
			aa(3)=MLINE(user.muser,1)
		ENDIF
		IF !EMPTY(MLINE(user.muser,3))
			aa(4)=MLINE(user.muser,3)
		ENDIF
		IF !EMPTY(user.nuser)
			aa(5)=ABS(user.nuser)
		ENDIF
		IF SEEK(iuser, "user", "iuser2") OR SEEK(iuser, "user", "abs")
			aa(1)=RTRIM(user.cuser)
			IF EMPTY(aa(2)) AND !EMPTY(MLINE(user.muser,2))
				aa(2)=MLINE(user.muser,2)
			ENDIF
			IF EMPTY(aa(3)) AND AT(sobaka, MLINE(user.muser,1))>0
				aa(3)=MLINE(user.muser,1)
			ENDIF
			IF EMPTY(aa(4)) AND !EMPTY(MLINE(user.muser,3))
				aa(4)=MLINE(user.muser,3)
			ENDIF
			IF !EMPTY(user.nuser)
				aa(5)=ABS(user.nuser)
			ENDIF
		ENDIF
		FOR ii=1 TO 5
			IF !EMPTY(aa(ii))
				.Cells(m.rr,ii).VALUE=aa(ii)
			ENDIF
		ENDFOR

		STORE m.rr+1 TO rr
	ENDSCAN
	.Cells(m.rr+1,1).VALUE='Итого'
	.Cells(m.rr+1,2).VALUE=m.rr-2
	.ROWS(TRANSFORM(m.rr+1)+":"+TRANSFORM(m.rr+1)).FONT.Bold=1
	DO appExcel WITH 10, m.rr+2
ENDWITH
_SCREEN.livewallpaper.StopStart()
