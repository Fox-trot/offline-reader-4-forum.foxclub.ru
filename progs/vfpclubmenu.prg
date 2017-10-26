LPARAMETERS nParam
*!*	cFont  = "FONT _Screen.FontName, _Screen.FontSize"
SET SYSMENU TO
SET SYSMENU AUTOMATIC
ON SHUTDOWN DO vfpclubSystem
LOCAL cc
SELECT iMenu,cMenu,cMenu2;
	FROM MainMenu;
	WHERE MainMenu.iMenu2=0;
	ORDER BY 1 INTO CURSOR C1
STORE 0 TO nParam
*!*			формирование заголовков меню
LOCATE ALL FOR BETWEEN(iMenu,1,20)
IF FOUND()
	DEFINE PAD Mag OF _MSYSMENU PROMPT "\<Форумы" MESSAGE "Просмотр сообщений форумов"
	ON PAD Mag OF _MSYSMENU ACTIVATE POPUP Mag
	DEFINE POPUP Mag MARGIN RELATIVE
ELSE
	GO TOP
ENDIF
LOCATE REST FOR BETWEEN(iMenu,21,40)
IF FOUND()
	DEFINE PAD Eye OF _MSYSMENU PROMPT "\<Графики" MESSAGE "Просмотр графиков, диаграмм"
	ON PAD Eye OF _MSYSMENU ACTIVATE POPUP Eye
	DEFINE POPUP Eye MARGIN RELATIVE
ELSE
	GO TOP
ENDIF
LOCATE REST FOR BETWEEN(iMenu,41,60)
IF FOUND()
	DEFINE PAD Rep OF _MSYSMENU PROMPT "Отчет\<ы" MESSAGE "Просмотр и печать отчетов"
	ON PAD Rep OF _MSYSMENU ACTIVATE POPUP Rep
	DEFINE POPUP Rep MARGIN RELATIVE
ELSE
	GO TOP
ENDIF
LOCATE REST FOR BETWEEN(iMenu,61,90)
IF FOUND()
	DEFINE PAD Lib OF _MSYSMENU PROMPT "\<Справочники" MESSAGE "Ведение справочников"
	ON PAD Lib OF _MSYSMENU ACTIVATE POPUP Lib
	DEFINE POPUP Lib MARGIN RELATIVE
ELSE
	GO TOP
ENDIF
LOCATE REST FOR BETWEEN(iMenu,91,110)
IF FOUND()
	DEFINE PAD Service OF _MSYSMENU PROMPT "С\<ервис" MESSAGE "Настройка программы, обслуживание базы данных.."
	ON PAD Service OF _MSYSMENU ACTIVATE POPUP Service
	DEFINE POPUP Service MARGIN RELATIVE
ENDIF

SCAN ALL
	DO CASE
	CASE BETWEEN(iMenu,5,6) AND BETWEEN(nParam, 1, 3)
		DEFINE BAR 4 OF Mag PROMPT "\-"
	CASE iMenu=8 AND BETWEEN(nParam, 1, 6) AND EMPTY(_Screen.FoxClubRSSonly)
		DEFINE BAR 7 OF Mag PROMPT "\-"

	CASE BETWEEN(iMenu,24,24) AND BETWEEN(nParam, 21, 22)
		DEFINE BAR 23 OF Eye PROMPT "\-"
	CASE BETWEEN(iMenu,26,27) AND BETWEEN(nParam, 21, 24)
		DEFINE BAR 25 OF Eye PROMPT "\-"
	CASE BETWEEN(iMenu,29,31) AND BETWEEN(nParam, 21, 27)
		DEFINE BAR 28 OF Eye PROMPT "\-"
	CASE iMenu=33 AND BETWEEN(nParam, 21, 31)
		DEFINE BAR 32 OF Eye PROMPT "\-"
	CASE iMenu=35 AND BETWEEN(nParam, 21, 33)
		DEFINE BAR 34 OF Eye PROMPT "\-"

	CASE iMenu=64 AND BETWEEN(nParam, 61, 62)
		DEFINE BAR 63 OF Lib PROMPT "\-"
	CASE BETWEEN(iMenu,66,67) AND BETWEEN(nParam, 61, 64)
		DEFINE BAR 65 OF Lib PROMPT "\-"

	CASE BETWEEN(iMenu,94,95) AND BETWEEN(nParam, 91, 92)
		DEFINE BAR 93 OF Service PROMPT "\-"
	CASE BETWEEN(iMenu,94,97) AND BETWEEN(nParam, 91, 95)
		DEFINE BAR 96 OF Service PROMPT "\-"
	CASE BETWEEN(iMenu,99,100) AND BETWEEN(nParam, 91, 100)
		DEFINE BAR 98 OF Service PROMPT "\-"
	CASE BETWEEN(iMenu,102,105) AND BETWEEN(nParam, 91, 100)
		DEFINE BAR 101 OF Service PROMPT "\-"
	CASE BETWEEN(iMenu,107,110) AND BETWEEN(nParam, 91, 105)
		DEFINE BAR 106 OF Service PROMPT "\-"
	CASE BETWEEN(iMenu,114,115) AND BETWEEN(nParam, 91, 110)
		DEFINE BAR 113 OF Service PROMPT "\-"
	ENDCASE
	DO CASE
	CASE iMenu=1
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) KEY F2 MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubdoc WITH 1
	CASE iMenu=2
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _MED_FIND) KEY F3 MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubdoc WITH 2
	CASE iMenu=3
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) KEY Shift+F3,"Shift+F3" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubview WITH 4
	CASE iMenu=5 AND !EMPTY(_Screen.Days4Zip)
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) SKIP FOR EMPTY(_Screen.Days4Zip) KEY Ctrl+F2,"Ctrl+F2" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubdoc WITH 4
	CASE iMenu=6
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) KEY Shift+F2,"Shift+F2" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubdoc WITH 5
	CASE iMenu=8 AND EMPTY(_Screen.FoxClubRSSonly)
		DEFINE BAR iMenu OF Mag PROMPT ALLTRIM(cMenu) SKIP FOR _Screen.PostViewer<10 KEY F12 MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Mag DO vfpclubdoc WITH 6

	CASE iMenu=21
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 1
	CASE iMenu=22
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 2
	CASE iMenu=23 AND !EMPTY(_Screen.FoxClubRSSonly)
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) SKIP FOR EMPTY(_Screen.FoxClubRSSonly) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 18
	CASE iMenu=24
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 4
	CASE iMenu=26
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 5
	CASE iMenu=27
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 6
	CASE iMenu=29
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 7
	CASE iMenu=30
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 8
	CASE iMenu=31
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) KEY Shift+F4,"Shift+F4" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 9, RIGHT(DTOS(DATE()),4)
	CASE iMenu=33
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 16
	CASE iMenu=35
		DEFINE BAR iMenu OF Eye PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Eye DO vfpclubeye WITH 17

	CASE iMenu=41
		DEFINE BAR iMenu OF Rep PROMPT ALLTRIM(cMenu) SKIP FOR BETWEEN(_Screen.Excel97,.1,7) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Rep DO vfpclubReport WITH 41
	CASE iMenu=42
		DEFINE BAR iMenu OF Rep PROMPT ALLTRIM(cMenu) SKIP FOR BETWEEN(_Screen.Excel97,.1,7) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Rep DO vfpclubReport WITH 42

	CASE iMenu=61
		DEFINE BAR iMenu OF Lib PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Lib DO vfpclubLib WITH 1
	CASE iMenu=62
		cc = IIF(EMPTY(_Screen.ImageMenu), "", "PICTURE 'u2.ico'")
		DEFINE BAR iMenu OF Lib PROMPT ALLTRIM(cMenu) &cc KEY F4,"F4" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Lib DO vfpclubLib WITH 2
	CASE iMenu=64
		cc = IIF(EMPTY(_Screen.ImageMenu), "", "PICTURE 'internet.ico'")
		DEFINE BAR iMenu OF Lib PROMPT ALLTRIM(cMenu) &cc MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Lib DO vfpclubLib WITH 3
	CASE iMenu=66
		DEFINE BAR iMenu OF Lib PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Lib DO vfpclubLib WITH 5
	CASE iMenu=67
		DEFINE BAR iMenu OF Lib PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Lib DO vfpclubLib WITH 6

	CASE iMenu=91		&& КАЛЬКУЛЯТОР
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO calc
	CASE iMenu=92		&& параметры печати
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _MFI_SYSPRINT) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service SYS(1037)
	CASE iMenu=94		&& Управление таблицами
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _MWI_VIEW) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 3
	CASE iMenu=95		&& индексация
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 12
	CASE iMenu=96		&& аудит данных
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 9
	CASE iMenu=97		&& BLOB JOB
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 11
	CASE iMenu=99		&& calendar
		cc = IIF(EMPTY(_Screen.ImageMenu), "", "PICTURE 'daytime.ico'")
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) &cc MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubview WITH 5
	CASE iMenu=100		&& popup
		cc = IIF(EMPTY(_Screen.ImageMenu), "", "PICTURE 'pop.ico'")
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) &cc MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubview WITH 6
	CASE iMenu=102		&& синхронизация
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) KEY Ctrl+F5,"Ctrl+F5" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _mpr_do) SKIP FOR EMPTY(_Screen.InternetInUse) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 8
	CASE iMenu=104		&& просмотр логов обновлений
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) KEY Shift+F5,"Shift+F5" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclublib WITH 4
	CASE iMenu=105		&&	ZIP - архивация сообщений
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubsystem WITH 2
	CASE iMenu=107		&&	Импорт DBF
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 5
	CASE iMenu=108		&&	Импорт XML
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 6
	CASE iMenu=109		&&	слияние данных
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 7
	CASE iMenu=110		&& экспорт *
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 110
	CASE iMenu=114
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 4
	CASE iMenu=115
		DEFINE BAR iMenu OF Service PROMPT ALLTRIM(cMenu) KEY Shift+F9,"Shift+F9" MESSAGE ALLTRIM(cMenu2)
		ON SELECTION BAR iMenu OF Service DO vfpclubSystem WITH 10
	ENDCASE
	STORE iMenu TO nParam
ENDSCAN
USE
IF !EMPTY(_Screen.EditMenu)
	DEFINE PAD _MEDIT OF _MSYSMENU PROMPT "\<Редактирование" SKIP FOR EMPTY(_Screen.FormCount) MESSAGE "Редактирование текста текущего объекта"
	ON PAD _MEDIT OF _MSYSMENU ACTIVATE POPUP _MEDIT
	DEFINE POPUP _MEDIT MARGIN RELATIVE
	DEFINE BAR _med_cut OF _MEDIT PROMPT "\<Вырезать" KEY Ctrl+X, "Ctrl+ч" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _med_cut) MESSAGE "Удаление выделенного фрагмента в буфер обмена"
	DEFINE BAR _med_copy OF _MEDIT PROMPT "\<Копировать" KEY Ctrl+C, "Ctrl+с" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _med_copy) MESSAGE "Копирование выделенного фрагмента в буфер обмена"
	DEFINE BAR _med_paste OF _MEDIT PROMPT "Встав\<ить" KEY Ctrl+V, "Ctrl+м" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _med_paste) MESSAGE "Вставка объектов из буфера обмена"
	DEFINE BAR 1 OF _MEDIT PROMPT "\-"
	DEFINE BAR _med_slcta OF _MEDIT PROMPT "Вы\<делить все" KEY Ctrl+A, "Ctrl+ф"
ENDIF
DEFINE PAD _MSM_WINDO OF _MSYSMENU PROMPT "Окно" MESSAGE "Управление окнами"
ON PAD _MSM_WINDO OF _MSYSMENU ACTIVATE POPUP _MWINDOW
DEFINE POPUP _MWINDOW MARGIN RELATIVE
DEFINE BAR _MWI_CASCADE OF _MWINDOW PROMPT "Показать все" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _MWI_CASCADE) MESSAGE "Показать все окна"
DEFINE BAR _MWI_ROTAT OF _MWINDOW PROMPT "Следующее" KEY Ctrl+F1,"Ctrl+F1" PICTRES IIF(EMPTY(_Screen.ImageMenu), _MFI_SP100, _MWI_ROTAT) MESSAGE "Переход в следующее окно"
DEFINE BAR _MFI_CLOSE OF _MWINDOW PROMPT "Закрыть" KEY Ctrl+F4,"Ctrl+F4" MESSAGE "Закрытие текущего окна"
DEFINE BAR _MWI_SP100 OF _MWINDOW PROMPT "\-"
IF FILE(_Screen.Comment+".hlp")
	DEFINE BAR 4 OF _MWINDOW PROMPT [Помощь] KEY F1 MESSAGE "Справочная информация"
	ON SELECTION BAR 4 OF _MWINDOW HELP
ENDIF
DEFINE BAR 5 OF _MWINDOW PROMPT [О программе "]+_SCREEN.CAPTION+["] MESSAGE "Информация о программе"
ON SELECTION BAR 5 OF _MWINDOW DO FORM AppAbout
DEFINE PAD Exiting OF _MSYSMENU PROMPT "Вы\<xод" KEY ALT+X SKIP FOR !EMPTY(_Screen.oReport) MESSAGE "Выход из программы  Alt+ч"
ON SELECTION PAD Exiting OF _MSYSMENU QUIT

EXTERNAL FILE u2.ico, internet.ico, daytime.ico, pop.ico
