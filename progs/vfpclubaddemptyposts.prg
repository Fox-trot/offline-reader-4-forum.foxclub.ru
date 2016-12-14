LPARAMETERS nParam
IF !EMPTY(m.nParam)
	LOCAL icat
*!*	создание пустых заголовков для построения дерева сообщений
	SELECT post.ipost2, MIN(post.tpost) AS tpost;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=Link.icategory;
		WHERE post.ipost2>0 AND TTOD(post.tpost)>{} AND link.ilink>0;
		AND post.ipost2 NOT IN (SELECT ABS(post.ipost) AS ipost FROM club!post WHERE TTOD(post.tpost)>{});
		GROUP BY 1;
		INTO CURSOR x1;
		ORDER BY 2
	IF FLOCK("post")
		SCAN FOR SEEK(ipost2, "post", "ipost2")
			SELECT post
			nParam = LTRIM(cpost)
			icat = icategory
			IF NOT SEEK(ipost2, "post", "abs")
				=AppCreateRecord(.T.)
			ENDIF
			REPLACE ipost WITH -1*x1.ipost2,;
				cpost WITH IIF(LEFT(m.nParam, 4)==[Re: ], SUBSTR(m.nParam, 5), m.nParam),;
				tpost WITH DTOT(TTOD(x1.tpost))+1,;
				lpost WITH .T.,;
				icategory WITH m.icat
			IF !EMPTY(mpost)
				REPLACE mpost WITH []
			ENDIF
			IF !EMPTY(mpost2)
				REPLACE mpost2 WITH []
			ENDIF
		ENDSCAN
	ENDIF
	USE
ENDIF
UNLOCK IN post
