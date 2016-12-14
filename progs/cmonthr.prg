LPARAMETERS dParam, lParam
LOCAL nReturn
STORE IIF(VARTYPE(dParam)$"DT", MONTH(IIF(EMPTY(dParam),DATE(),dParam)), IIF(VARTYPE(dParam)="N" AND BETWEEN(dParam,1,12),dParam,MONTH(DATE()))) TO nReturn
IF EMPTY(m.lParam)
	RETURN IIF(nReturn=1, [Январь], IIF(nReturn=2, [Февраль], IIF(nReturn=3, [Март], IIF(nReturn=4, [Апрель], IIF(nReturn=5, [Май], IIF(nReturn=6, [Июнь], IIF(nReturn=7, [Июль], IIF(nReturn=8, [Август], IIF(nReturn=9, [Сентябрь], IIF(nReturn=10, [Октябрь], IIF(nReturn=11, [Ноябрь], [Декабрь])))))))))))
ENDIF
RETURN IIF(nReturn=1, [Января], IIF(nReturn=2, [Февраля], IIF(nReturn=3, [Марта], IIF(nReturn=4, [Апреля], IIF(nReturn=5, [Мая], IIF(nReturn=6, [Июня], IIF(nReturn=7, [Июля], IIF(nReturn=8, [Августа], IIF(nReturn=9, [Сентября], IIF(nReturn=10, [Октября], IIF(nReturn=11, [Ноября], [Декабря])))))))))))
