* Преобразование даты в формат Datetime
Lparameters lcDate
IF EMPTY(lcDate)
	RETURN DTOT({})
ENDIF
Local nYear,nMonth,nDay,nHours,nMinutes,nSeconds
lcDate=LTRIM(GETWORDNUM(lcDate, GETWORDCOUNT(lcDate, [,]), [,]))
nDay=VAL(GETWORDNUM(m.lcDate, 1))
nYear=VAL(GETWORDNUM(m.lcDate, 3))
DO CASE
CASE !BETWEEN(m.nDay,1,31)
	RETURN DTOT({})
Case "jan"$LOWER(m.lcDate)
	nMonth=1
Case "feb"$LOWER(m.lcDate)
	nMonth=2
Case "mar"$LOWER(m.lcDate)
	nMonth=3
Case "apr"$LOWER(m.lcDate)
	nMonth=4
Case "may"$LOWER(m.lcDate)
	nMonth=5
Case "jun"$LOWER(m.lcDate)
	nMonth=6
Case "jul"$LOWER(m.lcDate)
	nMonth=7
Case "aug"$LOWER(m.lcDate)
	nMonth=8
Case "sep"$LOWER(m.lcDate)
	nMonth=9
Case "oct"$LOWER(m.lcDate)
	nMonth=10
Case "nov"$LOWER(m.lcDate)
	nMonth=11
Case "dec"$LOWER(m.lcDate)
	nMonth=12
OTHERWISE
	RETURN DTOT({})
EndCase
nHours=VAL(GETWORDNUM(GETWORDNUM(m.lcDate, 4), 1, [:]))
nMinutes=VAL(GETWORDNUM(GETWORDNUM(m.lcDate, 4), 2, [:]))
nSeconds=VAL(GETWORDNUM(GETWORDNUM(m.lcDate, 4), 3, [:]))
Return Datetime(m.nYear,m.nMonth,m.nDay,m.nHours,m.nMinutes,m.nSeconds)+VAL(GETWORDNUM(m.lcDate, 5))/100
