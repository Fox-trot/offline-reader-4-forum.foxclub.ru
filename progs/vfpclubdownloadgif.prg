WITH _Screen
	IF .InternetInUse=1 AND !EMPTY(.Quote) AND .PostViewer>10
		IF !FILE(ADDBS(SYS(2023))+.CSS)
			=VFPHTTP(.CSSLink+.CSS, ADDBS(SYS(2023))+.CSS)
		ENDIF
		IF !EMPTY(.Smile)
			SELECT DISTINCT Quote.iquote, Quote.cquote2;
				FROM club!Quote;
				WHERE Quote.iquote<0 AND Quote.lquote=.T. AND Quote.cquote>[ ] AND EMPTY(Quote.cquote2)=.F.;
				INTO CURSOR x1;
				ORDER BY Quote.iquote DESC
			.livewallpaper.StopStart("Get Gifs from Internet")
			SCAN ALL
				=AppProgressBar(RECNO(), RECCOUNT(), "Get Gifs from Internet")
				DO CASE
				CASE .lStop
					EXIT
				CASE !FILE(.GRAPHICS+ALLTRIM(cquote2))
					DO CASE
					CASE !VFPHTTP(.SmileLink+ALLTRIM(cquote2), .GRAPHICS+ALLTRIM(cquote2))
						IF SEEK(iquote, "quote", "iquote") AND RLOCK("quote")
							SELECT Quote
							REPLACE lquote WITH .F.
						ENDIF
						UNLOCK IN Quote
					CASE FILE(.GRAPHICS+ALLTRIM(cquote2)) AND AT([HTML>], UPPER(FILETOSTR(.GRAPHICS+ALLTRIM(cquote2))))+AT([head>], UPPER(FILETOSTR(.GRAPHICS+ALLTRIM(cquote2))))>0
						=AppErase(.GRAPHICS+ALLTRIM(cquote2))
					ENDCASE
				ENDCASE
			ENDSCAN
			.livewallpaper.StopStart()
			USE
		ENDIF
	ENDIF
ENDWITH
