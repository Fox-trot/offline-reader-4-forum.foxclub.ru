LPARAMETERS lParam, cParam
LOCAL cc
#DEFINE uu "Main"
WITH _Screen
	IF FILE(.ini)
		DO AppINI WITH m.lParam,m.cParam
	ENDIF
	IF EMPTY(m.lParam)		&& чтение
		IF FILE(.ini)
			STORE INIRead(.ini,uu,"AddHours") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),-12,13), INT(VAL(m.cc)), 0) TO .AddHours
			STORE INIRead(.ini,uu,"BlobJob") TO cc
			STORE IIF(EMPTY(m.cc),"","clubblob") TO .BlobJob
			STORE INIRead(.ini,uu,"DefaultCategory") TO cc
			STORE IIF(INT(VAL(m.cc))>0 AND IIF(USED("category"), INDEXSEEK(INT(VAL(m.cc)), .F., "category", "icategory"), .T.), INT(VAL(m.cc)), 0) TO .DefaultCategory
			STORE INIRead(.ini,uu,"DeleteTempFiles") TO cc
			STORE IIF(INLIST(VAL(m.cc),1,2), VAL(m.cc), AppINIDefault(m.cc)) TO .DeleteTempFiles
			STORE INIRead(.ini,uu,"DeleteTempRecord") TO cc
			STORE IIF(INLIST(VAL(m.cc),0,1), VAL(m.cc), .DeleteTempRecord) TO .DeleteTempRecord
			IF EMPTY(.NormalMode) AND !EMPTY(.DeleteTempFiles)
				STORE INIRead(.ini,uu,"CreateTempDBF") TO cc
				STORE IIF(INLIST(VAL(m.cc), 866, 1251), VAL(m.cc), IIF(INLIST(VAL(m.cc),1,2), CPCURRENT(VAL(m.cc)), 0)) TO .CreateTempDBF
			ENDIF

			STORE INIRead(.ini,uu,"SaveXML") TO cc
			STORE IIF(!EMPTY(m.cc) AND BETWEEN(VAL(m.cc), -1, 1), INT(VAL(m.cc)), .SaveXML) TO .SaveXML
			STORE INIRead(.ini,uu,"SaveLink") TO cc
			STORE AppINIDefault(m.cc) TO .SaveLink
			STORE INIRead(.ini,uu,"ImportPath") TO cc
			STORE ADDBS(IIF(DIRECTORY(m.cc), m.cc, .ImportPath)) TO .ImportPath
			STORE INIRead(.ini,uu,"ImportPath2") TO cc
			STORE ADDBS(IIF(DIRECTORY(m.cc), m.cc, .ImportPath2)) TO .ImportPath2
			STORE INIRead(.ini,uu,"InternetInUse") TO cc
			STORE IIF(INLIST(VAL(m.cc),1,2), VAL(m.cc), AppINIDefault(m.cc)) TO .InternetInUse
			STORE INIRead(.ini,uu,"MaxTryDownload") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),1,99), INT(VAL(m.cc)), .MaxTryDownload) TO .MaxTryDownload
			STORE INIRead(.ini,uu,"DownloadMethod") TO cc
			STORE AppINIDefault(m.cc) TO .DownloadMethod
			STORE INIRead(.ini,uu,"ReadTimer") TO cc
			STORE IIF(!EMPTY(m.cc) AND BETWEEN(VAL(m.cc),0,99), INT(VAL(m.cc)), .ReadTimer) TO .ReadTimer
			STORE INIRead(.ini,uu,"DownloadTimer") TO cc
			STORE IIF(!EMPTY(.InternetInUse) AND BETWEEN(VAL(m.cc),0,999), VAL(m.cc), .DownloadTimer) TO .DownloadTimer
			STORE INIRead(.ini,uu,"DownloadFromHour") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),0,23), VAL(m.cc), .DownloadFromHour) TO .DownloadFromHour
			STORE INIRead(.ini,uu,"DownloadWhenStart") TO cc
			STORE IIF(!EMPTY(.InternetInUse) AND VAL(m.cc)=1,1,0) TO .DownloadWhenStart
			STORE INIRead(.ini,uu,"DownloadProfiles") TO cc
			STORE IIF(!EMPTY(m.cc) AND BETWEEN(VAL(m.cc),0,999), INT(VAL(m.cc)), .DownLoadProfiles) TO .DownLoadProfiles

			STORE INIRead(.ini,uu,"PostViewer") TO cc
			STORE IIF(INLIST(VAL(m.cc),1,2,11,12), VAL(m.cc), .PostViewer) TO .PostViewer
			STORE INIRead(.ini,uu,"PostGroup") TO cc
			STORE IIF(INLIST(.PostViewer,2,12), IIF(!EMPTY(m.cc) AND BETWEEN(VAL(m.cc), -1, 2), INT(VAL(m.cc)), .PostGroup), 0) TO .PostGroup
			STORE INIRead(.ini,uu,"Quote") TO cc
			STORE AppINIDefault(m.cc) TO .Quote
			STORE INIRead(.ini,uu,"PostFormat") TO cc
			STORE IIF(EMPTY(m.cc), .PostFormat, UPPER(m.cc)) TO .PostFormat
			STORE INIRead(.ini,uu,"PostIcon") TO cc
			STORE AppINIDefault(m.cc) TO .PostIcon
			STORE INIRead(.ini,uu,"TreeAsIs") TO cc
			STORE AppINIDefault(m.cc) TO .TreeAsIs
			STORE INIRead(.ini,uu,"UserDetail") TO cc
			STORE IIF(INLIST(VAL(m.cc), -1,0,3,4,5,6,7,8), INT(VAL(m.cc)), .UserDetail) TO .UserDetail
			STORE INIRead(.ini,uu,"UserDetailsInGrid") TO cc
			STORE AppINIDefault(m.cc) TO .UserDetailsInGrid
			STORE INIRead(.ini,uu,"AutoRefresh") TO cc
			STORE AppINIDefault(m.cc) TO .AutoRefresh

			STORE INIRead(.ini,uu,"RSSGenerator") TO cc
			STORE IIF(EMPTY(m.cc), .RSSGenerator, UPPER(m.cc)) TO .RSSGenerator
			STORE INIRead(.ini,uu,"RSSLanguage") TO cc
			STORE IIF(EMPTY(m.cc), .RSSLanguage, UPPER(m.cc)+[ ]) TO .RSSLanguage

			STORE INIRead(.ini,uu,"RSSLink") TO cc
			STORE IIF(EMPTY(m.cc), .RSSLink, m.cc) TO .RSSLink
			STORE INIRead(.ini,uu,"FoxClubRSSonly") TO cc
			STORE AppINIDefault(m.cc) TO .FoxClubRSSonly
			IF EMPTY(.FoxClubRSSonly)
				STORE INIRead(.ini,uu,"DefaultRSS") TO cc
				STORE IIF(INT(VAL(m.cc))>0 AND IIF(USED("category"), INDEXSEEK(INT(VAL(m.cc)), .F., "category", "icategory"), .T.), INT(VAL(m.cc)), 0) TO .DefaultRSS
				STORE INIRead(.ini,uu,"RSSGroupMethod") TO cc
				STORE IIF(!EMPTY((m.cc)) AND BETWEEN(VAL(m.cc),0,3), INT(VAL(m.cc)), .RSSGroupMethod) TO .RSSGroupMethod
			ENDIF

			STORE INIRead(.ini,uu,"CSS") TO cc
			STORE IIF(EMPTY(m.cc), .CSS, m.cc) TO .CSS
			STORE INIRead(.ini,uu,"CSSLink") TO cc
			STORE IIF(EMPTY(m.cc), .CSSLink, m.cc) TO .CSSLink
			STORE INIRead(.ini,uu,"PostLink") TO cc
			STORE IIF(EMPTY(m.cc), .PostLink, m.cc) TO .PostLink
			STORE INIRead(.ini,uu,"MarkReadLink") TO cc
			STORE IIF("##"$m.cc, m.cc, .MarkReadLink) TO .MarkReadLink
			STORE INIRead(.ini,uu,"SmileLink") TO cc
			STORE IIF(EMPTY(m.cc), .SmileLink, m.cc) TO .SmileLink
			STORE INIRead(.ini,uu,"Smile") TO cc
			STORE IIF(INLIST(.PostViewer,11,12) AND !EMPTY(.Quote), AppINIDefault(m.cc), 0) TO .Smile
			STORE INIRead(.ini,uu,"HTMLGenerator") TO cc
			STORE IIF(INLIST(.PostViewer,11,12) AND !EMPTY(.Quote), AppINIDefault(m.cc), 0) TO .HTMLGenerator
			STORE INIRead(.ini,uu,"ProfileLink") TO cc
			STORE IIF(EMPTY(m.cc), .ProfileLink, m.cc) TO .ProfileLink
			STORE INIRead(.ini,uu,"ProfilePhotoLink") TO cc
			STORE IIF(EMPTY(m.cc), .ProfilePhotoLink, m.cc) TO .ProfilePhotoLink
			STORE INIRead(.ini,uu,"AttachmentLink") TO cc
			STORE IIF("##"$m.cc, m.cc, .AttachmentLink) TO .AttachmentLink

			STORE INIRead(.ini,uu,"BlackList") TO cc
			STORE AppINIDefault(m.cc) TO .BlackList
			STORE INIRead(.ini,uu,"Days4Zip") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),-99,99), INT(VAL(m.cc)), .Days4Zip) TO .Days4Zip
			STORE INIRead(.ini,uu,"MinUpdatePeriod") TO cc
			STORE IIF(BETWEEN(VAL(m.cc),1,MAX(1,.DownloadTimer/2)), VAL(m.cc)*60, MIN(.MinUpdatePeriod, .DownloadTimer*30)) TO .MinUpdatePeriod
			STORE INIRead(.ini,uu,"RemindBirthDays") TO cc
			STORE IIF(!EMPTY(m.cc) AND INLIST(VAL(m.cc), 0, 1, 2), VAL(m.cc), .RemindBirthDays) TO .RemindBirthDays

			STORE INIRead(.ini,uu,"xml2cursor") TO cc
			STORE IIF(!EMPTY(m.cc) AND INLIST(VAL(m.cc), 0, 4, 512, 516, 1024, 1028, 1536, 1540), VAL(m.cc), .xml2cursor) TO .xml2cursor
		ELSE
			DO vfpclubini WITH .T.,m.cParam
		ENDIF
	ELSE					&& запись
		IF IIF(EMPTY(m.cParam),.T.,!FILE(.ini))
			=INIWrite(.ini,uu,"AddHours",TRANSFORM(.AddHours))
			=INIWrite(.ini,uu,"BlackList",TRANSFORM(.BlackList))
			=INIWrite(.ini,uu,"BlobJob",IIF(EMPTY(.BlobJob),"","clubblob"))
			=INIWrite(.ini,uu,"Days4Zip",TRANSFORM(.Days4Zip))
			=INIWrite(.ini,uu,"DefaultCategory",TRANSFORM(.DefaultCategory))
			=INIWrite(.ini,uu,"DeleteTempFiles",TRANSFORM(.DeleteTempFiles))
			=INIWrite(.ini,uu,"SaveXML",TRANSFORM(.SaveXML))
			=INIWrite(.ini,uu,"ImportPath",.ImportPath)
			=INIWrite(.ini,uu,"MaxTryDownload",TRANSFORM(.MaxTryDownload))
			=INIWrite(.ini,uu,"ReadTimer",TRANSFORM(.ReadTimer))
			=INIWrite(.ini,uu,"RemindBirthDays",TRANSFORM(.RemindBirthDays))
			=INIWrite(.ini,uu,"DownloadTimer",TRANSFORM(.DownloadTimer))
			=INIWrite(.ini,uu,"DownloadWhenStart",TRANSFORM(.DownloadWhenStart))
			=INIWrite(.ini,uu,"PostViewer",TRANSFORM(.PostViewer))
			=INIWrite(.ini,uu,"PostGroup",TRANSFORM(.PostGroup))
			=INIWrite(.ini,uu,"Quote",TRANSFORM(.Quote))
			=INIWrite(.ini,uu,"Smile",TRANSFORM(.Smile))
			=INIWrite(.ini,uu,"HTMLGenerator",TRANSFORM(.HTMLGenerator))
*!*				IF EMPTY(.FoxClubRSSonly)
*!*					=INIWrite(.ini,uu,"DefaultRSS",TRANSFORM(.DefaultRSS))
*!*					=INIWrite(.ini,uu,"RSSGroupMethod",TRANSFORM(.RSSGroupMethod))
*!*				ENDIF
		ENDIF
	ENDIF
ENDWITH
