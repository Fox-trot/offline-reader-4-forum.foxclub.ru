lPARAMETERS lcRemoteFile,lcLocalFile
STORE IIF(EMPTY(m.lcRemoteFile), "", ALLTRIM(m.lcRemoteFile)) TO lcRemoteFile
*!*	STORE IIF(EMPTY(m.lcLocalFile), ADDBS(GETENV("TEMP"))+ADDBS(SYS(2023))+SYS(3)+".htm", ALLTRIM(m.lcLocalFile)) TO lcLocalFile
DO CASE
CASE EMPTY(m.lcRemoteFile)
CASE EMPTY(_Screen.DownloadMethod)
	LOCAL nInternet, nFichHTTP, nReadFile, nFich, nTama, nLen
	DECLARE LONG GetLastError IN WIN32API
	DECLARE INTEGER InternetCloseHandle IN wininet.dll LONG hInet
	DECLARE LONG InternetOpen IN wininet.dll;
		STRING lpszAgent, LONG dwAccessType, STRING lpszProxyName, STRING lpszProxyBypass, LONG dwFlags
	nInternet = InternetOpen("VFP"+RIGHT(SYS(3),3), 0, "", "", 0)
	IF EMPTY(m.nInternet)	&&	= 0
		IF EMPTY(_Screen.NormalMode)
			WAIT WINDOW "InternetOpen Error:" + STR(GetLastError()) TIMEOUT _Screen.WaitTimeout
		ENDIF
	ELSE
		DECLARE LONG InternetOpenUrl IN wininet.dll;
			LONG hInet, STRING lpszUrl, STRING lpszHeaders, LONG dwHeadersLength, LONG dwFlags, LONG dwContext
		nFichHTTP = InternetOpenUrl(m.nInternet, m.lcRemoteFile, NULL, 0, 0, 0)
		IF EMPTY(m.nFichHTTP)	&& = 0
			IF EMPTY(_Screen.NormalMode)
				WAIT WINDOW "InternetOpenUrl Error:"+STR(GetLastError()) TIMEOUT _Screen.WaitTimeout
			ENDIF
			=InternetCloseHandle(m.nInternet)
		ELSE
			LOCAL nLen, cBuffer
			DECLARE LONG InternetReadFile IN wininet.dll;
				LONG hFtpSession, STRING @lpBuffer, LONG dwNumberOfBytesToRead, LONG @lpNumberOfBytesRead
			nFich = FCREATE(m.lcLocalFile)
			nTama = 0
			nLen = 1
			DO WHILE nLen # 0
				cBuffer = REPLICATE(CHR(0), 1048576)	&&	1024*1024
				nReadFile=InternetReadFile(m.nFichHTTP, @cBuffer, LEN(m.cBuffer), @nLen)
				=FWRITE(m.nFich, SUBSTR(m.cBuffer, 1, m.nLen))
				nTama = m.nTama + m.nLen
*!*		IF EMPTY(_Screen.NormalMode)
*!*			WAIT WIND "Recieved" + STR(m.nTama) TIMEOUT _Screen.WaitTimeout
*!*		ENDIF
			ENDDO
			FCLOSE(m.nFich)
			=InternetCloseHandle(m.nReadFile)
			=InternetCloseHandle(m.nFichHTTP)
			=InternetCloseHandle(m.nInternet)
			RETURN FILE(m.lcLocalFile)
		ENDIF
	ENDIF
OTHERWISE
	DECLARE Integer DeleteUrlCacheEntry IN WinInet String
	DeleteUrlCacheEntry(m.lcRemoteFile)
	Declare Integer URLDownloadToFile In urlmon.Dll INTEGER pCaller, String szURL, String szFileName, INTEGER dwReserved, Integer lpfnCB
	RETURN URLDownloadToFile(0, m.lcRemoteFile, m.lcLocalFile, 0, 0)=0
ENDCASE
RETURN .F.
