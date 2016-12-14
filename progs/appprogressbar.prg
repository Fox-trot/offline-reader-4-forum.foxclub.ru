LPARAMETERS nParam1, nParam2, cParam
DO CASE
CASE IIF(EMPTY(nParam2), .T., EMPTY(nParam1))
	WAIT CLEAR
	SET MESSAGE TO
	STORE -1 TO _Screen.nStep
CASE IIF(_Screen.Visible, _Screen.WindowState = 1, .T.)
	RETURN
CASE INT(100 * nParam1 / nParam2) # _Screen.nStep
	STORE MIN(INT(100 * nParam1 / nParam2), 100) TO _Screen.nStep
	SET MESSAGE TO IIF(EMPTY(cParam), " ", ALLTRIM(LEFT(cParam, 32)) + SPACE(4)) + REPLICATE("|", _Screen.nStep * IIF(_Screen.Width>1000, 1.6, IIF(_Screen.Width>700, .8, .5))) + STR(_Screen.nStep, 4) + "%"
ENDCASE
DOEVENTS
