LPARAMETER nParam, lParam
STORE IIF(EMPTY(m.nParam), 0, m.nParam) TO nParam
IF m.nParam#8
	=CloseFormAll()
ENDIF
LOCAL Ok,cc
WITH _Screen
	DO CASE
	CASE !INLIST(m.nParam,0,8) AND CloseFormAll() AND !EMPTY(.FormCount)
		MESSAGEBOX("Следует закрыть все окна",48,.Caption,.MBTimeout)
	CASE EMPTY(m.nParam)							&&	E X I T
		IF IIF(EMPTY(.NoConfirmOnExit),MESSAGEBOX([Вы действительно хотите]+CHR(13)+[выйти из программы?],289,.Caption, .MBTimeout)=1,.T.)
			.oXMLDoc = .F.
			=AppDelBak(_Screen.ImportPath), "~*.htm")
			=AppBlobJob(90112)
			DO AppQUIT
		ENDIF
	CASE m.nParam=1										&&	LOGIN - авторизация
		=AppBlobJob(90110)
		DO VfpClubLogin
	CASE m.nParam=2										&&	ZIP - архивация сообщений
		DO FORM VfpClubZip01 TO Ok
		IF !EMPTY(m.Ok)
			Ok=VfpClubZip(m.Ok)
			MESSAGEBOX("Итого сообщений"+STR(m.Ok), 48+16*MIN(1, m.Ok), "Архивация cообщений", .MBTimeout)
		ENDIF
	CASE m.nParam=3							&&	управление таблицами
		=AppBlobJob(94)
		CLOSE TABLES ALL
		CLOSE DATABASES ALL
		DO FORM TestSetup03 WITH "CLUB"
		DO vfpclubDBC
	CASE m.nParam=4									&& настройка интерфейсa
		DO FORM AppSetup02 TO ok
		IF !EMPTY(m.ok)
			=AppBlobJob(114)
		ENDIF
	CASE BETWEEN(m.nParam,5,7)			&&	импорт данных
		cc=GETDIR(.ImportPath2,IIF(m.nParam=7, "Слияние данных", "Импорт сообщений"),"Выбор папки")
		IF !EMPTY(m.cc)
			STORE ADDBS(m.cc) TO cc
			STORE IIF(m.nParam=7, vfpclubimport03(m.cc), IIF(m.nParam=6, vfpclubimport02(m.cc), vfpclubimport01(m.cc))) TO Ok
			MESSAGEBOX("Итого новых сообщений"+STR(m.Ok), 48+16*MIN(1, m.Ok), IIF(m.nParam=7, "Слияние данных", "Импорт сообщений"), .MBTimeout)
			IF !EMPTY(m.Ok)
				STORE m.cc TO .ImportPath2
				IF m.nParam#7
					=INIWrite(.ini,"Main","ImportPath2",m.cc)
				ENDIF
			ENDIF
		ENDIF
	CASE m.nParam=8						&&	синхронизация
		IF IIF(.InternetInUse=2 AND !EMPTY(.NormalMode), MESSAGEBOX("Произвести синхронизацию данных"+CHR(13)+"Это займет некоторое время",33,.Caption, .MBTimeout)=1, .T.)
			cc=INT(SECONDS())
			ok = vfpclubDownLoadRSS(.T.)
			cc = SECONDS()-m.cc
			DO CASE
			CASE EMPTY(m.ok)
				MESSAGEBOX("Загружено сообщений	0", 48, "Синхронизация", .MBTimeout)
			CASE m.ok<0
				MESSAGEBOX("Выберите хотя бы одну ссылку", 16, "Синхронизация", .MBTimeout)
			OTHERWISE
				MESSAGEBOX("Загружено сообщений"+STR(Ok)+CHR(13)+"Затрачено времени	"+Apps2c(m.cc), 64, "Синхронизация", .MBTimeout)
			ENDCASE
		ENDIF
	CASE m.nParam=9							&&	аудит данных
		IF IIF(EMPTY(.NormalMode), .T., MESSAGEBOX("Произвести аудит данных"+CHR(13)+"Это займет некоторое время",289,.Caption, .MBTimeout)=1)
			DO vfpclubAudit &&WITH m.lParam
		ENDIF
	CASE m.nParam=10							&&	параметры работы проги
		DO FORM vfpclubSetup01 TO ok
		IF !EMPTY(m.ok)
			=AppBlobJob(115)
		ENDIF
	CASE m.nParam=11							&&	BlobJob = протокол работы программы
		DO FORM AppBlob03
		=AppBlobJob(97)
	CASE m.nParam=12							&&	индексация
		IF IIF(EMPTY(.NormalMode), .T., MESSAGEBOX("Произвести индексацию таблиц"+CHR(13)+"Это займет некоторое время",289,.Caption, .MBTimeout)=1)
			DO vfpclubindex &&WITH m.lParam
		ENDIF
*!*		CASE m.nParam=110			&&	экспорт данных
	OTHERWISE
		MESSAGEBOX("На стадии разработки",16,.Caption, .MBTimeout)
	ENDCASE
ENDWITH
SELECT 0
