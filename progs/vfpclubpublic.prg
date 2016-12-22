LPARAMETERS uParam, nParam, lParam
WITH _Screen
	DO CASE
	CASE EMPTY(m.uParam)
		.ADDPROPERTY("adox[6]")
		.ADDPROPERTY("aeye[20]")
		.ADDPROPERTY("alib[6]")
		.ADDPROPERTY("aview[6]")
		
		.AddProperty("UserMemo[8]")
		.UserMemo[1]="E-mail"
		.UserMemo[2]="Ф.И.О."
		.UserMemo[3]="ICQ"
		.UserMemo[4]="City"
		.UserMemo[5]="Country"
		.UserMemo[6]="ДР"
		.UserMemo[7]="Дата регистрации"
		.UserMemo[8]="Skype"
		
		.AddProperty("UserMemoText[9]")
		.UserMemoText[1]="Адрес электронной почты"
		.UserMemoText[2]="Ф.И.О. пользователя"
		.UserMemoText[3]="Номер ICQ"
		.UserMemoText[4]="Город"
		.UserMemoText[5]="Страна"
		.UserMemoText[6]="Дата рождения (MMDD)"
		.UserMemoText[7]="Дата регистрации"
		.UserMemoText[8]="Skype"
		.UserMemoText[9]="Последняя активность"
		
		.AddProperty("UserDetail", 3)
		.AddProperty("UserDetailsInGrid", 1)

		.AddProperty("AddHours", 0)
		.AddProperty("ImportPath", ADDBS(SYS(2023)))
		.AddProperty("ImportPath2", ADDBS(SYS(2023)))
		.AddProperty("ExportPath2", ADDBS(SYS(2023)))
		.AddProperty("CreateTempDBF", 0)
		.AddProperty("DeleteTempFiles", 1)
		.AddProperty("DeleteTempRecord", 0)
		.AddProperty("SaveXML", -1)
		.AddProperty("SaveLink", 0)
		.AddProperty("DefaultCategory", 3300467333)
		.AddProperty("InternetInUse", 1)
		.AddProperty("DownloadMethod", 1)
		.AddProperty("DownloadTimer", 60)
		.AddProperty("DownloadFromHour", 0)
		.AddProperty("DownloadWhenStart", 0)
		.AddProperty("DownLoadProfiles", DOW(DATE()))
		.AddProperty("MaxTryDownload", 20)
		.AddProperty("ReadTimer", 5)
		.AddProperty("oXMLDoc")
		.AddProperty("PostViewer", 12)
		.AddProperty("PostGroup", -2)
		.AddProperty("HTMLGenerator", 1)
		.AddProperty("Quote", 1)
		.AddProperty("RSSGenerator", "")	&&PHORUM 5.1.16A
		.AddProperty("RSSLanguage", "")
		.AddProperty("RSSLink", "http://forum.foxclub.ru/rss.php?")
		.AddProperty("FoxClubRSSonly", 1)
		.AddProperty("DefaultRSS", 0)
		.AddProperty("RSSGroupMethod", 2)
		.AddProperty("CSS", "style.css")
		.AddProperty("CSSLink", "http://forum.foxclub.ru/templates/foxclub/")
		.AddProperty("PostLink", "http://forum.foxclub.ru/read.php?")
		.AddProperty("MarkReadLink", "")	&& http://forum.foxclub.ru/index.php?##,markread,0
		.AddProperty("Smile", 1)
		.AddProperty("SmileLink", "http://forum.foxclub.ru/mods/smileys/images/")
		.AddProperty("ProfileLink", "http://forum.foxclub.ru/profile.php?0,")
		.AddProperty("ProfilePhotoLink", "http://forum.foxclub.ru/file.php?0,file=")
		.AddProperty("AttachmentLink", "http://forum.foxclub.ru/file.php?##,file=")
		.AddProperty("BlackList", 1)
		.AddProperty("Days4Zip", 30)
		.AddProperty("LastStart", DTOS(DATE()-1))
		.AddProperty("MinUpdatePeriod", 600)
		.AddProperty("RemindBirthDays", 1)
		.AddProperty("PostFormat", "TUP")
		.AddProperty("PostIcon", 1)
		.AddProperty("TreeAsIs", 1)
		.AddProperty("AutoRefresh", 1)
		.AddProperty("xml2cursor", 516)
	CASE EMPTY(_Screen.AutoRefresh)
		WAIT CLEAR
		RETURN .F.
	CASE m.uParam=-1
		=SYS(1104)
		SET MESSAGE TO [Refresh..]
		FOR uParam=4 TO 1 STEP -1
			vfpclubpublic(m.uParam)
		ENDFOR
		SET MESSAGE TO
	CASE EMPTY(m.nParam)
		FOR nParam=1 TO 14
			vfpclubpublic(m.uParam, m.nParam)
		ENDFOR
		WAIT CLEAR
	CASE m.uParam=1 AND BETWEEN(m.nParam, 1,ALEN(.adox))
		vfpclubrefreshforms(.adox(m.nParam))
	CASE m.uParam=2 AND BETWEEN(m.nParam, 1,ALEN(.aeye))
		vfpclubrefreshforms(.aeye(m.nParam))
	CASE m.uParam=3 AND BETWEEN(m.nParam, 1,ALEN(.alib))
		vfpclubrefreshforms(.alib(m.nParam))
	CASE m.uParam=4 AND BETWEEN(m.nParam, 1,ALEN(.aview)-2)
		vfpclubrefreshforms(.aview(m.nParam))
	ENDCASE
ENDWITH

FUNCTION vfpclubrefreshforms(oParam)
	IF VARTYPE(m.oParam)="O"
		m.oParam.uMethod
	ENDIF
