LPARAMETERS cParam
ON ERROR DO LocalError
STORE ADDBS(SYS(2023))+IIF(EMPTY(cParam),"foxuser",ALLTRIM(cParam)) TO cParam
IF IIF(FILE(cParam+".dbf"), !FILE(cParam+".fpt"), .T.)
	IF FILE(cParam+".dbf")
		=AppErase(cParam+".dbf")
	ENDIF
	IF FILE(cParam+".fpt")
		=AppErase(cParam+".fpt")
	ENDIF
	SELECT 0
	CREATE DBF (cParam) FREE;
		(type C(12),;
		id C(12),;
		name M,;
		readonly L,;
		ckval N(6),;
		data M,;
		updated D)
	USE
ENDIF
IF FILE(cParam+".dbf") AND FILE(cParam+".fpt")
	LOCAL ff
	ff = FOPEN(cParam+".dbf", 12)
	IF ff > 0
		=FCLOSE(ff)
		SET RESOURCE TO (cParam)
		SET RESOURCE ON
	ENDIF
ENDIF
DO proc_error

PROCEDURE LocalError
SET RESOURCE OFF
