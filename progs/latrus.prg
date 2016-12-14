LPARAMETERS lLatRus
DECLARE INTEGER ActivateKeyboardLayout IN win32api INTEGER,INTEGER

*!*	Переключение на кириллицу
*ActivateKeyboardLayout(68748313,0) && Русский

*!*	Переключение на латиницу
*ActivateKeyboardLayout(67699721,0) && Английский

ActivateKeyboardLayout(IIF(EMPTY(lLatRus), 67699721, 68748313),0)
*!*	CLEAR DLLS
