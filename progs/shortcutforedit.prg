IF !POPUP("shortcut")
	DEFINE POPUP shortcut FROM MROW(),MCOL() RELATIVE SHORTCUT
*!*		DEFINE POPUP shortcut FROM MROW(),MCOL() SHORTCUT
	DEFINE BAR _med_cut OF shortcut PROMPT "\<Вырезать" KEY CTRL+X, "Ctrl+ч" MESSAGE "Удаление выделенного фрагмента в буфер обмена"
	*!*	&&MESSAGE "Удаление выделенного фрагмента в буфер обмена"
	DEFINE BAR _med_copy OF shortcut PROMPT "\<Копировать" KEY CTRL+C, "Ctrl+с"
	*!*	&&MESSAGE "Копирование выделенного фрагмента в буфер обмена"
	DEFINE BAR _med_paste OF shortcut PROMPT "Встав\<ить" KEY CTRL+V, "Ctrl+м"
	*!*	&&MESSAGE "Вставка объектов из буфера обмена"
	DEFINE BAR 1 OF shortcut PROMPT "\-"
	DEFINE BAR _med_slcta OF shortcut PROMPT "Вы\<делить все" KEY CTRL+A, "Ctrl+ф"
	*!*	&&MESSAGE "Выделить весь текст"
ENDIF
