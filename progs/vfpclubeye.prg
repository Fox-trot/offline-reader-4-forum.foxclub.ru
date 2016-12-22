LPARAMETERS nParam, uParam, uParam2
DO CASE
CASE EMPTY(m.nParam)
CASE VARTYPE(_Screen.aeye(m.nParam))="O"
	DO CASE
	CASE INLIST(m.nParam,7,8,9,18)
		_Screen.aeye(m.nParam).uMethod(m.uParam, m.uParam2)
	OTHERWISE
		_Screen.aeye(m.nParam).uMethod(m.uParam)
	ENDCASE
	_Screen.aeye(m.nParam).Show
CASE m.nParam=17
	DO FORM vfpclubeye03 NAME _Screen.aeye(m.nParam) WITH m.uParam
CASE INLIST(m.nParam,7,8,9,18,20)
	DO FORM vfpclubeye02 NAME _Screen.aeye(m.nParam) WITH m.nParam, m.uParam, m.uParam2
CASE BETWEEN(m.nParam, 1, 19)
	DO FORM vfpclubeye01 NAME _Screen.aeye(m.nParam) WITH m.nParam, m.uParam
*!*	OTHERWISE
*!*		MESSAGEBOX("На стадии разработки",16,_Screen.Caption)
ENDCASE
