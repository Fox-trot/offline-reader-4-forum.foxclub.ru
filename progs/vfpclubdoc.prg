LPARAMETERS nParam, uParam
#DEFINE vfpclubdoc "vfpclubdoc"
DO CASE
CASE EMPTY(m.nParam)
CASE VARTYPE(_Screen.adox(m.nParam))="O"
	DO CASE
	CASE INLIST(m.nParam, 1, 2, 4, 5, 6)
		IF !EMPTY(m.uParam) AND INDEXSEEK(m.uParam, .F., "category", "icategory")
			=SEEK(m.uParam, "category", "icategory")
			DO CASE
			CASE m.nParam=2
				_Screen.adox(m.nParam).chkFind.Value=0
				_Screen.adox(m.nParam).chkCategory.Value=1
				_Screen.adox(m.nParam).cboCategory.Value=category.ccategory
			CASE INLIST(_Screen.PostViewer,1,11)
				_Screen.adox(m.nParam).uReturn = m.uParam
			OTHERWISE
				_Screen.adox(m.nParam).lstCategory.Value=category.ccategory
			ENDCASE
		ENDIF
	CASE m.nParam=3
		IF !EMPTY(m.uParam) AND INDEXSEEK(ABS(m.uParam), .F., "user", "abs")
			_Screen.adox(m.nParam).uParameter = ABS(m.uParam)
			_Screen.adox(m.nParam).uMethod
		ENDIF
	OTHERWISE
		_Screen.adox(m.nParam).uMethod
	ENDCASE
	_Screen.adox(m.nParam).Show
CASE INLIST(m.nParam,1,4,5) AND INLIST(_Screen.PostViewer,1,11)
	IF IIF(EMPTY(m.uParam), .T., !INDEXSEEK(m.uParam, .F., "category", "icategory"))
		DO FORM vfpclubcategory01s TO uParam WITH _Screen.DefaultCategory
	ENDIF
	IF !EMPTY(m.uParam)
		DO FORM vfpclubdoc+PADL(TRANSFORM(_Screen.PostViewer), 2, "0") NAME _Screen.adox(m.nParam) WITH m.uParam, IIF(m.nParam=5, 3, MIN(m.nParam, 2))
	ENDIF
CASE INLIST(m.nParam, 1, 4, 5)
	DO FORM vfpclubdoc+PADL(TRANSFORM(_Screen.PostViewer), 2, "0") NAME _Screen.adox(m.nParam) WITH IIF(EMPTY(m.uParam), _Screen.DefaultCategory, m.uParam), IIF(m.nParam=5, 3, MIN(m.nParam, 2))
CASE m.nParam=2
	DO FORM vfpclubdoc+IIF(_Screen.PostViewer>10, "21", "20") NAME _Screen.adox(m.nParam) WITH m.uParam
CASE m.nParam=3
	DO FORM vfpclubdoc+IIF(_Screen.PostViewer>10, "31", "30") NAME _Screen.adox(m.nParam) WITH m.uParam
*!*		DO FORM vfpclubdoc+TRANSFORM(_Screen.PostViewer+40) NAME _Screen.adox(m.nParam) WITH m.uParam
CASE m.nParam=6 AND INLIST(_Screen.PostViewer,1,11)
	IF IIF(EMPTY(m.uParam), .T., !INDEXSEEK(m.uParam, .F., "category", "icategory"))
		DO FORM vfpclubcategory01s TO uParam WITH _Screen.DefaultRSS,.T.
	ENDIF
	IF !EMPTY(m.uParam)
		DO FORM vfpclubdoc11 NAME _Screen.adox(m.nParam) WITH m.uParam
	ENDIF
CASE m.nParam=6
	DO FORM vfpclubdoc12 NAME _Screen.adox(m.nParam) WITH IIF(EMPTY(m.uParam), _Screen.DefaultRSS, m.uParam)
*!*	OTHERWISE
*!*		MESSAGEBOX("На стадии разработки",16,_Screen.Caption)
ENDCASE

EXTERNAL FORM vfpclubdoc01, vfpclubdoc02, vfpclubdoc11, vfpclubdoc12, vfpclubdoc20, vfpclubdoc21
EXTERNAL FORM vfpclubdoc30, vfpclubdoc31
