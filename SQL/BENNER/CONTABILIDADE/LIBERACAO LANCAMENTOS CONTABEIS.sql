/* ---------------------------------------------------|
|                                                     |
|------------------- CT_DOCUMENTOS -------------------|
|                                                     |
| BLOQUEADO = S (BLOQUEADO)                           |
| BLOQUEADO = N (LIBERADO)                            |
|                                                     |
|------------------ CT_LANCAMENTOS -------------------|
|                                                     |
| LANCAMENTOGERADO = B (BLOQUEADO)                    |
| LANCAMENTOGERADO = N (LIBERADO)                     |
|                                                     |
| BLOQUEADO = S (BLOQUEADO)                           |
| BLOQUEADO = N (LIBERADO)                            |
|                                                     |
|----------------------------------------------------*/


/* ------------------ UPDATE DOCUMENTO ------------------ */

SELECT 
BLOQUEADO,
* 
--UPDATE CT_DOCUMENTOS SET BLOQUEADO = 'N'
FROM CT_DOCUMENTOS 
WHERE 1=1
AND DOCUMENTOCONTABIL IN ('CONTABIL-RP-JAN23')


/* ------------------ UPDATE LANCAMENTO ------------------ */

SELECT 
A.DOCUMENTOCONTABIL,
B.LANCAMENTOGERADO,
B.BLOQUEADO,
B.*
--UPDATE CT_LANCAMENTOS SET BLOQUEADO = 'N' , LANCAMENTOGERADO = 'N'
FROM CT_DOCUMENTOS A
LEFT JOIN CT_LANCAMENTOS B ON B.DOCUMENTO = A.HANDLE
WHERE 1=1
AND A.DOCUMENTOCONTABIL = 'CONTABIL-RP-JAN23'
--AND B.NATUREZA = 'C'



/* ----------------- DELETAR LANÇAMENTOS CONTABEIS ----------------- */

--DELETE FROM CT_DOCUMENTOS WHERE HANDLE IN (1042764)

--DELETE FROM CT_LANCAMENTOS WHERE DOCUMENTO IN (1042764)

--DELETE FROM CT_LANCAMENTOCC WHERE DOCUMENTO IN (1042764)


/* -------------- VERIFICAR OS DOCUMENTOS/LANÇAMENTOS --------------- */


SELECT * FROM CT_DOCUMENTOS WHERE HANDLE IN (1042764)

SELECT * FROM CT_LANCAMENTOS WHERE DOCUMENTO IN (1042764)

SELECT * FROM CT_LANCAMENTOCC WHERE DOCUMENTO IN (1042764)

