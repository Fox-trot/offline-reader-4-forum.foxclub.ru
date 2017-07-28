LPARAMETERS nParam
#DEFINE cmes "Архивация сообщений"
IF EMPTY(m.nParam)
	RETURN 0
ENDIF
LOCAL nCount, dZip
STORE 0 TO nCount
STORE DATE()-ABS(m.nParam) TO dZip
IF m.nParam>0
	SELECT DISTINCT post.ipost, post.icategory;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		INNER JOIN club!category ON post.icategory=category.icategory;
		LEFT JOIN club!user ON post.iuser = ABS(user.iuser);
		WHERE post.lzip=.F. AND TTOD(post.tpost)<m.dZip;
		AND post.lpost=.T.;
		AND link.ilink<0;
		AND category.lzip=.T.;
		INTO CURSOR x3 ORDER BY 1
	SELECT ABS(post.ipost) AS ipost;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		WHERE post.ipost2=0 AND post.tpost<m.dZip;
		AND post.lzip=.F. AND (post.lpost=.T. OR user.iuser<0);
		AND link.ilink>0;
		AND ABS(post.ipost) NOT IN (SELECT post2.ipost2 FROM club!post AS post2 WHERE post2.ipost2>0);
		INTO CURSOR x2 ORDER BY 1
	SELECT ABS(post.ipost) AS ipost, MAX(post2.tpost) AS tpost2, MIN(post2.lpost) AS lpost2;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		LEFT JOIN club!post AS post2 ON ABS(post.ipost) = post2.ipost2;
		WHERE link.ilink>0;
		GROUP BY 1;
		HAVING lpost2=.T. AND tpost2<m.dZip;
		INTO CURSOR x1 ORDER BY 1
ELSE
	SELECT DISTINCT post.ipost, post.icategory;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		INNER JOIN club!category ON post.icategory=category.icategory;
		WHERE post.lzip=.F. AND TTOD(post.tpost)<m.dZip;
		AND link.ilink<0;
		AND category.lzip=.T.;
		INTO CURSOR x3 ORDER BY 1
	SELECT DISTINCT ABS(post.ipost) AS ipost;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		WHERE post.ipost2=0 AND TTOD(post.tpost)<m.dZip;
		AND post.lzip=.F.;
		AND link.ilink>0;
		AND ABS(post.ipost) NOT IN (SELECT post2.ipost2 FROM club!post AS post2 WHERE post2.ipost2>0);
		INTO CURSOR x2 ORDER BY 1
	SELECT ABS(post.ipost) AS ipost, MAX(post2.tpost) AS tpost2;
		FROM club!post;
		INNER JOIN club!link ON post.icategory=link.icategory;
		LEFT JOIN club!post AS post2 ON ABS(post.ipost) = post2.ipost2;
		WHERE link.ilink>0;
		GROUP BY 1;
		HAVING tpost2<m.dZip;
		INTO CURSOR x1 ORDER BY 1
ENDIF
IF FLOCK("post")
	LOCAL ARRAY aa(3)
	STORE RECCOUNT("x1") TO aa(1)
	STORE RECCOUNT("x2") TO aa(2)
	STORE RECCOUNT("x3") TO aa(3)
	_Screen.livewallpaper.StopStart(cmes)
	SELECT x1
	SCAN ALL WHILE EMPTY(_Screen.lStop) FOR ipost>0
		=AppProgressBar(RECNO(), aa(1)+aa(2)+aa(3), cmes)
		IF SEEK(ipost, "post", "abs") AND post.lzip=.F.
			SELECT post
			REPLACE lzip WITH .T.
			STORE m.nCount+1 TO nCount
		ENDIF
		SELECT post
		SCAN ALL FOR ipost2=x1.ipost AND lzip=.F.
			REPLACE lzip WITH .T.
			STORE m.nCount+1 TO nCount
		ENDSCAN
	ENDSCAN
	USE
	SELECT x2
	SCAN ALL WHILE EMPTY(_Screen.lStop) FOR SEEK(ipost, "post", "abs")
		=AppProgressBar(RECNO()+aa(1), aa(1)+aa(2)+aa(3), cmes)
		SELECT post
		REPLACE lzip WITH .T.
		STORE m.nCount+1 TO nCount
	ENDSCAN
	USE
	SELECT x3
	SCAN ALL WHILE EMPTY(_Screen.lStop)
		=AppProgressBar(RECNO()+aa(1)+aa(2), aa(1)+aa(2)+aa(3), cmes)
		SELECT post
		LOCATE FOR ABS(ipost) = x3.ipost AND icategory = x3.icategory
		IF FOUND()
			=AppDelRec()
			STORE m.nCount+1 TO nCount
		ENDIF
	ENDSCAN
	USE
	_Screen.livewallpaper.StopStart()
ENDIF
UNLOCK IN post
=AppBlobJob(105)
RETURN m.nCount
