/*-----------------------SB9 - FILIAL - 0102/0103---------------------------*/

SELECT 
* 
FROM SB9010 
WHERE 1=1
AND D_E_L_E_T_ = ''
AND YEAR(B9_DATA) = 2017
AND B9_COD = 'LB012F'
AND B9_FILIAL = '0101'


SELECT 
* 
FROM SB9010 
WHERE 1=1
AND D_E_L_E_T_ = ''
AND YEAR(B9_DATA) = 2017
AND B9_COD = 'LB016F'
AND B9_FILIAL = '0103'

/*-----------------------SD1 - FILIAL - 0102/0103---------------------------*/

SELECT
D1_FILIAL,
D1_DTDIGIT,
D1_COD,
D1_QUANT, 
* 
FROM SD1010
WHERE 1=1
AND D_E_L_E_T_ = ''
AND D1_FILIAL = '0102'
AND D1_COD = 'LB016F'
AND YEAR(D1_DTDIGIT) = 2018
AND MONTH(D1_DTDIGIT) = 1 


SELECT
D1_FILIAL,
D1_DTDIGIT,
D1_COD,
D1_QUANT, 
* 
FROM SD1010
WHERE 1=1
AND D_E_L_E_T_ = ''
AND D1_FILIAL = '0103'
AND D1_COD = 'LB016F'
AND YEAR(D1_DTDIGIT) = 2018
AND MONTH(D1_DTDIGIT) = 1 


/*-----------------------SD2 - FILIAL - 0102/0103---------------------------*/


SELECT 
D2_FILIAL,
D2_COD,
D2_EMISSAO,
D2_QUANT,
* 
FROM SD2010
WHERE 1=1
AND D_E_L_E_T_ = ''
AND D2_FILIAL = '0102'
AND D2_COD = 'LB016F'
AND YEAR(D2_EMISSAO) = 2018
AND MONTH(D2_EMISSAO) = 1 


SELECT 
D2_FILIAL,
D2_COD,
D2_EMISSAO,
D2_QUANT,
* 
FROM SD2010
WHERE 1=1
AND D_E_L_E_T_ = ''
AND D2_FILIAL = '0103'
AND D2_COD = 'LB016F'
AND YEAR(D2_EMISSAO) = 2018
AND MONTH(D2_EMISSAO) = 1 


/*-----------------------SD3(ENTRADA) - FILIAL - 0102/0103---------------------------*/

SELECT 
D3_FILIAL,
D3_COD,
D3_EMISSAO,
D3_TM,
D3_QUANT,
*
FROM SD3010 
WHERE 1=1
AND D_E_L_E_T_ = '' 
AND D3_FILIAL = '0102' 
AND D3_COD = 'LB016F' 
AND D3_TM <= 499 
AND YEAR(D3_EMISSAO) = 2018
AND MONTH(D3_EMISSAO) = 1 

SELECT 
D3_FILIAL,
D3_COD,
D3_EMISSAO,
D3_TM,
D3_QUANT,
*
FROM SD3010 
WHERE 1=1
AND D_E_L_E_T_ = '' 
AND D3_FILIAL = '0103' 
AND D3_COD = 'LB016F' 
AND D3_TM <= 499 
AND YEAR(D3_EMISSAO) = 2018
AND MONTH(D3_EMISSAO) = 1 


/*-----------------------SD3(SAIDA) - FILIAL - 0102/0103---------------------------*/


SELECT 
D3_FILIAL,
D3_COD,
D3_EMISSAO,
D3_TM,
D3_QUANT,
*
FROM SD3010 
WHERE 1=1
AND D_E_L_E_T_ = '' 
AND D3_FILIAL = '0102' 
AND D3_COD = 'LB016F' 
AND D3_TM >= 500
AND YEAR(D3_EMISSAO) = 2018
AND MONTH(D3_EMISSAO) = 1 

SELECT 
D3_FILIAL,
D3_COD,
D3_EMISSAO,
D3_TM,
D3_QUANT,
*
FROM SD3010 
WHERE 1=1
AND D_E_L_E_T_ = '' 
AND D3_FILIAL = '0103' 
AND D3_COD = 'LB016F' 
AND D3_TM >= 500
AND YEAR(D3_EMISSAO) = 2018
AND MONTH(D3_EMISSAO) = 1 


/*--------------------------TODOS JUNTOS-------------------------------*/

DECLARE @FILIAL VARCHAR (4)
DECLARE @cDatIni VARCHAR(8)
DECLARE @cDatFim VARCHAR(8)

SET @FILIAL = '0101'
SET @cDatIni   = 	'2019/01/01'
SET @cDatFim   = 	'2020/12/31' 

SELECT 	@FILIAL AS FILIAL,
		A.B1_COD   	  AS COD_PROD,
		A.B1_DESC  	  AS PRODUTO,
		A.B1_UM    	  AS UND,  
		ISNULL(( SELECT SUM(B9_QINI)  FROM SB9010 WHERE B9_FILIAL = '0101' AND  D_E_L_E_T_ = '' AND B9_COD = A.B1_COD AND YEAR(B9_DATA) = 2017),0) AS SLD_INI_SB9,
		ISNULL(( SELECT SUM(D1_QUANT) FROM SD1010 AS SD1, SF4010 AS SF4 WHERE SD1.D1_FILIAL = '0101' AND SD1.D_E_L_E_T_ = ''  AND SF4.D_E_L_E_T_ = '' AND SD1.D1_COD = A.B1_COD AND SD1.D1_DTDIGIT BETWEEN @cDatIni AND @cDatFim AND SD1.D1_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S'),0) AS QTD_ENT_SD1,
		ISNULL(( SELECT SUM(D2_QUANT) FROM SD2010 AS SD2, SF4010 AS SF4 WHERE SD2.D2_FILIAL = '0101' AND SD2.D_E_L_E_T_ = ''  AND SF4.D_E_L_E_T_ = '' AND SD2.D2_COD = A.B1_COD AND SD2.D2_EMISSAO BETWEEN @cDatIni AND @cDatFim AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S'),0) AS QTD_SAI_SD2,
		ISNULL(( SELECT SUM(D3_QUANT) FROM SD3010 WHERE D3_FILIAL = '0101' AND D_E_L_E_T_ = ''  AND D3_COD = A.B1_COD AND D3_TM <= 499 AND D3_EMISSAO BETWEEN @cDatIni AND @cDatFim),0) AS QTD_ENT_SD3,
		ISNULL(( SELECT SUM(D3_QUANT) FROM SD3010 WHERE D3_FILIAL = '0101' AND D_E_L_E_T_ = '' AND D3_COD = A.B1_COD AND D3_TM >= 500 AND D3_EMISSAO BETWEEN @cDatIni AND @cDatFim),0) AS QTD_SAI_SD3,
	 	ISNULL((SELECT TOP 1 B9_CUSTD FROM SB9010 WHERE B9_FILIAL = '0101' AND D_E_L_E_T_ = '' AND B9_COD = A.B1_COD AND  YEAR(B9_DATA) = 2017 AND MONTH(B9_DATA) = 12),0) AS CUSTO_INI									
FROM SB1010 A 
LEFT JOIN SD1010 B ON A.B1_COD = B.D1_COD AND B.D_E_L_E_T_ = ''
LEFT JOIN SD2010 C ON A.B1_COD = C.D2_COD AND C.D_E_L_E_T_ = '' 
LEFT JOIN SD3010 D ON A.B1_COD = D.D3_COD AND D.D_E_L_E_T_ = '' 
LEFT JOIN SB9010 E ON A.B1_COD = E.B9_COD AND E.D_E_L_E_T_ = '' 
WHERE 1=1
AND A.D_E_L_E_T_ = ''
--AND SUBSTRING(A.B1_GRUPO,1,2) <> 'MR'
AND A.B1_COD  IN ('LB012F' , 'LB016F')
GROUP BY A.B1_COD, A.B1_DESC, A.B1_UM





SELECT * FROM SC1010

SELECT * FROM ZZ5010


SELECT * FROM TMPAUXFILIAL

SELECT * FROM SB1010 WHERE D_E_L_E_T_ = ''AND SUBSTRING(B1_GRUPO,1,2) <> 'MR'