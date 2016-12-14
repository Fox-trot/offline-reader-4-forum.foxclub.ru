CLOSE DATABASES
SET EXCLUSIVE ON

OPEN DATABASE data\club
SELECT 0

USE blob
ZAP

USE category
DELETE FOR icategory < 0
PACK

USE favorite
ZAP

USE link
DELETE FOR iLink < 0

USE Link2
ZAP

USE quote
ZAP

USE post
DELETE FOR icategory <> 3671054301
PACK
REPLACE ALL lpost WITH .f., lzip WITH .f.

USE user
DELETE FOR iuser<0 AND iuser=nuser
PACK
REPLACE ALL luser WITH .f., mUser WITH ""

