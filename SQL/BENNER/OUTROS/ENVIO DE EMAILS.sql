
SELECT *
--UPDATE Z_EMAILS SET STATUS = '2'
FROM Z_EMAILS 
WHERE 1=1
AND ASSUNTO LIKE '%NOTIFICAÇÃO - NFS-e%' 
AND PARA NOT IN ('pessoafisicarecebe@yahoo.com.br','pessoafisica@yahoo.com.br','pessoafisicarecebe@yahoo.com','pessoafisicarecebe@hotmail.com','pessoafisicarecebe@gmail.com','pessoafisicarecebe@yahgoo.com.br','pessoafisicarecebe@yahoo.combr','pessoafiisicarecebe@yahoo.com.br','pessaofisicarecebe@yahoo.com.br','pessoafiscarecebe@yahoo.com.br','pessoafisica@hotmail.com','pessoafisicafisica@yahoo.com.br','pessoafisicarece@yahoo.com.br','pessoafisicareceb@yahoo.com.br','pessoafisicarecebe@yahooo.com.br','pessoafisicarecebe@yhaoo.com.br','pessoafisicarecebeyahoo.com.br','pessoafisicareceeb@yahoo.com.br')
AND ERRO IS NULL



