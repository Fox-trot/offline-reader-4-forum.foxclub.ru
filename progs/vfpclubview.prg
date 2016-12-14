LPARAMETERS nParam, uParam, lParam
DO CASE
CASE m.nParam=4 AND EMPTY(m.uParam)
	DO FORM AddName TO uParam WITH "Введите ID сообщения"
	IF IIF(EMPTY(m.uParam), .F., !EMPTY(INT(VAL(m.uParam))))
		=vfpclubdbf(2)
		SELECT post
		IF SEEK(INT(VAL(m.uParam)), "post", "abs") &&AND SEEK(post.icategory, "category", "icategory") && AND SEEK(post.icategory, "link", "icategory") AND link.ilink>0
			DO vfpclubview WITH 4, INT(VAL(m.uParam))
		ELSE
			MESSAGEBOX("Сообщение не найдено "+m.uParam, 16, PROMPT(), _Screen.MBTimeout)
		ENDIF
	ENDIF
CASE VARTYPE(_Screen.aview(m.nParam))="O"
	WITH _Screen.aview(m.nParam)
		IF BETWEEN(m.nParam,1,4)
			.uMethod(m.uParam, m.lParam)
		ENDIF
		.Show
	ENDWITH
CASE m.nParam=5
	DO FORM appcalendar04 NAME _Screen.aview(m.nParam)
CASE m.nParam=6 AND _Screen.Windows98
	nParam = _Screen.WinDir+"winpopup.exe"
	IF !FILE(m.nParam)
		MESSAGEBOX("Функция недоступна", 16, OS(), _Screen.MBTimeout)
	ELSE
		nParam = _Screen.WinDir+"winpopup.exe"
		RUN /N2 START &nParam
	ENDIF
CASE m.nParam=6
	DO FORM apppopup01 NAME _Screen.aview(m.nParam)
CASE EMPTY(m.uParam)
CASE m.nParam=1
	DO FORM vfpclubcategory01v NAME _Screen.aview(m.nParam) WITH m.uParam, m.lParam
CASE m.nParam=2
	DO FORM vfpclubuser01v NAME _Screen.aview(m.nParam) WITH m.uParam, m.lParam
CASE m.nParam=3
	DO FORM vfpclublink01v NAME _Screen.aview(m.nParam) WITH m.uParam, m.lParam
CASE m.nParam=4
	DO FORM "vfpclubpost0"+IIF(_Screen.PostViewer>10, "2v", "1v") NAME _Screen.aview(m.nParam) WITH m.uParam
*!*	OTHERWISE
*!*		MESSAGEBOX("На стадии разработки",16,_Screen.Caption,_Screen.MBTimeout)
ENDCASE

EXTERNAL FORM vfpclubpost01v, vfpclubpost02v
