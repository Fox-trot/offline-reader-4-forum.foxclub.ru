LPARAMETERS cParam
#DEFINE userlenold 20
#DEFINE userlennew 30
IF IIF(EMPTY(m.cParam), .T., !DIRECTORY(m.cParam))
	RETURN 0
ENDIF
DO vfpclubdbf WITH 2
=AppBlobJob(109)
LOCAL xx, yy, zz
STORE 0 TO xx, yy
ON ERROR *
SELECT 0
USE cParam+"clubcategory" ALIAS xx1 EXCLUSIVE
IF USED()
	SELECT 0
	USE cParam+"clubpost" ALIAS xx2
	IF USED()
		SELECT 0
		USE cParam+"clubuser" ALIAS xx3
		DO proc_error
		IF USED()
			IF FLOCK("category")
				=AppBlobJob(109)
				SELECT xx1.ccategory, xx1.mcategory, xx1.mcategory2;
					FROM xx1;
					INNER JOIN xx2 ON xx1.icategory=xx2.icategory;
					WHERE xx1.icategory>0;
					GROUP BY 1;
					INTO CURSOR x1;
					ORDER BY 2
				SCAN ALL
					SCATTER MEMVAR
					icategory=vfpclubid(mcategory2)
					SELECT category
					IF !SEEK(m.icategory, "category", "icategory")
						INSERT INTO club!category FROM MEMVAR
					ENDIF
				ENDSCAN
			ENDIF
			UNLOCK ALL
			zz=SPACE(FSIZE('CUSER', 'USER'))
			SELECT ABS(xx2.ipost) AS iabs, xx2.ipost, xx2.ipost2, xx2.cpost, xx2.tpost, xx2.lpost, xx2.lzip, xx2.mpost, xx2.mpost2, xx2.icategory, xx2.iuser, category.ccategory, NVL(xx3.cuser, m.zz) AS cuser, xx3.nuser, xx3.muser;
				FROM xx2;
				INNER JOIN category ON xx2.icategory = category.icategory;
				LEFT JOIN xx3 ON xx2.iuser = ABS(xx3.iuser);
				WHERE xx2.icategory>0 AND TTOD(xx2.tpost)>{};
				GROUP BY 1;
				INTO CURSOR x1;
				ORDER BY 1
			IF FLOCK("user") AND FLOCK("post")
				_Screen.livewallpaper.StopStart("Import data")
				SCAN ALL
					=AppProgressBar(RECNO(), RECCOUNT(), "Import data")
					SCATTER MEMO MEMVAR
					SELECT post
					DO CASE
					CASE _Screen.lStop
						EXIT
					CASE !SEEK(m.iabs, "post", "abs")
						=AppCreateRecord(.T.)
						REPLACE ipost WITH m.ipost
						REPLACE ipost2 WITH m.ipost2
						REPLACE icategory WITH m.icategory
						REPLACE cpost WITH m.cpost
						REPLACE tpost WITH m.tpost
						STORE yy+1 TO yy
					CASE ipost#m.iabs
						REPLACE ipost WITH m.iabs
					ENDCASE
					IF !EMPTY(m.mpost) AND post.mpost#m.mpost
						REPLACE mpost WITH m.mpost
					ENDIF
					IF !EMPTY(m.mpost2) AND mpost2#m.mpost2
						REPLACE mpost2 WITH m.mpost2
					ENDIF
					IF tpost#m.tpost
						REPLACE tpost WITH m.tpost
					ENDIF
					IF m.lpost AND EMPTY(post.lpost)
						REPLACE lpost WITH .T.
					ENDIF
					IF ipost2>0 AND IIF(ipost2=ABS(post2.ipost), .T., SEEK(ipost2, "post2")) AND post2.lzip=.T.
						REPLACE lzip WITH .T.
					ENDIF
					SELECT user
					IF !EMPTY(m.cuser) &&AND EMPTY(post.iuser)
						cuser=ALLTRIM(m.cuser)
						IF LEN(m.cuser)>userlenold
							LOCATE FOR ALLTRIM(cuser)==LEFT(m.cuser, userlenold)
							IF FOUND() AND LEN(ALLTRIM(cuser)) <= userlenold
								REPLACE iuser WITH vfpclubid(m.cuser)
								REPLACE cuser WITH m.cuser
							ENDIF
						ENDIF
						LOCATE FOR ALLTRIM(cuser)==LEFT(m.cuser, userlennew)
						IF !FOUND()
							INSERT INTO user (iuser, cuser);
								VALUES (vfpclubid(LEFT(m.cuser, userlennew)), m.cuser)
							IF !EMPTY(m.nuser)
								REPLACE nuser WITH m.nuser
							ENDIF
							IF !EMPTY(m.muser)
								REPLACE muser WITH m.muser
							ENDIF
						ENDIF
						IF user.tuser<post.tpost
							REPLACE tuser WITH post.tpost
						ENDIF
					ENDIF
				ENDSCAN
				_Screen.livewallpaper.StopStart()
				USE IN x1
				USE IN xx3
			ENDIF
			UNLOCK ALL
		ENDIF
		USE IN xx2
	ENDIF
	USE IN xx1
ENDIF
DO proc_error
vfpclubAddEmptyPosts(m.yy)
RETURN m.yy
