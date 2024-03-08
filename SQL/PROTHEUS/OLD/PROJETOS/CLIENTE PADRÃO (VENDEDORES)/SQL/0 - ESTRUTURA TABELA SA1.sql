




--///////////////// Consulta a Estrutura de uma Tabela  \\\\\\\\\\\\\\

SELECT
TABELAS.NAME, COLUNAS.NAME AS COLUNA,TIPOS.NAME AS TIPO,
COLUNAS.LENGTH AS TAMANHO,COLUNAS.ISNULLABLE AS EH_NULO

FROM
sysobjects AS TABELAS,syscolumns AS COLUNAS,systypes AS TIPOS

WHERE
TABELAS.ID = COLUNAS.ID AND COLUNAS.USERTYPE = TIPOS.USERTYPE
AND TABELAS.NAME = 'SB1010' AND SUBSTRING(COLUNAS.NAME,1,4) = 'B1_Z' 
ORDER BY 2


--/////////////// Informação da Criação das Tabelas  \\\\\\\\\\\\\\\\\\\

SELECT name, crdate
FROM sysobjects
WHERE xtype= 'U' AND name LIKE 'Z%'
ORDER BY crdate desc