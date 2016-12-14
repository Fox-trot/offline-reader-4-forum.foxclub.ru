LPARAMETERS cParam
RETURN IIF(IIF(EMPTY(m.cParam),.T.,EMPTY(VAL(m.cParam))), [], _Screen.Graphics+m.cParam+"."+_Screen.Comment)