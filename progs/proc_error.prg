PARAMETERS nErrNumber, cErrMsg, cErrLine, cErrModule, cCurAlias, cTopWin, cErrDet, nErrLine
#DEFINE eror "Ошибка"
IF EMPTY(PCOUNT())
	ON ERROR DO proc_error WITH ERROR(),MESSAGE(),MESSAGE(1),SYS(16),ALIAS(),WONTOP(),SYS(2018),LINENO()
ELSE
	IF nErrNumber= 231	&&,1733
		RETURN
	ENDIF
	LOCAL nChoice, cNewMsg
	STORE 7 TO nChoice
	STORE cErrMsg +;
	+IIF(EMPTY(cErrLine), "", CHR(13) + cErrLine);
	+IIF(EMPTY(_Screen.NormalMode), CHR(13)+"Модуль: "+cErrModule, "");
	+IIF(EMPTY(nErrLine), "", CHR(13)+'Строка'+STR(nErrLine));
	+IIF(EMPTY(cCurAlias), "", CHR(13)+"Alias: "+cCurAlias);
	+IIF(EMPTY(ALLTRIM(cTopWin)), "", CHR(13)+cTopWin);
	+IIF(EMPTY(ALLTRIM(cErrDet)), "", CHR(13)+cErrDet)+CHR(13);
	TO cNewMsg
	WAIT CLEAR
	CLEAR TYPEAHEAD
	IF nErrNumber=1429
		MESSAGEBOX(cErrMsg, 48, eror + STR(nErrNumber))
		RETURN TO MASTER
	ENDIF
	_Screen.Visible=.T.

	DO CASE
*!*	CASE nErrNumber= 1494 AND !EMPTY(ALIAS())
*!*		nChoice = ALIAS()
*!*		USE
*!*		USE (IIF(EMPTY(DBC()),'',DBC()+'!')+nChoice)
*!*		RETURN
	CASE INLIST(nErrNumber,124,125,1523,1915) OR BETWEEN(nErrNumber,1955,1958)
		nChoice = MESSAGEBOX(cErrMsg, 48, eror + STR(nErrNumber))
	CASE INLIST(nErrNumber,5,683,1707,1879)
		MESSAGEBOX(cNewMsg+"Возможно требуется индексация таблиц", 16, eror + STR(nErrNumber))
		nChoice = IIF(INLIST(nErrNumber,5,1707), 1, 77)
	CASE INLIST(nErrNumber,1,15,41,55,1102,1104,1105,1106,1162,1534,1558,1561,1578,1584) OR BETWEEN(nErrNumber, 1550, 1554)
		nChoice = MESSAGEBOX(cNewMsg + "Файл не найден или разрушен", 16, eror + STR(nErrNumber))+76
	CASE INLIST(nErrNumber,3,56,108,109,1569,1705,1709)
		nChoice = MESSAGEBOX(cNewMsg + "Нет доступа. Повторить попытку", 273, eror + STR(nErrNumber))
		IF nChoice = 1
			RETRY
		ELSE
			STORE 77 TO nChoice
		ENDIF
	CASE INLIST(nErrNumber,67,1309,1924)
		nChoice = MESSAGEBOX(cNewMsg + "Ошибка приложения", 48, eror + STR(nErrNumber))
	CASE INLIST(nErrNumber,12,36,107)
		nChoice = MESSAGEBOX(cErrMsg + CHR(13) + "Обратитесь к разработчику", 16, eror + STR(nErrNumber))+76
	CASE nErrNumber = 38
		nChoice = MESSAGEBOX(cNewMsg, 16, eror + STR(nErrNumber))
		GO TOP
		SKIP
		RETRY
	CASE nErrNumber = 1526
		nChoice = MESSAGEBOX(cNewMsg, 16, eror + STR(nErrNumber))+6
	CASE nErrNumber = 1585
		nChoice = MESSAGEBOX(cNewMsg + "Данные редактируются другим пользователем"+CHR(13)+"Сохранить изменения?", 33, eror + STR(nErrNumber))
		IF nChoice = 1
			BEGIN TRANSACTION
			IF TABLEUPDATE(.T., .T.)
				END TRANSACTION
			ELSE
				ROLLBACK
			ENDIF
		ELSE
			=TABLEREVERT(.T.)
		ENDIF
	CASE nErrNumber=1959
		WAIT WINDOW cErrMsg +CHR(13)+ eror + STR(nErrNumber) NOWAIT
		RETURN
	CASE INLIST(nErrNumber,1966,1967)
		nChoice=MESSAGEBOX(cNewMsg+"Ошибка выполнения или доступа к файлам. Продолжить?", 20, eror + STR(nErrNumber))
	CASE nErrNumber=1990
		nChoice = MESSAGEBOX("Прервано пользователем", 16, eror + STR(nErrNumber))+76
	OTHERWISE
		nChoice = MESSAGEBOX(cNewMsg+"Обратитесь к администратору/разработчику", 16, eror + STR(nErrNumber))+76
	ENDCASE

	IF nChoice = 7 OR nChoice = 77
		Доступно_оперативной_памяти = VAL(SYS(1001))/4124000
		Использовано_памяти = VAL(SYS(1016))/1000
		_RECNO=RECNO()
		_RECCOUNT=RECCOUNT()
		_USED=USED()
		_ALIAS=ALIAS()
		_DBF=DBF()
		=AUSED(myAlias)
		WITH _Screen
			LIST MEMORY NOCONSOLE TO FILE (.Comment+TTOC(DATETIME(),1)+".err")
			LOCAL iii
			IF TYPE("_Screen.NoConfirmOnExit")="U"
				.AddProperty("NoConfirmOnExit",1)
			ENDIF
			IF TYPE("_Screen.AccessLevel")="U"
				.AddProperty("AccessLevel",0)
			ENDIF
			STORE 0 TO .AccessLevel
			IF !EMPTY(.FormCount)
				FOR iii = 1 TO .FormCount
					.Show
					.Forms(1).Release
				ENDFOR
			ENDIF
		ENDWITH
		IF nChoice = 77
			DO AppQuit
		ENDIF
		KEYBOARD "{F10}"+"{RIGHTMOUSE}"
		RETURN TO MASTER
	ENDIF
ENDIF
