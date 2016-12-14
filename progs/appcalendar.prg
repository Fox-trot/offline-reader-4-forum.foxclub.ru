*!*	AppCalendar
LPARAMETERS dDate, nRows
IF USED("RepCalendar")
	SELECT AppCalendar
	ZAP
ENDIF
CREATE CURSOR AppCalendar(iName D)
FOR iii=0 TO nRows-1
	INSERT INTO AppCalendar(iName) VALUES (m.dDate-m.iii)
ENDFOR
