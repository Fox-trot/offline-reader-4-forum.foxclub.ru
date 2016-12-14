LPARAMETERS nParam
DO CASE
CASE EMPTY(nParam)
CASE VARTYPE(_Screen.alib(nParam))="O"
	_Screen.alib(nParam).uMethod
	_Screen.alib(nParam).Show
CASE nParam=1
	DO FORM vfpclubcategory01 NAME _Screen.alib(nParam)
CASE nParam=2
	DO FORM IIF(EMPTY(_Screen.UserDetailsInGrid), "vfpclubuser02", "vfpclubuser01") NAME _Screen.alib(nParam)
CASE nParam=3
	DO FORM vfpclublink01 NAME _Screen.alib(nParam)
CASE nParam=4
	DO FORM vfpclublink02 NAME _Screen.alib(nParam)
CASE BETWEEN(m.nParam,5,6)
	DO FORM vfpclubquote03 NAME _Screen.alib(nParam) WITH m.nParam=6
OTHERWISE
	MESSAGEBOX("На стадии разработки",16,_Screen.Caption, _Screen.MBTimeout)
ENDCASE

EXTERNAL FORM vfpclubuser01, vfpclubuser02