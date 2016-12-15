LPARAMETERS iParam, nParam, cParam, lParam
#DEFINE CHRF [ ]+CHR(13)
LOCAL cReturn, nRec, cAlias
cReturn = []
IF !USED("user")
	USE club!user IN 0 AGAIN
ENDIF
nRec = RECNO("user")
IF !EMPTY(m.iParam) AND IIF(ABS(m.iParam) = ABS(user.iuser), .T., SEEK(ABS(m.iParam), "user", "abs")) AND IIF(EMPTY(m.nParam), ABS(user.nuser), m.nParam)>0
	LOCAL cc, xx, yy, zz, ll
	LOCAL ARRAY aa(ALEN(_Screen.UserMemo))
	STORE [] TO aa
	IF EMPTY(m.cParam)
		cParam = _Screen.ImportPath+TRANSFORM(ABS(user.iuser))+".htm"
*!*			WAIT WINDOW [Загрузка ...] NOCLEAR NOWAIT
		=vfphttp(_Screen.ProfileLink+TRANSFORM(IIF(EMPTY(m.nParam), ABS(user.nuser), m.nParam)), m.cParam)
		=AppBlobJob(103)
	ENDIF
	IF FILE(m.cParam)
		ll=FILETOSTR(m.cParam)
		IF !EMPTY(m.ll) AND AT(ALLTRIM(user.cuser), m.ll) + AT(_Screen.ProfilePhotoLink, m.ll)>1
			cAlias = [u]+LEFT(SYS(3),7)
			SELECT 0
			CREATE CURSOR (cAlias) (mm C (254) NOCPTRANS)
			APPEND FROM (m.cParam) FOR [<]$mm AND LEN(ALLTRIM(mm))>9 TYPE DELIMITED WITH TAB
			LOCATE ALL FOR ALLTRIM(user.cuser) $ mm
*!*				WAIT CLEAR
			IF !FOUND()
				=AppErase(m.cParam)
				RETURN IIF(EMPTY(m.lParam), "", .F.)
			ENDIF
			STORE RECNO() TO xx
			WITH _Screen
				IF !FILE(vfpclubavatar(TRANSFORM(ABS(user.iuser))))
					cc=[]
					LOCATE REST FOR _Screen.ProfilePhotoLink $ mm
					zz = SUBSTR(mm, AT(.ProfilePhotoLink, mm)+LEN(.ProfilePhotoLink))
					FOR yy=1 TO LEN(m.zz)
						IF ISDIGIT(SUBSTR(m.zz, m.yy, 1))
							cc = m.cc + SUBSTR(m.zz, m.yy, 1)
						ELSE
							EXIT
						ENDIF
					ENDFOR
					IF VAL(m.cc)>0 AND vfphttp(.ProfilePhotoLink + m.cc, vfpclubavatar(TRANSFORM(ABS(user.iuser))))
						IF !EMPTY(AT([HTML>], UPPER(FILETOSTR(vfpclubavatar(TRANSFORM(ABS(user.iuser)))))) + AT([HEAD>], UPPER(FILETOSTR(vfpclubavatar(TRANSFORM(ABS(user.iuser)))))))
							=AppErase(vfpclubavatar(TRANSFORM(ABS(user.iuser))))
						ENDIF
					ENDIF
				ENDIF
			ENDWITH
			IF !EMPTY(m.lParam)
				IF NOT m.cParam == _Screen.ImportPath+TRANSFORM(ABS(user.nuser))+".htm"
					=AppErase(m.cParam)
				ENDIF
				RETURN FILE(vfpclubavatar(TRANSFORM(ABS(user.iuser))))
			ENDIF
			GO m.xx+2
			STORE 0 TO zz
			STORE [] TO cc, ll
			SCAN REST FOR LEFT(ALLTRIM(mm), 4)=="<td " AND RIGHT(ALLTRIM(mm), 5)=="</td>" AND AT(":", mm)>0
				cc = SUBSTR(ALLTRIM(mm), AT(">", ALLTRIM(mm))+1)
				zz = MAX(ASCAN(_Screen.UserMemo, LEFT(m.cc, AT(":", m.cc)-1)),;
					ASCAN(_Screen.UserMemo, LOWER(LEFT(m.cc, AT(":", m.cc)-1))),;
					ASCAN(_Screen.UserMemo, UPPER(LEFT(m.cc, AT(":", m.cc)-1))),;
					ASCAN(_Screen.UserMemo, PROPER(LEFT(m.cc, AT(":", m.cc)-1))))
				IF BETWEEN(m.zz, 1, ALEN(_Screen.UserMemo))
					LOCATE REST FOR LEFT(ALLTRIM(mm), 4)=="<td>" AND RIGHT(ALLTRIM(mm), 5)=="</td>"
					IF FOUND()
						STORE RECNO() TO xx
						cc = ALLTRIM(mm)
						cc = ALLTRIM(SUBSTR(m.cc, AT(">", m.cc)+1))
						DO CASE
						CASE GETWORDCOUNT(m.cc, "&#")>5 AND GETWORDCOUNT(m.cc, ";")>5	&& email
							cc = LEFT(m.cc, AT("</td>", cc)-1)
							FOR yy=1 TO GETWORDCOUNT(m.cc, ";")
								ll = m.ll + CHR(VAL(SUBSTR(GETWORDNUM(m.cc, m.yy, ";"),3)))
							ENDFOR
							cc=ll
						CASE m.zz=3
							cc=AppDigit(m.cc)
						CASE m.zz=6 AND AT("&nbsp;", m.cc)>0
							yy = SUBSTR(m.cc, AT("&nbsp;", m.cc)+6)
							yy = UPPER(LEFT(m.yy, AT("<", m.yy)-1))
							IF !USED("rus")
								USE rus IN 0 AGAIN
							ENDIF
							SELECT rus
							LOCATE ALL FOR nrus=2 AND UPPER(ALLTRIM(crus)) = m.yy
							IF FOUND() AND LEN(m.cc)>6
								cc = LEFT(m.cc, AT("&nbsp;", m.cc)-1)
								cc = PADL(TRANSFORM(rus.irus), 2, "0")+PADL(ALLTRIM(m.cc), 2, "0")
							ENDIF
							cc = IIF(LEN(m.cc)=4 AND BETWEEN(VAL(m.cc), 101, 1231), m.cc, [])
						CASE m.zz=7
							cc = LEFT(m.cc, 6)+TRANSFORM(INT(YEAR(DATE())/100-IIF(VAL(LEFT(GETWORDNUM(m.cc, 3, "."),2))>50, 1, 0))*100+VAL(LEFT(GETWORDNUM(m.cc, 3, "."),2)))
						OTHERWISE
							cc = LEFT(m.cc, AT("</td>", m.cc)-1)
						ENDCASE
						aa(m.zz) = IIF(m.zz=1 AND "."$GETWORDNUM(m.cc, 2, "@") OR BETWEEN(m.zz, 2, ALEN(_Screen.UserMemo)), ALLTRIM(m.cc), [])
					ELSE
						GO m.xx+1
					ENDIF
				ENDIF
			ENDSCAN
			USE
		ENDIF
*!*			IF !EMPTY(_Screen.NormalMode)
			=AppErase(m.cParam)
*!*			ENDIF
		IF !EMPTY(aa(4)) AND EMPTY(aa(5))
			aa(5) = vfpclubsaymecountry(aa(4))
		ENDIF
		xx = 0
		FOR zz=1 TO ALEN(_Screen.UserMemo)
			cReturn = m.cReturn + aa(m.zz)+IIF(m.zz=ALEN(_Screen.UserMemo), "", CHRF)
			xx = m.xx + LEN(aa(m.zz))
		ENDFOR
		IF m.xx=0
			cReturn = []
		ENDIF
	ENDIF
ENDIF
IF BETWEEN(m.nRec, 1, RECCOUNT("user"))
	GO m.nRec IN user
ENDIF
RETURN m.cReturn
