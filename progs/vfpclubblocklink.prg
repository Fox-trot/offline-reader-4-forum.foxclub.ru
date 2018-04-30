LPARAMETERS nParam
IF !EMPTY(m.nParam) AND IIF(ABS(m.nParam)=ABS(Link.iLink), .T., SEEK(m.nParam, "link", "abs")) AND RLOCK("link")
	SELECT link
	IF INDEXSEEK(link.icategory, .F., "category", "icategory")
		DO CASE
		CASE !lLink AND nLink < 99
			REPLACE nLink WITH MAX(nLink, 0) + 1
		CASE !lLink
			REPLACE lLink WITH .T.
		ENDCASE
	ELSE
		DELETE
	ENDIF
	UNLOCK
ENDIF
