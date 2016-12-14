LPARAMETERS cWord
STORE IIF(EMPTY(m.cWord), "", ALLTRIM(m.cWord)) TO cWord
STORE STRTRAN(m.cWord, [&nbsp;], [ ]) TO cWord
STORE STRTRAN(m.cWord, [&quot;], ["]) TO cWord
STORE STRTRAN(m.cWord, [&mdash;], CHR(151)) TO cWord
STORE STRTRAN(m.cWord, [&laquo;], CHR(171)) TO cWord
STORE STRTRAN(m.cWord, [&raquo;], CHR(187)) TO cWord
RETURN m.cWord