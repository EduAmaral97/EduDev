
/* ------------------ PROJETOS ----------------- */

SELECT 
CODIGOREDUZIDO,
* 
FROM GN_PROJETOS 
WHERE 1=1
--AND CODIGOREDUZIDO = 1042

/*------------------ CENTRO DE CUSTOS --------------------*/

SELECT
* 
FROM CT_CC 
WHERE 1=1
--AND NOME LIKE '%ADM%'

/* ------------------ OPERACOES ----------------- */

SELECT 
CODIGOREDUZIDO,  
* 
FROM GN_OPERACOES 
WHERE 1=1
--AND CODIGOREDUZIDO = 1202

/* ------------------ CONTAS ----------------- */

SELECT   
* 
FROM FN_CONTAS 
WHERE 1=1
--AND CODIGOREDUZIDO = 4059

/* ----------------- TIPOS DE CONTAS ------------------ */

SELECT 
CODIGOREDUZIDO, 
* 
FROM FN_TIPOSDOCUMENTOS 
WHERE 1=1
--AND HANDLE = 34

