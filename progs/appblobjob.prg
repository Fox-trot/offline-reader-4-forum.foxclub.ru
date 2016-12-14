LPARAMETERS nParam1,nParam2
*!*	nParam1		iMenu
*!*	nParam2		_Screen.UsedID
IF !EMPTY(_Screen.BlobJob)
	IF !USED("Blob")
		USE (_Screen.BlobJob) IN 0 ALIAS blob AGAIN
	ENDIF
	IF USED("Blob") AND FLOCK("Blob")
		IF EMPTY(_Screen.NeedAccess)
			INSERT INTO blob (iBlob,iMenu) VALUES (MONTH(DATE())*100000000+DAY(DATE())*1000000+VAL(RIGHT(SYS(3),6)), IIF(EMPTY(nParam1),BAR(),nParam1))
		ELSE
			INSERT INTO blob (iBlob,iMenu,iUser,tBlob) VALUES (MONTH(DATE())*100000000+DAY(DATE())*1000000+VAL(RIGHT(SYS(3),6)), IIF(EMPTY(nParam1),BAR(),nParam1), IIF(EMPTY(nParam2),_Screen.UserID,nParam2), DATETIME())
		ENDIF
		UNLOCK IN Blob
	ENDIF
ENDIF
