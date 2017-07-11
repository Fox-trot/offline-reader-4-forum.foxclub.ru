LPARAMETERS txtFind, chkWord, chkCpost, chkMpost, icategory, dFind, chkFind
cFind = GETWORDNUM(IIF(EMPTY(chkWord), LOWER(txtFind), txtFind), 1)
DIMENSION aFind[MAX(1, GETWORDCOUNT(txtFind))]
aFind[1] = IIF(EMPTY(chkFind), cFind, '')

DO CASE
CASE EMPTY(txtFind) OR (EMPTY(chkCpost) AND EMPTY(chkMpost))
	SELECT SPACE(10) AS cpost, SPACE(10) AS cuser, {} AS tpost, SPACE(10) AS cCategory, 0 AS ipost, 0 AS ipost2, .F. AS lpost;
		FROM club!category;
		WHERE .F.;
		INTO CURSOR C1
	RETURN
		
CASE !EMPTY(chkFind) AND USED('C1') AND RECCOUNT('C1')>0
	IF !EMPTY(m.icategory)
		IF EMPTY(dFind)
			SELECT C1.*;
				FROM C1;
				INNER JOIN club!post ON C1.iPost=post.iPost;
				WHERE post.icategory = m.icategory;
				INTO CURSOR C1
		ELSE
			SELECT C1.*;
				FROM C1;
				INNER JOIN club!post ON C1.iPost=post.iPost;
				WHERE post.icategory = m.icategory;
				AND post.tPost >= dFind;
				INTO CURSOR C1
		ENDIF
	ELSE
		IF !EMPTY(dFind)
			SELECT *;
				FROM C1;
				WHERE post.tPost >= dFind;
				INTO CURSOR C1
		ENDIF
	ENDIF	
CASE !EMPTY(chkCpost) AND !EMPTY(chkMpost)
	IF !EMPTY(m.icategory)
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND (cFind $ LOWER(post.cPost) OR cFind $ LOWER(post.mPost));
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND (cFind $ post.cPost OR cFind $ post.mPost);
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND (cFind $ LOWER(post.cPost) OR cFind $ LOWER(post.mPost));
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND (cFind $ post.cPost OR cFind $ post.mPost);
					INTO CURSOR C1
			ENDIF
		ENDIF
	ELSE
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE (cFind $ LOWER(post.cPost) OR cFind $ LOWER(post.mPost));
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE (cFind $ post.cPost OR cFind $ post.mPost);
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND (cFind $ LOWER(post.cPost) OR cFind $ LOWER(post.mPost));
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND (cFind $ post.cPost OR cFind $ post.mPost);
					INTO CURSOR C1
			ENDIF
		ENDIF
	ENDIF
	
CASE !EMPTY(chkCpost)
	IF !EMPTY(m.icategory)
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND cFind $ LOWER(post.cPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND cFind $ post.cPost;
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND cFind $ LOWER(post.cPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND cFind $ post.cPost;
					INTO CURSOR C1
			ENDIF
		ENDIF
	ELSE
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE cFind $ LOWER(post.cPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE cFind $ post.cPost;
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND cFind $ LOWER(post.cPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND cFind $ post.cPost;
					INTO CURSOR C1
			ENDIF
		ENDIF
	ENDIF

CASE !EMPTY(chkMpost)
	IF !EMPTY(m.icategory)
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND cFind $ LOWER(post.mPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND cFind $ post.mPost;
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND cFind $ LOWER(post.mPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.icategory = m.icategory;
					AND post.tPost >= dFind;
					AND cFind $ post.mPost;
					INTO CURSOR C1
			ENDIF
		ENDIF
	ELSE
		IF EMPTY(dFind)
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE cFind $ LOWER(post.mPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE cFind $ post.mPost;
					INTO CURSOR C1
			ENDIF
		ELSE
			IF EMPTY(chkWord)
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND cFind $ LOWER(post.mPost);
					INTO CURSOR C1
			ELSE
				SELECT post.cpost, user.cuser, post.tpost, category.cCategory, post.ipost, post.ipost2, post.lpost;
					FROM club!post;
					INNER JOIN club!category ON post.iCategory = category.iCategory;
					INNER JOIN club!user ON post.iuser = user.iuser;
					WHERE post.tPost >= dFind;
					AND cFind $ post.mPost;
					INTO CURSOR C1
			ENDIF
		ENDIF
	ENDIF

OTHERWISE
	SELECT post.cpost, user.cuser, post.tpost, post.ipost, post.ipost2, post.lpost;
		FROM club!post;
		INNER JOIN club!user ON .F.;
		INTO CURSOR C1
ENDCASE
*!*	IF GETWORDCOUNT(txtFind) > 1
	FOR ii=IIF(EMPTY(chkFind), 2, 1) TO GETWORDCOUNT(txtFind)
		cFind = GETWORDNUM(IIF(EMPTY(chkWord), LOWER(txtFind), txtFind), m.ii)
		DO CASE
		CASE ASCAN(aFind, cFind) > 0
			LOOP
		CASE !EMPTY(chkCpost) AND !EMPTY(chkMpost)
			IF EMPTY(chkWord)
				SELECT C1.*;
					FROM C1;
					INNER JOIN club!post ON C1.iPost=post.iPost;
					WHERE (cFind $ LOWER(C1.cPost) OR cFind $ LOWER(post.mPost));
					INTO CURSOR C1
			ELSE
				SELECT C1.*;
					FROM C1;
					INNER JOIN club!post ON C1.iPost=post.iPost;
					WHERE (cFind $ C1.cPost OR cFind $ post.mPost);
					INTO CURSOR C1
			ENDIF
				
		CASE !EMPTY(chkCpost)
			IF EMPTY(chkWord)
				SELECT *;
					FROM C1;
					WHERE cFind $ LOWER(cPost);
					INTO CURSOR C1
			ELSE
					SELECT *;
						FROM C1;
						WHERE cFind $ cPost;
						INTO CURSOR C1
			ENDIF
				
		CASE !EMPTY(chkMpost)
			IF EMPTY(chkWord)
				SELECT C1.*;
					FROM C1;
					INNER JOIN club!post ON C1.iPost=post.iPost;
					WHERE cFind $ LOWER(post.mPost);
					INTO CURSOR C1
			ELSE
				SELECT C1.*;
					FROM C1;
					INNER JOIN club!post ON C1.iPost=post.iPost;
					WHERE cFind $ post.mPost;
					INTO CURSOR C1
			ENDIF
		ENDCASE
		aFind[ii] = cFind
	ENDFOR
*!*	ENDIF
