LPARAMETERS nParam, uParam
DO vfpclubDBF WITH 2
LOCAL Ok, oldalias
STORE ALIAS() TO oldalias
DO CASE
CASE m.nParam=41 AND !EMPTY(m.uParam) AND BETWEEN(m.uParam, 1, 12)
	Ok=m.uParam
CASE m.nParam=41
	DO FORM vfpclubrep41 TO Ok
CASE m.nParam=42
	SELECT user
	LOCATE FOR iuser>0 AND EMPTY(MLINE(muser,1)+MLINE(muser,3))=.F.
	Ok=FOUND()
ENDCASE

SELECT 0
IF EMPTY(m.Ok)
	RETURN .F.
ELSE
	DO appExcel WITH -1
	DO appExcel
	DO CASE
	CASE BETWEEN(_Screen.Excel97,.1,7)
		RETURN .F.
	CASE m.nParam=41
		DO vfpclubrep41 WITH m.Ok
	CASE m.nParam=42
		DO vfpclubrep42
	ENDCASE
	DO CASE
	CASE EMPTY(RECCOUNT())
		WAIT WINDOW "Нет данных" NOWAIT
	CASE VARTYPE(_Screen.oXS)="O"
		DO appExcel WITH 4,"$1:$2"
		DO appExcel WITH 1
		DO appExcel WITH 8
		=AppBlobJob(m.nParam)
	ENDCASE
ENDIF
WAIT CLEAR
IF USED("R1")
	USE IN R1
ENDIF
IF !EMPTY(m.oldalias)
	SELECT (m.oldalias)
ENDIF
