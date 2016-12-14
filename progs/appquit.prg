*!*	ON ERROR DO Appquit	&&WAIT WINDOW 'QUIT' NOWAIT
*!*	IF WEXIST('Report Designer -')
*!*		KEYBOARD '{ESCAPE}'
*!*	ENDIF
=CloseFormAll()
*!*	IF !EMPTY(_Screen.FormCount)
*!*		KEYBOARD '{ENTER}'
*!*		_Screen.Forms(1).Release
*!*	ENDIF
CLEAR EVENTS ALL
*!*			Доступно_оперативной_памяти = VAL(SYS(1001))/4124000
*!*			Использовано_памяти = VAL(SYS(1016))/1000
*!*			_RECNO=RECNO()
*!*			_RECCOUNT=RECCOUNT()
*!*			_USED=USED()
*!*			LIST MEMORY NOCONSOLE TO FILE (_Screen.Comment+TTOC(DATETIME(),1)+".err")
ON SHUTDOWN
*!*	CLOSE ALL
QUIT
