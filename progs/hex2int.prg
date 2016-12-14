*Hex2Int
LPARAMETERS tcHex, tlLong
LOCAL liInteger,lnI
IF PCount()<2
	tlLong=LEN(tcHex)
ENDIF
liInteger=0
FOR lnI=1 TO tlLong
	liInteger=liInteger+ASC(SUBSTR(tcHex,lnI,1))*(256^(lnI-1))
ENDFOR
RETURN liInteger
